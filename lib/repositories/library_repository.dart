import 'dart:convert';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../services/database_service.dart';
import '../models/media_item.dart';

/// The only place "artist's albums" / "album's tracks" / "playlist's tracks"
/// queries are answered from, backed by the relational tables in
/// `database.dart` (`Artists`/`Albums`/`Tracks`/`Playlists`/`PlaylistTracks`/
/// `ProviderMappings`).
///
/// Exposes the same one-shot `Future`-returning shape the existing
/// `MusicAssistantProvider.getXWithCache` methods already have, so screens
/// can cut over one at a time without a UI rewrite - see the plan's Phase 5
/// notes for why (`CacheService`/`SyncService`/`LibraryStatusService`
/// currently overlap as three independent, partially-synced caches; this
/// repository is what replaces all three, one screen at a time).
class LibraryRepository {
  final AppDatabase _db;

  LibraryRepository([AppDatabase? db]) : _db = db ?? DatabaseService.instance.db;

  /// Shared default instance for call sites that don't need a test-injected
  /// database (mirrors `ImageService.instance`).
  static final LibraryRepository instance = LibraryRepository();

  // ============================================================================
  // READ
  // ============================================================================

  /// Albums credited to the given artist name. Matches by name, not id,
  /// because that's the relationship this app actually has today (an
  /// album's artists are stored denormalized - see [upsertAlbum] - there is
  /// no "artist_id" foreign key on the album row to join against).
  Future<List<Album>> getArtistAlbums(String artistName) async {
    final rows = await _db.select(_db.albums).get();
    final needle = artistName.trim().toLowerCase();
    final matches = <Album>[];
    for (final row in rows) {
      final album = await _albumFromEntity(row);
      final hasArtist = album.artists?.any((a) => a.name.trim().toLowerCase() == needle) ?? false;
      if (hasArtist) matches.add(album);
    }
    return matches;
  }

  /// Tracks belonging to the given album, in order.
  Future<List<Track>> getAlbumTracks(String provider, String itemId) async {
    final query = _db.select(_db.tracks)
      ..where((t) => t.albumProvider.equals(provider))
      ..where((t) => t.albumItemId.equals(itemId))
      ..orderBy([(t) => OrderingTerm.asc(t.position)]);
    final rows = await query.get();
    return Future.wait(rows.map(_trackFromEntity));
  }

  /// Tracks belonging to the given playlist, in order, via [PlaylistTracks].
  Future<List<Track>> getPlaylistTracks(String provider, String itemId) async {
    final joinQuery = _db.select(_db.playlistTracks)
      ..where((pt) => pt.playlistProvider.equals(provider))
      ..where((pt) => pt.playlistItemId.equals(itemId))
      ..orderBy([(pt) => OrderingTerm.asc(pt.position)]);
    final joinRows = await joinQuery.get();

    final tracks = <Track>[];
    for (final join in joinRows) {
      final trackQuery = _db.select(_db.tracks)
        ..where((t) => t.provider.equals(join.trackProvider))
        ..where((t) => t.itemId.equals(join.trackItemId));
      final trackRow = await trackQuery.getSingleOrNull();
      if (trackRow != null) tracks.add(await _trackFromEntity(trackRow));
    }
    return tracks;
  }

  Future<List<Artist>> getAllArtists() async {
    final rows = await _db.select(_db.artists).get();
    return Future.wait(rows.map(_artistFromEntity));
  }

  Future<List<Album>> getAllAlbums() async {
    final rows = await _db.select(_db.albums).get();
    return Future.wait(rows.map(_albumFromEntity));
  }

  Future<List<Playlist>> getAllPlaylists() async {
    final rows = await _db.select(_db.playlists).get();
    return Future.wait(rows.map(_playlistFromEntity));
  }

  // ============================================================================
  // WRITE (used by the sync engine)
  // ============================================================================

  Future<void> upsertArtist(Artist artist) async {
    await _db.into(_db.artists).insertOnConflictUpdate(ArtistsCompanion.insert(
          provider: artist.provider,
          itemId: artist.itemId,
          name: artist.name,
          sortName: Value(artist.sortName),
          uri: Value(artist.uri),
          favorite: Value(artist.favorite == true),
          inLibrary: Value(artist.inLibrary),
          metadataJson: Value(artist.metadata != null ? jsonEncode(artist.metadata) : null),
          lastSynced: DateTime.now(),
        ));
    await _replaceProviderMappings('artist', artist.provider, artist.itemId, artist.providerMappings);
  }

  Future<void> upsertAlbum(Album album) async {
    await _db.into(_db.albums).insertOnConflictUpdate(AlbumsCompanion.insert(
          provider: album.provider,
          itemId: album.itemId,
          name: album.name,
          sortName: Value(album.sortName),
          uri: Value(album.uri),
          albumType: Value(album.albumType),
          year: Value(album.year),
          artistsJson: Value(album.artists != null
              ? jsonEncode(album.artists!.map((a) => a.toJson()).toList())
              : null),
          favorite: Value(album.favorite == true),
          inLibrary: Value(album.inLibrary),
          metadataJson: Value(album.metadata != null ? jsonEncode(album.metadata) : null),
          lastSynced: DateTime.now(),
        ));
    await _replaceProviderMappings('album', album.provider, album.itemId, album.providerMappings);
  }

  /// Upserts a track. Pass [albumProvider]/[albumItemId]/[position] when the
  /// track is being synced as part of an album's track listing (this is
  /// what makes [getAlbumTracks] answerable without re-fetching from the API).
  Future<void> upsertTrack(
    Track track, {
    String? albumProvider,
    String? albumItemId,
    int? position,
  }) async {
    await _db.into(_db.tracks).insertOnConflictUpdate(TracksCompanion.insert(
          provider: track.provider,
          itemId: track.itemId,
          name: track.name,
          sortName: Value(track.sortName),
          uri: Value(track.uri),
          durationSeconds: Value(track.duration?.inSeconds),
          artistsJson: Value(track.artists != null
              ? jsonEncode(track.artists!.map((a) => a.toJson()).toList())
              : null),
          albumProvider: Value(albumProvider ?? track.album?.provider),
          albumItemId: Value(albumItemId ?? track.album?.itemId),
          position: Value(position ?? track.position),
          favorite: Value(track.favorite == true),
          inLibrary: Value(track.inLibrary),
          metadataJson: Value(track.metadata != null ? jsonEncode(track.metadata) : null),
          lastSynced: DateTime.now(),
        ));
    await _replaceProviderMappings('track', track.provider, track.itemId, track.providerMappings);
  }

  Future<void> upsertPlaylist(Playlist playlist) async {
    await _db.into(_db.playlists).insertOnConflictUpdate(PlaylistsCompanion.insert(
          provider: playlist.provider,
          itemId: playlist.itemId,
          name: playlist.name,
          sortName: Value(playlist.sortName),
          uri: Value(playlist.uri),
          owner: Value(playlist.owner),
          isEditable: Value(playlist.isEditable),
          trackCount: Value(playlist.trackCount),
          favorite: Value(playlist.favorite == true),
          inLibrary: Value(playlist.inLibrary),
          metadataJson: Value(playlist.metadata != null ? jsonEncode(playlist.metadata) : null),
          lastSynced: DateTime.now(),
        ));
    await _replaceProviderMappings('playlist', playlist.provider, playlist.itemId, playlist.providerMappings);
  }

  /// Upserts an audiobook's top-level fields. Chapters aren't synced yet -
  /// they aren't fetched by the background sync path this feeds today, only
  /// by an on-demand detail fetch that hasn't been migrated to this
  /// repository yet.
  Future<void> upsertAudiobook(Audiobook audiobook) async {
    await _db.into(_db.audiobooks).insertOnConflictUpdate(AudiobooksCompanion.insert(
          provider: audiobook.provider,
          itemId: audiobook.itemId,
          name: audiobook.name,
          sortName: Value(audiobook.sortName),
          uri: Value(audiobook.uri),
          authorsJson: Value(audiobook.authors != null
              ? jsonEncode(audiobook.authors!.map((a) => a.toJson()).toList())
              : null),
          narratorsJson: Value(audiobook.narrators != null
              ? jsonEncode(audiobook.narrators!.map((a) => a.toJson()).toList())
              : null),
          publisher: Value(audiobook.publisher),
          description: Value(audiobook.description),
          year: Value(audiobook.year),
          durationSeconds: Value(audiobook.duration?.inSeconds),
          resumePositionMs: Value(audiobook.resumePositionMs),
          fullyPlayed: Value(audiobook.fullyPlayed),
          browseOrder: Value(audiobook.browseOrder),
          favorite: Value(audiobook.favorite == true),
          inLibrary: Value(audiobook.inLibrary),
          metadataJson: Value(audiobook.metadata != null ? jsonEncode(audiobook.metadata) : null),
          lastSynced: DateTime.now(),
        ));
    await _replaceProviderMappings('audiobook', audiobook.provider, audiobook.itemId, audiobook.providerMappings);
  }

  /// Replaces a playlist's full track listing (order included). Also
  /// upserts each track's own row, since a playlist can reference tracks
  /// this sync hasn't otherwise seen yet.
  Future<void> setPlaylistTracks(String provider, String itemId, List<Track> tracks) async {
    await _db.transaction(() async {
      final deleteQuery = _db.delete(_db.playlistTracks)
        ..where((pt) => pt.playlistProvider.equals(provider))
        ..where((pt) => pt.playlistItemId.equals(itemId));
      await deleteQuery.go();

      for (var i = 0; i < tracks.length; i++) {
        final track = tracks[i];
        await upsertTrack(track);
        await _db.into(_db.playlistTracks).insert(PlaylistTracksCompanion.insert(
              playlistProvider: provider,
              playlistItemId: itemId,
              trackProvider: track.provider,
              trackItemId: track.itemId,
              position: i,
            ));
      }
    });
  }

  Future<void> _replaceProviderMappings(
    String ownerType,
    String ownerProvider,
    String ownerItemId,
    List<ProviderMapping>? mappings,
  ) async {
    final deleteQuery = _db.delete(_db.providerMappings)
      ..where((m) => m.ownerType.equals(ownerType))
      ..where((m) => m.ownerProvider.equals(ownerProvider))
      ..where((m) => m.ownerItemId.equals(ownerItemId));
    await deleteQuery.go();

    if (mappings == null || mappings.isEmpty) return;
    await _db.batch((b) {
      b.insertAll(_db.providerMappings, mappings.map((m) => ProviderMappingsCompanion.insert(
            ownerType: ownerType,
            ownerProvider: ownerProvider,
            ownerItemId: ownerItemId,
            mappingItemId: m.itemId,
            providerDomain: m.providerDomain,
            providerInstance: m.providerInstance,
            available: Value(m.available),
            inLibrary: Value(m.inLibrary),
            audioFormatJson: Value(m.audioFormat != null ? jsonEncode(m.audioFormat) : null),
          )));
    });
  }

  // ============================================================================
  // ENTITY -> DOMAIN OBJECT
  // ============================================================================

  Future<List<ProviderMapping>> _mappingsFor(String ownerType, String ownerProvider, String ownerItemId) async {
    final query = _db.select(_db.providerMappings)
      ..where((m) => m.ownerType.equals(ownerType))
      ..where((m) => m.ownerProvider.equals(ownerProvider))
      ..where((m) => m.ownerItemId.equals(ownerItemId));
    final rows = await query.get();
    return rows
        .map((r) => ProviderMapping(
              itemId: r.mappingItemId,
              providerDomain: r.providerDomain,
              providerInstance: r.providerInstance,
              available: r.available,
              audioFormat: r.audioFormatJson != null
                  ? jsonDecode(r.audioFormatJson!) as Map<String, dynamic>
                  : null,
              inLibrary: r.inLibrary,
            ))
        .toList();
  }

  Future<Artist> _artistFromEntity(ArtistEntity e) async {
    return Artist(
      itemId: e.itemId,
      provider: e.provider,
      name: e.name,
      sortName: e.sortName,
      uri: e.uri,
      favorite: e.favorite,
      providerMappings: await _mappingsFor('artist', e.provider, e.itemId),
      metadata: e.metadataJson != null ? jsonDecode(e.metadataJson!) as Map<String, dynamic> : null,
    );
  }

  Future<Album> _albumFromEntity(AlbumEntity e) async {
    final artistsJson = e.artistsJson;
    return Album(
      itemId: e.itemId,
      provider: e.provider,
      name: e.name,
      sortName: e.sortName,
      uri: e.uri,
      albumType: e.albumType,
      year: e.year,
      artists: artistsJson != null
          ? (jsonDecode(artistsJson) as List).map((j) => Artist.fromJson(j as Map<String, dynamic>)).toList()
          : null,
      favorite: e.favorite,
      providerMappings: await _mappingsFor('album', e.provider, e.itemId),
      metadata: e.metadataJson != null ? jsonDecode(e.metadataJson!) as Map<String, dynamic> : null,
    );
  }

  Future<Track> _trackFromEntity(TrackEntity e) async {
    final artistsJson = e.artistsJson;
    return Track(
      itemId: e.itemId,
      provider: e.provider,
      name: e.name,
      sortName: e.sortName,
      uri: e.uri,
      duration: e.durationSeconds != null ? Duration(seconds: e.durationSeconds!) : null,
      position: e.position,
      artists: artistsJson != null
          ? (jsonDecode(artistsJson) as List).map((j) => Artist.fromJson(j as Map<String, dynamic>)).toList()
          : null,
      favorite: e.favorite,
      providerMappings: await _mappingsFor('track', e.provider, e.itemId),
      metadata: e.metadataJson != null ? jsonDecode(e.metadataJson!) as Map<String, dynamic> : null,
    );
  }

  Future<Playlist> _playlistFromEntity(PlaylistEntity e) async {
    return Playlist(
      itemId: e.itemId,
      provider: e.provider,
      name: e.name,
      sortName: e.sortName,
      uri: e.uri,
      owner: e.owner,
      isEditable: e.isEditable,
      trackCount: e.trackCount,
      favorite: e.favorite,
      providerMappings: await _mappingsFor('playlist', e.provider, e.itemId),
      metadata: e.metadataJson != null ? jsonDecode(e.metadataJson!) as Map<String, dynamic> : null,
    );
  }
}
