package com.klangor.app

import android.content.ContentProvider
import android.content.ContentValues
import android.database.Cursor
import android.net.Uri
import android.os.ParcelFileDescriptor
import android.util.Base64
import android.util.Log
import java.io.File
import java.net.HttpURLConnection
import java.net.URL
import java.security.MessageDigest
import java.util.concurrent.ConcurrentHashMap

/**
 * ContentProvider that serves artwork images to Android Auto.
 *
 * Android Auto only supports content:// and android.resource:// URIs for artwork.
 * This provider accepts a base64url-encoded HTTP URL in the path, downloads the
 * image (with disk caching), and returns a ParcelFileDescriptor.
 *
 * URI format: content://com.klangor.app.artwork/{base64url_encoded_http_url}
 *
 * Android Auto walks its whole category tree right after connecting (artists,
 * albums, playlists, podcasts, radio, etc. all at once), so this provider can see
 * a burst of concurrent/repeated requests, including on weak or absent cellular
 * connections while driving. To keep that from turning into a pile of blocking,
 * repeated 5-15s network stalls, requests are coalesced per URL and failures are
 * remembered for a short period instead of being retried on every call.
 *
 * The cache directory (`shared_artwork`, under `context.cacheDir`) and hashing
 * scheme (MD5 of the URL) are a deliberate shared convention with the Dart-side
 * `ImageService` (`lib/services/image_service.dart`), which uses the same
 * directory name under `path_provider`'s `getTemporaryDirectory()` - the same
 * absolute path on Android. Whichever side fetches a given URL first leaves it
 * here for the other to reuse, without any IPC between them. Do not rename this
 * directory without updating `ImageService.cacheDirName` to match.
 */
class ArtworkContentProvider : ContentProvider() {

    companion object {
        private const val TAG = "KlangorArtwork"
        private const val CONNECT_TIMEOUT_MS = 3000
        private const val READ_TIMEOUT_MS = 5000
        // Don't retry a URL that just failed - avoids repeating a slow/failing
        // fetch every time the same artwork scrolls back into view.
        private const val NEGATIVE_CACHE_TTL_MS = 60_000L

        // Coalesces concurrent openFile() calls for the same artwork into a
        // single download rather than racing multiple redundant fetches.
        private val inFlight = ConcurrentHashMap<String, Any>()
        // hash -> timestamp of last failure.
        private val recentFailures = ConcurrentHashMap<String, Long>()
    }

    override fun onCreate(): Boolean = true

    override fun openFile(uri: Uri, mode: String): ParcelFileDescriptor? {
        val encoded = uri.lastPathSegment ?: return null
        val httpUrl: String
        try {
            httpUrl = String(Base64.decode(encoded, Base64.URL_SAFE or Base64.NO_WRAP))
        } catch (e: Exception) {
            return null
        }

        val cacheDir = File(context?.cacheDir, "shared_artwork")
        if (!cacheDir.exists()) cacheDir.mkdirs()

        val hash = md5(httpUrl)
        val cacheFile = File(cacheDir, hash)

        if (cacheFile.exists()) {
            Log.d(TAG, "cache hit: $hash")
            return ParcelFileDescriptor.open(cacheFile, ParcelFileDescriptor.MODE_READ_ONLY)
        }

        val lastFailure = recentFailures[hash]
        if (lastFailure != null && System.currentTimeMillis() - lastFailure < NEGATIVE_CACHE_TTL_MS) {
            val ageMs = System.currentTimeMillis() - lastFailure
            Log.d(TAG, "negative-cache hit for $hash (failed ${ageMs}ms ago) - not retrying yet")
            return null
        }

        val alreadyInFlight = inFlight.containsKey(hash)
        val lock = inFlight.computeIfAbsent(hash) { Any() }
        if (alreadyInFlight) {
            Log.d(TAG, "coalescing onto in-flight fetch for $hash")
        }
        synchronized(lock) {
            try {
                // Another thread may have finished the download while this one
                // was waiting for the lock.
                if (cacheFile.exists()) {
                    Log.d(TAG, "cache hit after waiting for coalesced fetch: $hash")
                    return ParcelFileDescriptor.open(cacheFile, ParcelFileDescriptor.MODE_READ_ONLY)
                }

                Log.d(TAG, "fetching $hash from network")
                try {
                    val connection = URL(httpUrl).openConnection() as HttpURLConnection
                    connection.connectTimeout = CONNECT_TIMEOUT_MS
                    connection.readTimeout = READ_TIMEOUT_MS
                    connection.instanceFollowRedirects = true
                    try {
                        connection.inputStream.use { input ->
                            cacheFile.outputStream().use { output ->
                                input.copyTo(output)
                            }
                        }
                    } finally {
                        connection.disconnect()
                    }
                    recentFailures.remove(hash)
                    Log.d(TAG, "fetch succeeded for $hash (${cacheFile.length()} bytes)")
                } catch (e: Exception) {
                    cacheFile.delete()
                    recentFailures[hash] = System.currentTimeMillis()
                    Log.e(TAG, "fetch failed for $hash: ${e.message}")
                    return null
                }

                return ParcelFileDescriptor.open(cacheFile, ParcelFileDescriptor.MODE_READ_ONLY)
            } finally {
                inFlight.remove(hash, lock)
            }
        }
    }

    override fun query(uri: Uri, projection: Array<String>?, selection: String?,
                       selectionArgs: Array<String>?, sortOrder: String?): Cursor? = null
    override fun getType(uri: Uri): String = "image/*"
    override fun insert(uri: Uri, values: ContentValues?): Uri? = null
    override fun delete(uri: Uri, selection: String?, selectionArgs: Array<String>?): Int = 0
    override fun update(uri: Uri, values: ContentValues?, selection: String?,
                        selectionArgs: Array<String>?): Int = 0

    private fun md5(input: String): String {
        val digest = MessageDigest.getInstance("MD5")
        val bytes = digest.digest(input.toByteArray())
        return bytes.joinToString("") { "%02x".format(it) }
    }
}
