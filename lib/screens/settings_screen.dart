import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/recommendation_folder.dart';
import '../providers/locale_provider.dart';
import '../providers/music_assistant_provider.dart';
import '../services/music_assistant_api.dart';
import '../services/settings_service.dart';
import '../services/client_certificate_service.dart';
import '../theme/theme_provider.dart';
import '../theme/app_theme.dart';
import '../utils/page_transitions.dart';
import '../providers/navigation_provider.dart';
import '../widgets/global_player_overlay.dart';
import 'debug_log_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _scrollController = ScrollController();
  final _lastFmApiKeyController = TextEditingController();
  final _audioDbApiKeyController = TextEditingController();
  String _appVersion = '';
  // Main rows (default on)
  bool _showRecentAlbums = true;
  bool _showDiscoverArtists = true;
  bool _showDiscoverAlbums = true;
  // Favorites rows (default off)
  bool _showFavoriteAlbums = false;
  bool _showFavoriteArtists = false;
  bool _showFavoriteTracks = false;
  bool _showFavoritePlaylists = false;
  bool _showFavoriteRadioStations = false;
  bool _showFavoritePodcasts = false;
  // Audiobook home rows (default off)
  bool _showContinueListeningAudiobooks = false;
  bool _showDiscoverAudiobooks = false;
  bool _showDiscoverSeries = false;
  // Home row order
  List<String> _homeRowOrder = List.from(SettingsService.defaultHomeRowOrder);
  // Player settings
  bool _smartSortPlayers = false;
  bool _volumePrecisionMode = true;
  // Hint settings
  bool _showHints = true;
  // Display settings
  bool _showProviderIcons = true;
  // Discovery folders state
  List<RecommendationFolder> _discoveryFolders = [];
  Map<String, bool> _discoveryRowEnabled = {};
  bool _isLoadingDiscoveryFolders = false;
  // Client certificate (mTLS) state
  bool _hasClientCertificate = false;
  DateTime? _clientCertificateImportedAt;
  bool _isImportingCertificate = false;

  /// All available static home screen rows (that can be toggled on/off)
  static const List<String> _allAvailableRows = [
    'recent-albums',
    'discover-artists',
    'discover-albums',
    'discovery-mixes',
    'continue-listening',
    'discover-audiobooks',
    'discover-series',
    'favorite-albums',
    'favorite-artists',
    'favorite-tracks',
    'favorite-playlists',
    'favorite-radio-stations',
    'favorite-podcasts',
  ];

  /// Filtered row order for the draggable list
  /// Shows all available rows (in home order + discovery rows), regardless of enabled state
  List<String> get _filteredRowOrder {
    final rows = <String>[];

    // First, add all static rows in their current home order
    for (final rowId in _homeRowOrder) {
      if (rowId == 'discovery-mixes') continue;
      rows.add(rowId);
    }

    // Then, add any static rows that aren't in home order yet (so users can enable them)
    for (final rowId in _allAvailableRows) {
      if (!_homeRowOrder.contains(rowId) && rowId != 'discovery-mixes') {
        rows.add(rowId);
      }
    }

    // Finally, add any discovery rows from provider that aren't in home order yet
    for (final folder in _discoveryFolders) {
      final discoveryRowId = 'discovery:${folder.itemId}';
      if (!_homeRowOrder.contains(discoveryRowId)) {
        rows.add(discoveryRowId);
      }
    }

    return rows;
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadAppVersion();
    _loadClientCertificateStatus();
  }

  Future<void> _loadClientCertificateStatus() async {
    final hasCert = await ClientCertificateService.instance.hasCertificate();
    final importedAt = await ClientCertificateService.instance.importedAt();
    if (mounted) {
      setState(() {
        _hasClientCertificate = hasCert;
        _clientCertificateImportedAt = importedAt;
      });
    }
  }

  Future<void> _importClientCertificate() async {
    // Deliberately FileType.any rather than FileType.custom with an
    // allowedExtensions filter: cloud-backed DocumentsProviders (e.g.
    // Nextcloud) resolve the MIME type for an unrecognized extension like
    // .p12 inconsistently, which greys the file out as unselectable even
    // though it's right there. The actual PKCS12/password validation below
    // is the real gate, so a pre-filter here only adds a failure mode.
    final result = await FilePicker.pickFiles(withData: true);
    final file = result?.files.singleOrNull;
    if (file?.bytes == null || !mounted) return;

    final password = await _promptForCertificatePassword();
    if (password == null || !mounted) return;

    setState(() => _isImportingCertificate = true);
    try {
      await ClientCertificateService.instance.importP12(file!.bytes!, password);
      // Apply immediately so a reconnect (or app restart) picks it up without
      // needing to fully relaunch the app.
      final securityContext = await ClientCertificateService.instance.buildSecurityContext();
      if (securityContext != null) {
        HttpOverrides.global = ClientCertHttpOverrides(securityContext);
      }
      await _loadClientCertificateStatus();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Client certificate imported.'),
            action: SnackBarAction(label: 'Reconnect', onPressed: _reconnect),
          ),
        );
      }
    } on InvalidClientCertificateException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isImportingCertificate = false);
    }
  }

  bool _isReconnecting = false;

  Future<void> _reconnect() async {
    setState(() => _isReconnecting = true);
    final provider = context.read<MusicAssistantProvider>();
    await provider.checkAndReconnect();
    if (!mounted) return;
    setState(() => _isReconnecting = false);

    final connected = provider.connectionState == MAConnectionState.connected ||
        provider.connectionState == MAConnectionState.authenticated;
    final failureReason = provider.error ?? _getStatusText(provider.connectionState).toLowerCase();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(connected ? 'Reconnected.' : 'Reconnect failed — $failureReason'),
      ),
    );
  }

  Future<String?> _promptForCertificatePassword() {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Certificate Password'),
          content: TextField(
            controller: controller,
            obscureText: true,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'PKCS12 password'),
            onSubmitted: (value) => Navigator.pop(dialogContext, value),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, controller.text),
              child: const Text('Import'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeClientCertificate() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove Client Certificate?'),
          content: const Text(
            'If your server requires this certificate to connect at all, '
            'you will not be able to reconnect until a certificate is '
            'imported again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    await ClientCertificateService.instance.clearCertificate();
    HttpOverrides.global = null;
    await _loadClientCertificateStatus();
  }

  Future<void> _loadAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = info.version;
      });
    }
  }

  Future<void> _loadSettings() async {
    final lastFmKey = await SettingsService.getLastFmApiKey();
    if (lastFmKey != null) {
      _lastFmApiKeyController.text = lastFmKey;
    }

    final audioDbKey = await SettingsService.getTheAudioDbApiKey();
    if (audioDbKey != null) {
      _audioDbApiKeyController.text = audioDbKey;
    }

    // Load home screen settings
    final showRecent = await SettingsService.getShowRecentAlbums();
    final showDiscArtists = await SettingsService.getShowDiscoverArtists();
    final showDiscAlbums = await SettingsService.getShowDiscoverAlbums();
    final showFavAlbums = await SettingsService.getShowFavoriteAlbums();
    final showFavArtists = await SettingsService.getShowFavoriteArtists();
    final showFavTracks = await SettingsService.getShowFavoriteTracks();
    final showFavPlaylists = await SettingsService.getShowFavoritePlaylists();
    final showFavRadio = await SettingsService.getShowFavoriteRadioStations();
    final showFavPodcasts = await SettingsService.getShowFavoritePodcasts();

    // Load audiobook home row settings
    final showContinueAudiobooks = await SettingsService.getShowContinueListeningAudiobooks();
    final showDiscAudiobooks = await SettingsService.getShowDiscoverAudiobooks();
    final showDiscSeries = await SettingsService.getShowDiscoverSeries();

    // Load home row order
    final rowOrder = await SettingsService.getHomeRowOrder();

    // Load player settings
    final smartSort = await SettingsService.getSmartSortPlayers();
    final volumePrecision = await SettingsService.getVolumePrecisionMode();

    // Load hint settings
    final showHints = await SettingsService.getShowHints();

    // Load display settings
    final showProviderIcons = await SettingsService.getShowProviderIcons();

    // Load discovery row preferences
    final discoveryRowPrefs = await SettingsService.getDiscoveryRowPreferences();

    if (mounted) {
      setState(() {
        _showRecentAlbums = showRecent;
        _showDiscoverArtists = showDiscArtists;
        _showDiscoverAlbums = showDiscAlbums;
        _showFavoriteAlbums = showFavAlbums;
        _showFavoriteArtists = showFavArtists;
        _showFavoriteTracks = showFavTracks;
        _showFavoritePlaylists = showFavPlaylists;
        _showFavoriteRadioStations = showFavRadio;
        _showFavoritePodcasts = showFavPodcasts;
        _showContinueListeningAudiobooks = showContinueAudiobooks;
        _showDiscoverAudiobooks = showDiscAudiobooks;
        _showDiscoverSeries = showDiscSeries;
        _homeRowOrder = rowOrder;
        _smartSortPlayers = smartSort;
        _volumePrecisionMode = volumePrecision;
        _showHints = showHints;
        _showProviderIcons = showProviderIcons;
        _discoveryRowEnabled = discoveryRowPrefs;
      });
    }

    // Load discovery folders after initial state is set
    _loadDiscoveryFolders();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _lastFmApiKeyController.dispose();
    _audioDbApiKeyController.dispose();
    super.dispose();
  }

  /// Load discovery folders from Music Assistant
  Future<void> _loadDiscoveryFolders() async {
    if (_discoveryFolders.isEmpty && mounted) {
      setState(() {
        _isLoadingDiscoveryFolders = true;
      });
    }

    final provider = context.read<MusicAssistantProvider>();
    try {
      final folders = await provider.getDiscoveryFoldersWithCache();
      // Also reload discovery row preferences to ensure they're up to date
      final discoveryRowPrefs = await SettingsService.getDiscoveryRowPreferences();
      if (mounted) {
        setState(() {
          _discoveryFolders = folders;
          _discoveryRowEnabled = discoveryRowPrefs;
          _isLoadingDiscoveryFolders = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingDiscoveryFolders = false;
        });
      }
    }
  }

  /// Refresh discovery folders from Music Assistant
  Future<void> _refreshDiscoveryFolders() async {
    final provider = context.read<MusicAssistantProvider>();
    try {
      setState(() {
        _isLoadingDiscoveryFolders = true;
      });
      await provider.refreshDiscoveryFolders();
      final folders = provider.getCachedDiscoveryFolders() ?? [];
      if (mounted) {
        setState(() {
          _discoveryFolders = folders;
          _isLoadingDiscoveryFolders = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingDiscoveryFolders = false;
        });
      }
    }
  }

  /// Toggle a specific discovery row on/off
  Future<void> _toggleDiscoveryRow(String itemId, bool enabled) async {
    setState(() {
      _discoveryRowEnabled[itemId] = enabled;
    });
    await SettingsService.setDiscoveryRowPreference(itemId, enabled);
  }

  // Helper to get row display info
  Map<String, String> _getRowInfo(String rowId) {
    final s = S.of(context)!;
    // Handle dynamic discovery folders
    if (rowId.startsWith('discovery:')) {
      final itemId = rowId.substring('discovery:'.length);
      final folder = _discoveryFolders.firstWhere(
        (f) => f.itemId == itemId,
        orElse: () => RecommendationFolder(
          itemId: itemId,
          provider: 'unknown',
          name: itemId
              .replaceAll('_', ' ')
              .split(' ')
              .where((w) => w.isNotEmpty)
              .map((w) => w[0].toUpperCase() + w.substring(1))
              .join(' '),
          items: [],
        ),
      );
      return {'title': folder.name, 'subtitle': 'Discovery row from Music Assistant'};
    }
    switch (rowId) {
      case 'recent-albums':
        return {'title': s.recentlyPlayed, 'subtitle': s.showRecentlyPlayedAlbums};
      case 'discover-artists':
        return {'title': s.discoverArtists, 'subtitle': s.showRandomArtists};
      case 'discover-albums':
        return {'title': s.discoverAlbums, 'subtitle': s.showRandomAlbums};
      case 'discovery-mixes':
        return {'title': s.discoveryMixes, 'subtitle': s.discoveryMixesDescription};
      case 'continue-listening':
        return {'title': s.continueListening, 'subtitle': s.showAudiobooksInProgress};
      case 'discover-audiobooks':
        return {'title': s.discoverAudiobooks, 'subtitle': s.showRandomAudiobooks};
      case 'discover-series':
        return {'title': s.discoverSeries, 'subtitle': s.showRandomSeries};
      case 'favorite-albums':
        return {'title': s.favoriteAlbums, 'subtitle': s.showFavoriteAlbums};
      case 'favorite-artists':
        return {'title': s.favoriteArtists, 'subtitle': s.showFavoriteArtists};
      case 'favorite-tracks':
        return {'title': s.favoriteTracks, 'subtitle': s.showFavoriteTracks};
      case 'favorite-playlists':
        return {'title': s.favoritePlaylists, 'subtitle': s.showFavoritePlaylists};
      case 'favorite-radio-stations':
        return {'title': s.favoriteRadioStations, 'subtitle': s.showFavoriteRadioStations};
      case 'favorite-podcasts':
        return {'title': s.favoritePodcasts, 'subtitle': s.showFavoritePodcasts};
      default:
        return {'title': rowId, 'subtitle': ''};
    }
  }

  // Helper to get row enabled state
  bool _getRowEnabled(String rowId) {
    // Handle dynamic discovery folders
    if (rowId.startsWith('discovery:')) {
      final itemId = rowId.substring('discovery:'.length);
      return _discoveryRowEnabled[itemId] ?? false;
    }
    switch (rowId) {
      case 'recent-albums':
        return _showRecentAlbums;
      case 'discover-artists':
        return _showDiscoverArtists;
      case 'discover-albums':
        return _showDiscoverAlbums;
      case 'continue-listening':
        return _showContinueListeningAudiobooks;
      case 'discover-audiobooks':
        return _showDiscoverAudiobooks;
      case 'discover-series':
        return _showDiscoverSeries;
      case 'favorite-albums':
        return _showFavoriteAlbums;
      case 'favorite-artists':
        return _showFavoriteArtists;
      case 'favorite-tracks':
        return _showFavoriteTracks;
      case 'favorite-playlists':
        return _showFavoritePlaylists;
      case 'favorite-radio-stations':
        return _showFavoriteRadioStations;
      case 'favorite-podcasts':
        return _showFavoritePodcasts;
      default:
        return false;
    }
  }

  // Helper to set row enabled state
  void _setRowEnabled(String rowId, bool value) {
    setState(() {
      // Handle dynamic discovery folders
      if (rowId.startsWith('discovery:')) {
        final itemId = rowId.substring('discovery:'.length);
        _discoveryRowEnabled[itemId] = value;
        SettingsService.setDiscoveryRowPreference(itemId, value);
        // Always add to home row order for position tracking
        if (!_homeRowOrder.contains(rowId)) {
          _homeRowOrder.add(rowId);
          SettingsService.setHomeRowOrder(_homeRowOrder);
        }
        return;
      }

      // Save the setting
      switch (rowId) {
        case 'recent-albums':
          _showRecentAlbums = value;
          SettingsService.setShowRecentAlbums(value);
          break;
        case 'discover-artists':
          _showDiscoverArtists = value;
          SettingsService.setShowDiscoverArtists(value);
          break;
        case 'discover-albums':
          _showDiscoverAlbums = value;
          SettingsService.setShowDiscoverAlbums(value);
          break;
        case 'continue-listening':
          _showContinueListeningAudiobooks = value;
          SettingsService.setShowContinueListeningAudiobooks(value);
          break;
        case 'discover-audiobooks':
          _showDiscoverAudiobooks = value;
          SettingsService.setShowDiscoverAudiobooks(value);
          break;
        case 'discover-series':
          _showDiscoverSeries = value;
          SettingsService.setShowDiscoverSeries(value);
          break;
        case 'favorite-albums':
          _showFavoriteAlbums = value;
          SettingsService.setShowFavoriteAlbums(value);
          break;
        case 'favorite-artists':
          _showFavoriteArtists = value;
          SettingsService.setShowFavoriteArtists(value);
          break;
        case 'favorite-tracks':
          _showFavoriteTracks = value;
          SettingsService.setShowFavoriteTracks(value);
          break;
        case 'favorite-playlists':
          _showFavoritePlaylists = value;
          SettingsService.setShowFavoritePlaylists(value);
          break;
        case 'favorite-radio-stations':
          _showFavoriteRadioStations = value;
          SettingsService.setShowFavoriteRadioStations(value);
          break;
        case 'favorite-podcasts':
          _showFavoritePodcasts = value;
          SettingsService.setShowFavoritePodcasts(value);
          break;
        default:
          break;
      }

      // When enabling a row, add it to home row order if not already present
      if (value && !_homeRowOrder.contains(rowId)) {
        _homeRowOrder.add(rowId);
        SettingsService.setHomeRowOrder(_homeRowOrder);
      }
    });
  }

  Future<void> _disconnect() async {
    final provider = context.read<MusicAssistantProvider>();
    await provider.disconnect();

    // Clear saved server URL so login screen shows
    await SettingsService.clearServerUrl();

    if (mounted) {
      // Navigate to login screen and clear the navigation stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use select to only rebuild when connectionState changes
    final connectionState = context.select<MusicAssistantProvider, MAConnectionState>((p) => p.connectionState);
    final connectionError = context.select<MusicAssistantProvider, String?>((p) => p.error);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            // Settings is rendered conditionally in HomeScreen (not pushed as a route),
            // so Navigator.pop would pop the entire HomeScreen causing a black screen.
            // Instead, switch tab back to Home and restore the mini player.
            GlobalPlayerOverlay.showPlayer();
            navigationProvider.setSelectedIndex(0);
          },
          color: colorScheme.onBackground,
        ),
        title: Text(
          S.of(context)!.settings,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.w300,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report_rounded),
            onPressed: () {
              Navigator.push(
                context,
                FadeSlidePageRoute(child: const DebugLogScreen()),
              );
            },
            color: colorScheme.onBackground,
            tooltip: S.of(context)!.debugLogs,
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo - same size as login screen (50% of screen width)
            // Use color filter to make logo dark in light theme
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 48.0),
              child: Image.asset(
                'assets/images/klangor_icon_transparent.png',
                width: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),
            ),

            // Connection status box - centered with border radius like theme boxes
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getStatusIcon(connectionState),
                        color: _getStatusColor(connectionState, colorScheme),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getStatusText(connectionState),
                        style: textTheme.titleMedium?.copyWith(
                          color: _getStatusColor(connectionState, colorScheme),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Show the specific reason (e.g. TLS/certificate failure,
                  // DNS lookup failure, timeout) instead of just the generic
                  // "Connection Error" label - avoids needing to dig into the
                  // debug log for common, recognizable failure causes.
                  if (connectionState == MAConnectionState.error && connectionError != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      connectionError,
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Client certificate (mTLS) section — only relevant for servers
            // behind a reverse proxy that requires a client cert at the TLS
            // handshake itself. Most users will never touch this.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _hasClientCertificate ? Icons.verified_user_rounded : Icons.gpp_maybe_outlined,
                        color: _hasClientCertificate ? colorScheme.primary : colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Client Certificate (mTLS)',
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _hasClientCertificate
                        ? 'Configured${_clientCertificateImportedAt != null ? ' — imported ${DateFormat.yMMMd().format(_clientCertificateImportedAt!)}' : ''}. Used automatically only if the server asks for it, so servers that don\'t require it still connect fine.'
                        : 'Not configured. Only needed if your server requires a client certificate to connect at all.',
                    style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isImportingCertificate ? null : _importClientCertificate,
                          child: _isImportingCertificate
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(_hasClientCertificate ? 'Replace' : 'Import'),
                        ),
                      ),
                      if (_hasClientCertificate) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _removeClientCertificate,
                            style: OutlinedButton.styleFrom(foregroundColor: colorScheme.error),
                            child: const Text('Remove'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Reconnect button — a lightweight retry that doesn't clear the
            // saved server URL or drop back to the login screen, unlike
            // Disconnect below. Useful after importing a client certificate,
            // or any time the connection is stuck in an error state.
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.tonalIcon(
                onPressed: _isReconnecting ? null : _reconnect,
                icon: _isReconnecting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh_rounded),
                label: Text(
                  'Reconnect',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Disconnect button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.tonalIcon(
                onPressed: _disconnect,
                icon: const Icon(Icons.logout_rounded),
                label: Text(
                  S.of(context)!.disconnect,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.errorContainer.withOpacity(0.4),
                  foregroundColor: colorScheme.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Theme section
            Text(
              S.of(context)!.theme,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context)!.themeMode,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<ThemeMode>(
                          segments: [
                            ButtonSegment<ThemeMode>(
                              value: ThemeMode.light,
                              label: Text(S.of(context)!.light),
                              icon: const Icon(Icons.light_mode_rounded),
                            ),
                            ButtonSegment<ThemeMode>(
                              value: ThemeMode.dark,
                              label: Text(S.of(context)!.dark),
                              icon: const Icon(Icons.dark_mode_rounded),
                            ),
                            ButtonSegment<ThemeMode>(
                              value: ThemeMode.system,
                              label: Text(S.of(context)!.system),
                              icon: const Icon(Icons.auto_mode_rounded),
                            ),
                          ],
                          selected: {themeProvider.themeMode},
                          onSelectionChanged: (Set<ThemeMode> newSelection) {
                            themeProvider.setThemeMode(newSelection.first);
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return colorScheme.primaryContainer;
                              }
                              return colorScheme.surfaceVariant.withOpacity(0.5);
                            }),
                            foregroundColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return colorScheme.onPrimaryContainer;
                              }
                              return colorScheme.onSurfaceVariant;
                            }),
                            side: WidgetStateProperty.all(BorderSide.none),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Accent color picker
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                final isDisabled = themeProvider.useMaterialTheme;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context)!.accentColor,
                        style: TextStyle(
                          color: isDisabled
                              ? colorScheme.onSurface.withOpacity(0.4)
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: accentColorOptions.map((color) {
                          final isSelected = themeProvider.customColor.value == color.value;
                          return GestureDetector(
                            onTap: isDisabled ? null : () {
                              themeProvider.setCustomColor(color);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isDisabled ? color.withOpacity(0.3) : color,
                                shape: BoxShape.circle,
                                border: isSelected && !isDisabled
                                    ? Border.all(color: colorScheme.onSurface, width: 3)
                                    : null,
                                boxShadow: isSelected && !isDisabled
                                    ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8, spreadRadius: 2)]
                                    : null,
                              ),
                              child: isSelected && !isDisabled
                                  ? Icon(Icons.check, color: Colors.white, size: 20)
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
                    title: Text(
                      S.of(context)!.materialYou,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    subtitle: Text(
                      S.of(context)!.materialYouDescription,
                      style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12),
                    ),
                    value: themeProvider.useMaterialTheme,
                    onChanged: (value) {
                      themeProvider.setUseMaterialTheme(value);
                    },
                    activeColor: colorScheme.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
                    title: Text(
                      S.of(context)!.adaptiveTheme,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    subtitle: Text(
                      S.of(context)!.extractColorsFromArtwork,
                      style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12),
                    ),
                    value: themeProvider.adaptiveTheme,
                    onChanged: (value) {
                      themeProvider.setAdaptiveTheme(value);
                    },
                    activeColor: colorScheme.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // Language section
            Text(
              S.of(context)!.language,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Consumer<LocaleProvider>(
              builder: (context, localeProvider, _) {
                String getLanguageName(String? code) {
                  switch (code) {
                    case 'en':
                      return 'English';
                    case 'de':
                      return 'Deutsch';
                    case 'es':
                      return 'Español';
                    default:
                      return S.of(context)!.system;
                  }
                }

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  tileColor: colorScheme.surfaceVariant.withOpacity(0.5),
                  leading: Icon(Icons.language_rounded, color: colorScheme.onSurfaceVariant),
                  title: Text(S.of(context)!.language),
                  subtitle: Text(
                    getLanguageName(localeProvider.locale?.languageCode),
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: Text(S.of(context)!.language),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile<String?>(
                                title: Text(S.of(context)!.system),
                                subtitle: Text(S.of(context)!.auto),
                                value: null,
                                groupValue: localeProvider.locale?.languageCode,
                                onChanged: (value) {
                                  localeProvider.setLocale(null);
                                  Navigator.pop(dialogContext);
                                },
                              ),
                              RadioListTile<String?>(
                                title: Text(S.of(context)!.english),
                                value: 'en',
                                groupValue: localeProvider.locale?.languageCode,
                                onChanged: (value) {
                                  localeProvider.setLocale(const Locale('en'));
                                  Navigator.pop(dialogContext);
                                },
                              ),
                              RadioListTile<String?>(
                                title: Text(S.of(context)!.german),
                                value: 'de',
                                groupValue: localeProvider.locale?.languageCode,
                                onChanged: (value) {
                                  localeProvider.setLocale(const Locale('de'));
                                  Navigator.pop(dialogContext);
                                },
                              ),
                              RadioListTile<String?>(
                                title: Text(S.of(context)!.spanish),
                                value: 'es',
                                groupValue: localeProvider.locale?.languageCode,
                                onChanged: (value) {
                                  localeProvider.setLocale(const Locale('es'));
                                  Navigator.pop(dialogContext);
                                },
                              ),
                              RadioListTile<String?>(
                                title: Text(S.of(context)!.french),
                                value: 'fr',
                                groupValue: localeProvider.locale?.languageCode,
                                onChanged: (value) {
                                  localeProvider.setLocale(const Locale('fr'));
                                  Navigator.pop(dialogContext);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 32),

            // Player section
            Text(
              S.of(context)!.players,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: Text(
                  S.of(context)!.smartSortPlayers,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                subtitle: Text(
                  S.of(context)!.smartSortPlayersDescription,
                  style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12),
                ),
                value: _smartSortPlayers,
                onChanged: (value) {
                  setState(() => _smartSortPlayers = value);
                  SettingsService.setSmartSortPlayers(value);
                },
                activeColor: colorScheme.primary,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: Text(
                  S.of(context)!.volumePrecisionMode,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                subtitle: Text(
                  S.of(context)!.volumePrecisionModeDescription,
                  style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12),
                ),
                value: _volumePrecisionMode,
                onChanged: (value) {
                  setState(() => _volumePrecisionMode = value);
                  SettingsService.setVolumePrecisionMode(value);
                },
                activeColor: colorScheme.primary,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: 32),

            // Hints & Tips section
            Text(
              S.of(context)!.hintsAndTips,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context)!.showHintsDescription,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: Text(
                  S.of(context)!.showHints,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                value: _showHints,
                onChanged: (value) {
                  setState(() => _showHints = value);
                  SettingsService.setShowHints(value);
                },
                activeColor: colorScheme.primary,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: 24),

            // Display section
            Text(
              S.of(context)!.display,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                title: Text(
                  S.of(context)!.showProviderIcons,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                subtitle: Text(
                  S.of(context)!.showProviderIconsDescription,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                value: _showProviderIcons,
                onChanged: (value) {
                  setState(() => _showProviderIcons = value);
                  SettingsService.setShowProviderIcons(value);
                },
                activeColor: colorScheme.primary,
                contentPadding: EdgeInsets.zero,
              ),
            ),

            const SizedBox(height: 32),

            // Home Screen section
            Text(
              S.of(context)!.homeScreen,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context)!.chooseHomeScreenRows,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),

            // Reorderable home rows list (exclude discovery-mixes from list)
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                buildDefaultDragHandles: false,
                itemCount: _filteredRowOrder.length,
                onReorder: (oldIndex, newIndex) {
                  // Create a mutable copy of the filtered list for reordering
                  final displayRows = List<String>.from(_filteredRowOrder);
                  if (newIndex > oldIndex) newIndex--;
                  final item = displayRows.removeAt(oldIndex);
                  displayRows.insert(newIndex, item);

                  setState(() {
                    // Update _homeRowOrder with the new order (all rows, including discovery)
                    _homeRowOrder = displayRows;
                  });
                  SettingsService.setHomeRowOrder(_homeRowOrder);
                },
                itemBuilder: (context, index) {
                  final rowId = _filteredRowOrder[index];
                  final rowInfo = _getRowInfo(rowId);
                  final isEnabled = _getRowEnabled(rowId);

                  return Container(
                    key: ValueKey(rowId),
                    decoration: BoxDecoration(
                      border: index < _filteredRowOrder.length - 1
                          ? Border(bottom: BorderSide(color: colorScheme.outline.withOpacity(0.2)))
                          : null,
                    ),
                    child: Row(
                      children: [
                        ReorderableDragStartListener(
                          index: index,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            child: Icon(
                              Icons.drag_handle,
                              color: colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                        Expanded(
                          child: SwitchListTile(
                            title: Text(
                              rowInfo['title']!,
                              style: TextStyle(color: colorScheme.onSurface),
                            ),
                            subtitle: Text(
                              rowInfo['subtitle']!,
                              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 12),
                            ),
                            value: isEnabled,
                            onChanged: (value) => _setRowEnabled(rowId, value),
                            activeColor: colorScheme.primary,
                            contentPadding: const EdgeInsets.only(right: 8),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            Text(
              S.of(context)!.metadataApis,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context)!.metadataApisDescription,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _lastFmApiKeyController,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: S.of(context)!.lastFmApiKey,
                hintText: S.of(context)!.lastFmApiKeyHint,
                hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.38)),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(
                  Icons.music_note_rounded,
                  color: colorScheme.onSurface.withOpacity(0.54),
                ),
                suffixIcon: _lastFmApiKeyController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _lastFmApiKeyController.clear();
                          });
                          SettingsService.setLastFmApiKey(null);
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                SettingsService.setLastFmApiKey(value.trim().isEmpty ? null : value.trim());
                setState(() {}); // Update UI to show/hide clear button
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _audioDbApiKeyController,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: S.of(context)!.theAudioDbApiKey,
                hintText: S.of(context)!.theAudioDbApiKeyHint,
                hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.38)),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(
                  Icons.audiotrack_rounded,
                  color: colorScheme.onSurface.withOpacity(0.54),
                ),
                suffixIcon: _audioDbApiKeyController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _audioDbApiKeyController.clear();
                          });
                          SettingsService.setTheAudioDbApiKey(null);
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                SettingsService.setTheAudioDbApiKey(value.trim().isEmpty ? null : value.trim());
                setState(() {}); // Update UI to show/hide clear button
              },
            ),

            const SizedBox(height: 32),

            // About & Support section
            Text(
              S.of(context)!.aboutAndSupport,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // About Klangor card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context)!.aboutApp,
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        S.of(context)!.version,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _appVersion,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _LinkButton(
                    icon: Icons.code_rounded,
                    label: S.of(context)!.visitGitHubRepo,
                    onTap: () => _launchUrl('https://github.com/caique2C/klangor'),
                  ),
                  const SizedBox(height: 8),
                  _LinkButton(
                    icon: Icons.bug_report_outlined,
                    label: S.of(context)!.reportABug,
                    onTap: () => _launchUrl('https://github.com/caique2C/klangor/issues'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DebugLogScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.bug_report_rounded),
                label: Text(S.of(context)!.viewDebugLogs),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.surfaceVariant.withOpacity(0.5),
                  foregroundColor: colorScheme.onSurfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(height: BottomSpacing.navBarOnly), // Space for bottom nav bar
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(MAConnectionState state) {
    switch (state) {
      case MAConnectionState.connected:
      case MAConnectionState.authenticated:
        return Icons.check_circle_rounded;
      case MAConnectionState.connecting:
      case MAConnectionState.authenticating:
        return Icons.sync_rounded;
      case MAConnectionState.error:
        return Icons.error_rounded;
      case MAConnectionState.disconnected:
        return Icons.cloud_off_rounded;
    }
  }

  Color _getStatusColor(MAConnectionState state, ColorScheme colorScheme) {
    switch (state) {
      case MAConnectionState.connected:
      case MAConnectionState.authenticated:
        return Colors.green;
      case MAConnectionState.connecting:
      case MAConnectionState.authenticating:
        return Colors.orange;
      case MAConnectionState.error:
        return colorScheme.error;
      case MAConnectionState.disconnected:
        return colorScheme.onSurface.withOpacity(0.5);
    }
  }

  String _getStatusText(MAConnectionState state) {
    final s = S.of(context)!;
    switch (state) {
      case MAConnectionState.connected:
      case MAConnectionState.authenticated:
        return s.connected;
      case MAConnectionState.connecting:
      case MAConnectionState.authenticating:
        return s.connecting;
      case MAConnectionState.error:
        return s.connectionError;
      case MAConnectionState.disconnected:
        return s.disconnected;
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// Build the discovery section with individual row toggles
  Widget _buildDiscoverySection(ColorScheme colorScheme, TextTheme textTheme) {
    final s = S.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and refresh button
          Row(
            children: [
              Icon(
                Icons.explore_outlined,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  s.discoveryRows,
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_isLoadingDiscoveryFolders)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.primary.withOpacity(0.7),
                    ),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: _refreshDiscoveryFolders,
                  tooltip: s.refreshDiscoveryRows,
                  color: colorScheme.onSurfaceVariant,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Discovery rows list
          if (_discoveryFolders.isEmpty && !_isLoadingDiscoveryFolders)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                s.noDiscoveryRows,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            )
          else
            ..._discoveryFolders.map((folder) {
              final itemId = folder.itemId;
              final isEnabled = _discoveryRowEnabled[itemId] ?? false;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: SwitchListTile(
                  title: Text(
                    folder.name,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: folder.provider.isNotEmpty
                      ? Text(
                          folder.provider,
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        )
                      : null,
                  value: isEnabled,
                  onChanged: (value) => _toggleDiscoveryRow(itemId, value),
                  activeColor: colorScheme.primary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  dense: true,
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}

// Custom link button widget
class _LinkButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _LinkButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.open_in_new,
                size: 14,
                color: colorScheme.primary.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
