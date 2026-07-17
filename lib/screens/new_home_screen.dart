import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/recommendation_folder.dart';
import '../providers/music_assistant_provider.dart';
import '../providers/navigation_provider.dart';
import '../services/music_assistant_api.dart' show MAConnectionState;
import '../services/settings_service.dart';
import '../services/debug_logger.dart';
import '../services/sync_service.dart';
import '../widgets/global_player_overlay.dart';
import '../widgets/player_selector.dart';
import '../widgets/album_row.dart';
import '../widgets/artist_row.dart';
import '../widgets/track_row.dart';
import '../widgets/audiobook_row.dart';
import '../widgets/series_row.dart';
import '../widgets/playlist_row.dart';
import '../widgets/radio_station_row.dart';
import '../widgets/podcast_row.dart';
import '../widgets/discovery_row.dart';
import '../widgets/common/disconnected_state.dart';
import 'settings_screen.dart';
import 'search_screen.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({super.key});

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen>
    with AutomaticKeepAliveClientMixin {
  static final _logger = DebugLogger();
  final ValueNotifier<int> _refreshSignal = ValueNotifier<int>(0);
  // Suppresses the AppBar sync spinner while the pull-to-refresh gesture's
  // own Material RefreshIndicator is already showing its own spinner for
  // the same sync - otherwise both appear stacked on top of each other.
  final ValueNotifier<bool> _isPullRefreshing = ValueNotifier<bool>(false);
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
  // Audiobook rows (default off)
  bool _showContinueListeningAudiobooks = false;
  bool _showDiscoverAudiobooks = false;
  bool _showDiscoverSeries = false;
  // Row order (loaded from settings)
  List<String> _homeRowOrder = List.from(SettingsService.defaultHomeRowOrder);
  // Discovery folders (dynamic rows from provider recommendations)
  List<RecommendationFolder> _discoveryFolders = [];
  // Discovery row preferences (itemId -> enabled)
  Map<String, bool> _discoveryRowEnabled = {};

  @override
  bool get wantKeepAlive => true;

  // Track if we had empty favorites on first load (to know when to refresh)
  bool _hadEmptyFavoritesOnLoad = false;
  SyncStatus? _lastSyncStatus;
  int _lastArtistCount = 0;
  MusicAssistantProvider? _providerListeningTo;
  int _lastHomeRefreshCounter =
      0; // Track home refresh counter to force row refreshes

  @override
  void initState() {
    super.initState();
    _loadSettings();
    // Listen to sync completion to refresh favorite rows when data becomes available
    SyncService.instance.addListener(_onSyncChanged);
    _lastSyncStatus = SyncService.instance.status;
    _checkInitialFavoriteState();

    // Always listen to provider for home refresh counter changes
    final provider = context.read<MusicAssistantProvider>();
    _lastHomeRefreshCounter = provider.homeRefreshCounter;
    _providerListeningTo = provider;
    provider.addListener(_onProviderChanged);

    // Reload settings only when switching back to home from settings tab
    navigationProvider.addListener(_onNavigationChanged);
  }

  int _lastNavIndex = 0;

  void _onNavigationChanged() {
    final newIndex = navigationProvider.selectedIndex;
    // Reload preferences when leaving settings tab (3) for home tab (0)
    if (_lastNavIndex == 3 && newIndex == 0) {
      _reloadPreferencesOnly();
    }
    _lastNavIndex = newIndex;
  }

  /// Reload only local preferences (no API calls). Used when switching back from settings.
  Future<void> _reloadPreferencesOnly() async {
    final showRecent = await SettingsService.getShowRecentAlbums();
    final showDiscArtists = await SettingsService.getShowDiscoverArtists();
    final showDiscAlbums = await SettingsService.getShowDiscoverAlbums();
    final showFavAlbums = await SettingsService.getShowFavoriteAlbums();
    final showFavArtists = await SettingsService.getShowFavoriteArtists();
    final showFavTracks = await SettingsService.getShowFavoriteTracks();
    final showFavPlaylists = await SettingsService.getShowFavoritePlaylists();
    final showFavRadio = await SettingsService.getShowFavoriteRadioStations();
    final showFavPodcasts = await SettingsService.getShowFavoritePodcasts();
    final showContAudiobooks =
        await SettingsService.getShowContinueListeningAudiobooks();
    final showDiscAudiobooks =
        await SettingsService.getShowDiscoverAudiobooks();
    final showDiscSeries = await SettingsService.getShowDiscoverSeries();
    final rowOrder = await SettingsService.getHomeRowOrder();
    final discoveryRowPrefs =
        await SettingsService.getDiscoveryRowPreferences();
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
        _showContinueListeningAudiobooks = showContAudiobooks;
        _showDiscoverAudiobooks = showDiscAudiobooks;
        _showDiscoverSeries = showDiscSeries;
        _homeRowOrder = rowOrder;
        _discoveryRowEnabled = discoveryRowPrefs;
      });
    }
  }

  @override
  void dispose() {
    navigationProvider.removeListener(_onNavigationChanged);
    SyncService.instance.removeListener(_onSyncChanged);
    // Clean up provider listener
    _providerListeningTo?.removeListener(_onProviderChanged);
    _providerListeningTo = null;
    _refreshSignal.dispose();
    _isPullRefreshing.dispose();
    super.dispose();
  }

  /// Check if favorites are empty on initial load (so we know to refresh after sync)
  void _checkInitialFavoriteState() {
    // Schedule after first frame to ensure provider is accessible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<MusicAssistantProvider>();
      _lastArtistCount = provider.artists.length;
      // Check if artists list is empty - favorites will also be empty
      if (_lastArtistCount == 0) {
        _hadEmptyFavoritesOnLoad = true;
        _logger
            .log('📋 Home: favorites empty on load, will refresh after sync');
        // Also listen to provider for when cache loads (before sync completes)
        _providerListeningTo = provider;
        provider.addListener(_onProviderChanged);
      }
    });
  }

  /// Called when MusicAssistantProvider changes (for cache load detection and home refresh)
  void _onProviderChanged() {
    if (!mounted || _providerListeningTo == null) return;

    final provider = _providerListeningTo!;
    final currentRefreshCounter = provider.homeRefreshCounter;

    // Check if home refresh counter changed (indicates authentication completed and cache was invalidated)
    if (currentRefreshCounter != _lastHomeRefreshCounter) {
      _logger.log(
          '🔄 Home: refresh counter changed ($_lastHomeRefreshCounter -> $currentRefreshCounter), refreshing all rows');
      _lastHomeRefreshCounter = currentRefreshCounter;
      _refreshSignal.value++;
      return; // Don't process other refresh conditions in this cycle
    }

    // Check for artists cache load (when favorites were empty on load)
    if (_hadEmptyFavoritesOnLoad) {
      final currentCount = provider.artists.length;
      if (_lastArtistCount == 0 && currentCount > 0) {
        _logger.log(
            '🔄 Home: artists loaded from cache ($currentCount), refreshing rows');
        _hadEmptyFavoritesOnLoad = false;
        _refreshSignal.value++;
      }
      _lastArtistCount = currentCount;
    }
  }

  /// Called when SyncService status changes
  void _onSyncChanged() {
    final newStatus = SyncService.instance.status;
    // When sync completes and we had empty favorites, refresh to show new data
    if (_lastSyncStatus == SyncStatus.syncing &&
        newStatus == SyncStatus.completed &&
        _hadEmptyFavoritesOnLoad) {
      _logger.log('🔄 Home: sync completed, refreshing favorite rows');
      _hadEmptyFavoritesOnLoad = false;
      // Clean up provider listener if still attached
      _providerListeningTo?.removeListener(_onProviderChanged);
      _providerListeningTo = null;
      if (mounted) {
        _refreshSignal.value++;
      }
    }
    _lastSyncStatus = newStatus;
  }

  Future<void> _loadSettings() async {
    final showRecent = await SettingsService.getShowRecentAlbums();
    final showDiscArtists = await SettingsService.getShowDiscoverArtists();
    final showDiscAlbums = await SettingsService.getShowDiscoverAlbums();
    final showFavAlbums = await SettingsService.getShowFavoriteAlbums();
    final showFavArtists = await SettingsService.getShowFavoriteArtists();
    final showFavTracks = await SettingsService.getShowFavoriteTracks();
    final showFavPlaylists = await SettingsService.getShowFavoritePlaylists();
    final showFavRadio = await SettingsService.getShowFavoriteRadioStations();
    final showFavPodcasts = await SettingsService.getShowFavoritePodcasts();
    final showContAudiobooks =
        await SettingsService.getShowContinueListeningAudiobooks();
    final showDiscAudiobooks =
        await SettingsService.getShowDiscoverAudiobooks();
    final showDiscSeries = await SettingsService.getShowDiscoverSeries();
    final rowOrder = await SettingsService.getHomeRowOrder();
    final discoveryRowPrefs =
        await SettingsService.getDiscoveryRowPreferences();
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
        _showContinueListeningAudiobooks = showContAudiobooks;
        _showDiscoverAudiobooks = showDiscAudiobooks;
        _showDiscoverSeries = showDiscSeries;
        _homeRowOrder = rowOrder;
        _discoveryRowEnabled = discoveryRowPrefs;
      });
    }

    // Load discovery folders dynamically (after settings load)
    // Skip if already loaded to avoid unnecessary rebuilds on settings reload
    if (_discoveryFolders.isEmpty) {
      await _loadDiscoveryFolders(forceRefresh: false);
    } else {
      // Just re-sync the row order with current enabled state (no API call)
      setState(() {
        _syncDiscoveryRowOrder(_discoveryFolders);
      });
    }
  }

  Future<void> _loadDiscoveryFolders({bool forceRefresh = false}) async {
    if (!mounted) return;
    final provider = context.read<MusicAssistantProvider>();

    try {
      var folders = await provider.getDiscoveryFoldersWithCache();
      // If cached result is empty, force a refresh to get from API/database
      if (folders.isEmpty && !forceRefresh) {
        _logger.log('🔄 Discovery: Cached folders empty, forcing refresh...');
        folders =
            await provider.getDiscoveryFoldersWithCache(forceRefresh: true);
      }
      final discoveryRowPrefs =
          await SettingsService.getDiscoveryRowPreferences();
      if (mounted) {
        setState(() {
          _discoveryFolders = folders;
          _discoveryRowEnabled = discoveryRowPrefs;
          _syncDiscoveryRowOrder(folders);
        });
      }
    } catch (e) {
      _logger.log('⚠️ Failed to load discovery folders: $e');
    }
  }

  /// Sync discovery row order without calling setState. Only adds new folders, never removes.
  /// Visibility is controlled by _discoveryRowEnabled / _isRowEnabled().
  bool _syncDiscoveryRowOrder(List<RecommendationFolder> folders) {
    bool didModify = false;

    for (final folder in folders) {
      final discoveryRowId = 'discovery:${folder.itemId}';
      if (!_homeRowOrder.contains(discoveryRowId)) {
        _homeRowOrder.add(discoveryRowId);
        didModify = true;
      }
    }

    if (didModify) {
      SettingsService.setHomeRowOrder(_homeRowOrder);
    }
    return didModify;
  }

  Future<void> _onRefresh() async {
    _isPullRefreshing.value = true;
    try {
      // Invalidate cache to force fresh data on pull-to-refresh
      final provider = context.read<MusicAssistantProvider>();
      provider.invalidateHomeCache();

      // Force full library sync from MA API
      await provider.forceLibrarySync();

      // Reload settings in case they changed
      await _loadSettings();

      if (mounted) {
        _refreshSignal.value++;
      }
    } finally {
      _isPullRefreshing.value = false;
    }
  }

  String _connectionStatusTooltip(MAConnectionState state) {
    switch (state) {
      case MAConnectionState.connected:
      case MAConnectionState.authenticated:
        return 'Connected';
      case MAConnectionState.connecting:
      case MAConnectionState.authenticating:
        return 'Connecting...';
      case MAConnectionState.error:
        return 'Connection error - showing cached data';
      case MAConnectionState.disconnected:
        return 'Disconnected - showing cached data';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    // Settings are loaded in initState and didChangeAppLifecycleState - no need to reload on every build
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Without an explicit style here, AppBar computes its own default
        // for a transparent background rather than inheriting the correct
        // one main.dart/SystemUIWrapper already set globally - on this
        // screen that default came out wrong (light/white icons against
        // this screen's light background), making the whole status bar
        // unreadable except the battery glyph. Match it explicitly instead
        // of relying on AppBar's guess.
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(
            'assets/images/klangor_logo.png',
            height: 40,
            fit: BoxFit.contain,
            alignment: Alignment.centerLeft,
          ),
        ),
        titleSpacing: 0,
        centerTitle: false,
        actions: [
          _HomeStatusCluster(
            connectionTooltip: _connectionStatusTooltip,
            suppressSyncSpinner: _isPullRefreshing,
          ),
        ],
      ),
      body: SafeArea(
        child: Selector<MusicAssistantProvider, bool>(
          selector: (_, p) => p.isConnected,
          builder: (context, isConnected, child) {
            final maProvider = context.read<MusicAssistantProvider>();
            final syncService = SyncService.instance;

            // Show cached data even when not connected (if we have cache)
            // Only show disconnected state if we have no cached data at all
            if (!isConnected && !syncService.hasCache) {
              return DisconnectedState.full(
                context: context,
                onSettings: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                ),
              );
            }

            return Stack(
              children: [
                // Main content
                RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: colorScheme.primary,
                  backgroundColor: colorScheme.background,
                  child: _buildConnectedView(context, maProvider),
                ),
                // Connecting banner overlay (doesn't affect layout)
                // Hide when we have cached players - UI is functional during background reconnect
                if (!isConnected &&
                    syncService.hasCache &&
                    !maProvider.hasCachedPlayers)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      color: colorScheme.primaryContainer.withOpacity(0.9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            S.of(context)!.connecting,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Bottom fade gradient to mask content behind mini player (4+ rows only)
                if (_countEnabledRows() >= 4)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: BottomSpacing.miniPlayerHeight,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              colorScheme.background.withOpacity(0.0),
                              colorScheme.background.withOpacity(0.85),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Count how many rows are currently enabled
  int _countEnabledRows() {
    int count = 0;
    for (final rowId in _homeRowOrder) {
      if (_isRowEnabled(rowId)) count++;
    }
    return count;
  }

  /// Check if a specific row is enabled
  bool _isRowEnabled(String rowId) {
    // Discovery folders use the pattern 'discovery:{itemId}'
    if (rowId.startsWith('discovery:')) {
      final itemId = rowId.substring('discovery:'.length);
      // Default to true if not explicitly set
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

  Widget _buildConnectedView(
      BuildContext context, MusicAssistantProvider provider) {
    // Use LayoutBuilder to get available screen height
    return LayoutBuilder(
      builder: (context, constraints) {
        // Each row is always 1/3 of screen height
        // 1 row = 1/3, 2 rows = 2/3, 3 rows = full screen, 4+ rows scroll
        // Reserve space for the mini player overlay at the bottom.
        final miniPlayerSpace = BottomSpacing.miniPlayerHeight + 22.0;
        final availableHeight = constraints.maxHeight - miniPlayerSpace;

        // Account for margins between rows (2px each, 2 margins for 3 rows).
        // Always use the 3-row margin calculation so rowHeight stays stable
        // regardless of how many rows are currently enabled (avoids jitter on reload).
        const marginSize = 2.0;
        final enabledRows = _countEnabledRows();
        const marginsInView =
            2 * marginSize; // always 2 margins for 3-row layout
        final rowHeight = (availableHeight - marginsInView) / 3 + 2;

        // Use Android 12+ stretch overscroll effect
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollStartNotification) {
              _logger.resetFrameStats();
              _logger.perf('SCROLL START', context: 'HomeScreen');
            } else if (notification is ScrollUpdateNotification) {
              _logger.startFrame();
              SchedulerBinding.instance.addPostFrameCallback((_) {
                _logger.endFrame();
              });
            } else if (notification is ScrollEndNotification) {
              _logger.perf('SCROLL END', context: 'HomeScreen');
            }
            return false;
          },
          child: ScrollConfiguration(
            behavior: const _StretchScrollBehavior(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              // For ≤3 rows: no padding needed (rows fit within viewport)
              // For 4+ rows: pad so last row scrolls above mini player
              padding: enabledRows >= 4
                  ? EdgeInsets.only(bottom: miniPlayerSpace)
                  : EdgeInsets.zero,
              child: SizedBox(
                // Ensure minimum height for pull-to-refresh when empty
                height: enabledRows == 0 ? availableHeight : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      _buildOrderedRows(provider, rowHeight, enabledRows == 0),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build rows in the user's configured order
  List<Widget> _buildOrderedRows(
      MusicAssistantProvider provider, double rowHeight, bool isEmpty) {
    final rows = <Widget>[];

    // Show empty state with refresh hint when no rows are enabled
    if (isEmpty) {
      final colorScheme = Theme.of(context).colorScheme;
      final textTheme = Theme.of(context).textTheme;
      rows.add(
        SizedBox.expand(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home_rounded,
                    size: 64,
                    color: colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    S.of(context)!.noRowsEnabled,
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    S.of(context)!.pullToRefreshHint,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.4),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      return rows;
    }

    for (final rowId in _homeRowOrder) {
      final widget = _buildRowWidget(rowId, provider, rowHeight);
      if (widget != null) {
        // Add spacing between rows (not before first row)
        if (rows.isNotEmpty) {
          rows.add(const SizedBox(height: 2.0));
        }
        rows.add(widget);
      }
    }

    return rows;
  }

  /// Build a single row widget by ID, returns null if row is disabled
  Widget? _buildRowWidget(
      String rowId, MusicAssistantProvider provider, double rowHeight) {
    switch (rowId) {
      case 'recent-albums':
        if (!_showRecentAlbums) return null;
        return AlbumRow(
          key: const ValueKey('recent-albums'),
          title: S.of(context)!.recentlyPlayed,
          loadAlbums: () => provider.getRecentAlbumsWithCache(),
          getCachedAlbums: () => provider.getCachedRecentAlbums(),
          refreshSignal: _refreshSignal,
          rowHeight: rowHeight,
        );
      case 'discover-artists':
        if (!_showDiscoverArtists) return null;
        return ArtistRow(
          key: const ValueKey('discover-artists'),
          title: S.of(context)!.discoverArtists,
          loadArtists: () => provider.getDiscoverArtistsWithCache(),
          getCachedArtists: () => provider.getCachedDiscoverArtists(),
          refreshSignal: _refreshSignal,
          rowHeight: rowHeight,
        );
      case 'discover-albums':
        if (!_showDiscoverAlbums) return null;
        return AlbumRow(
          key: const ValueKey('discover-albums'),
          title: S.of(context)!.discoverAlbums,
          loadAlbums: () => provider.getDiscoverAlbumsWithCache(),
          getCachedAlbums: () => provider.getCachedDiscoverAlbums(),
          refreshSignal: _refreshSignal,
          rowHeight: rowHeight,
        );
      case 'continue-listening':
        if (!_showContinueListeningAudiobooks) return null;
        return AudiobookRow(
          key: const ValueKey('continue-listening'),
          title: S.of(context)!.continueListening,
          loadAudiobooks: () => provider.getInProgressAudiobooksWithCache(),
          getCachedAudiobooks: () => provider.getCachedInProgressAudiobooks(),
          rowHeight: rowHeight,
        );
      case 'discover-audiobooks':
        if (!_showDiscoverAudiobooks) return null;
        return AudiobookRow(
          key: const ValueKey('discover-audiobooks'),
          title: S.of(context)!.discoverAudiobooks,
          loadAudiobooks: () => provider.getDiscoverAudiobooksWithCache(),
          getCachedAudiobooks: () => provider.getCachedDiscoverAudiobooks(),
          rowHeight: rowHeight,
        );
      case 'discover-series':
        if (!_showDiscoverSeries) return null;
        return SeriesRow(
          key: const ValueKey('discover-series'),
          title: S.of(context)!.discoverSeries,
          loadSeries: () => provider.getDiscoverSeriesWithCache(),
          getCachedSeries: () => provider.getCachedDiscoverSeries(),
          rowHeight: rowHeight,
        );
      case 'favorite-albums':
        if (!_showFavoriteAlbums) return null;
        return AlbumRow(
          key: const ValueKey('favorite-albums'),
          title: S.of(context)!.favoriteAlbums,
          loadAlbums: () => provider.getFavoriteAlbums(),
          refreshSignal: _refreshSignal,
          rowHeight: rowHeight,
        );
      case 'favorite-artists':
        if (!_showFavoriteArtists) return null;
        return ArtistRow(
          key: const ValueKey('favorite-artists'),
          title: S.of(context)!.favoriteArtists,
          loadArtists: () => provider.getFavoriteArtists(),
          refreshSignal: _refreshSignal,
          rowHeight: rowHeight,
        );
      case 'favorite-tracks':
        if (!_showFavoriteTracks) return null;
        return TrackRow(
          key: const ValueKey('favorite-tracks'),
          title: S.of(context)!.favoriteTracks,
          loadTracks: () => provider.getFavoriteTracks(),
          rowHeight: rowHeight,
        );
      case 'favorite-playlists':
        if (!_showFavoritePlaylists) return null;
        return PlaylistRow(
          key: const ValueKey('favorite-playlists'),
          title: S.of(context)!.favoritePlaylists,
          loadPlaylists: () => provider.getFavoritePlaylistsWithCache(),
          getCachedPlaylists: () => provider.getCachedFavoritePlaylists(),
          heroTagSuffix: 'home',
          rowHeight: rowHeight,
        );
      case 'favorite-radio-stations':
        if (!_showFavoriteRadioStations) return null;
        return RadioStationRow(
          key: const ValueKey('favorite-radio-stations'),
          title: S.of(context)!.favoriteRadioStations,
          loadRadioStations: () => provider.getFavoriteRadioStations(),
          heroTagSuffix: 'home',
          rowHeight: rowHeight,
        );
      case 'favorite-podcasts':
        if (!_showFavoritePodcasts) return null;
        return PodcastRow(
          key: const ValueKey('favorite-podcasts'),
          title: S.of(context)!.favoritePodcasts,
          loadPodcasts: () => provider.getFavoritePodcasts(),
          heroTagSuffix: 'home',
          rowHeight: rowHeight,
        );
      default:
        // Handle dynamic discovery folders
        if (rowId.startsWith('discovery:')) {
          final folderId = rowId.substring('discovery:'.length);
          // Check per-row preference
          final isEnabled = _discoveryRowEnabled[folderId] ?? false;
          if (!isEnabled) return null;

          try {
            final folder = _discoveryFolders.firstWhere(
              (f) => f.itemId == folderId,
            );
            return DiscoveryRow(
              key: ValueKey(rowId),
              title: folder.name,
              loadItems: () => provider.getDiscoveryFolderItems(folderId),
              getCachedItems: () =>
                  provider.getCachedDiscoveryFolderItems(folderId),
              heroTagSuffix: 'home',
              rowHeight: rowHeight,
            );
          } catch (e) {
            // Folder not found, skip this row
          }
        }
        return null;
    }
  }
}

/// Home AppBar's trailing status cluster: connection dot, sync spinner, and
/// the compact player badge. Not all three are visible at all times (the
/// spinner only while syncing, the badge only while another player is
/// active), so spacing can't be baked into each widget individually -
/// whichever item ends up last needs the mini-player's own edge margin, and
/// gaps between whichever items ARE visible need to be consistent. This
/// widget reads all the relevant state in one place and lays the visible
/// subset out itself instead.
class _HomeStatusCluster extends StatelessWidget {
  final String Function(MAConnectionState) connectionTooltip;
  // While true, a pull-to-refresh is already showing its own Material
  // RefreshIndicator spinner for this exact sync - hide ours so the same
  // sync isn't indicated twice at once.
  final ValueListenable<bool> suppressSyncSpinner;

  const _HomeStatusCluster(
      {required this.connectionTooltip, required this.suppressSyncSpinner});

  // Matches the mini-player's own _collapsedMargin in expandable_player.dart
  // so the cluster's trailing edge lines up with the mini-player below it.
  static const double _edgeMargin = 12.0;
  static const double _itemGap = 5.0;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: suppressSyncSpinner,
      builder: (context, isPullRefreshing, _) {
        return Selector<
            MusicAssistantProvider,
            ({
              MAConnectionState connectionState,
              bool compact,
              int playingCount
            })>(
          selector: (_, p) {
            final miniPlayerHidden = (!p.isConnected && !p.hasCachedPlayers) ||
                p.selectedPlayer == null;
            final selectedPlayerId = p.selectedPlayer?.playerId;
            final playingCount = p.availablePlayers
                .where((pl) =>
                    pl.state == 'playing' &&
                    pl.playerId != selectedPlayerId &&
                    !pl.isExternalSource)
                .length;
            return (
              connectionState: p.connectionState,
              compact: !miniPlayerHidden,
              playingCount: playingCount
            );
          },
          builder: (context, state, _) {
            return ListenableBuilder(
              listenable: SyncService.instance,
              builder: (context, _) {
                final colorScheme = Theme.of(context).colorScheme;
                final isSyncing =
                    SyncService.instance.isSyncing && !isPullRefreshing;

                final Color dotColor;
                switch (state.connectionState) {
                  case MAConnectionState.connected:
                  case MAConnectionState.authenticated:
                    dotColor = Colors.green;
                  case MAConnectionState.connecting:
                  case MAConnectionState.authenticating:
                    dotColor = Colors.amber;
                  case MAConnectionState.error:
                  case MAConnectionState.disconnected:
                    dotColor = Colors.red;
                }

                final dot = Tooltip(
                  message: connectionTooltip(state.connectionState),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: dotColor),
                  ),
                );

                final spinner = SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary.withOpacity(0.7)),
                  ),
                );

                // Build only the items that actually render something, joined
                // by a fixed gap - so the gap sequence is always correct no
                // matter which subset is visible this frame.
                final children = <Widget>[dot];
                if (isSyncing) {
                  children.add(const SizedBox(width: _itemGap));
                  children.add(spinner);
                }
                if (state.compact && state.playingCount > 0) {
                  children.add(const SizedBox(width: _itemGap));
                  children.add(PlayerSelector(compact: true));
                }

                // Full pill (no player selected yet) is a distinct, self-
                // contained widget - not part of the tight icon cluster.
                if (!state.compact) {
                  children.add(const SizedBox(width: _itemGap));
                  children.add(const PlayerSelector(compact: false));
                }

                return Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: _edgeMargin),
                  child:
                      Row(mainAxisSize: MainAxisSize.min, children: children),
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Custom scroll behavior that uses Android 12+ stretch overscroll effect
class _StretchScrollBehavior extends ScrollBehavior {
  const _StretchScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return StretchingOverscrollIndicator(
      axisDirection: details.direction,
      child: child,
    );
  }
}
