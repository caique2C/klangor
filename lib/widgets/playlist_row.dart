import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../l10n/app_localizations.dart';
import '../models/media_item.dart';
import '../providers/music_assistant_provider.dart';
import '../services/debug_logger.dart';
import 'playlist_card.dart';

class PlaylistRow extends StatefulWidget {
  final String title;
  final Future<List<Playlist>> Function() loadPlaylists;
  final String? heroTagSuffix;
  final double? rowHeight;
  final List<Playlist>? Function()? getCachedPlaylists;

  const PlaylistRow({
    super.key,
    required this.title,
    required this.loadPlaylists,
    this.heroTagSuffix,
    this.rowHeight,
    this.getCachedPlaylists,
  });

  @override
  State<PlaylistRow> createState() => _PlaylistRowState();
}

class _PlaylistRowState extends State<PlaylistRow> with AutomaticKeepAliveClientMixin {
  List<Playlist> _playlists = [];
  bool _isLoading = true;
  bool _hasLoaded = false;

  static final _logger = DebugLogger();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Get cached data synchronously BEFORE first build (no spinner flash)
    final cached = widget.getCachedPlaylists?.call();
    if (cached != null && cached.isNotEmpty) {
      _playlists = cached;
      _isLoading = false;
    }
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    if (_hasLoaded) return;
    _hasLoaded = true;

    // Load fresh data
    try {
      final freshPlaylists = await widget.loadPlaylists();
      if (mounted && freshPlaylists.isNotEmpty) {
        setState(() {
          _playlists = freshPlaylists;
          _isLoading = false;
        });
        // Pre-cache images for smooth hero animations
        _precachePlaylistImages(freshPlaylists);
      }
    } catch (e) {
      // Silent failure - keep showing cached data
    }

    if (mounted && _isLoading) {
      setState(() => _isLoading = false);
    }
  }

  void _precachePlaylistImages(List<Playlist> playlists) {
    if (!mounted) return;
    final maProvider = context.read<MusicAssistantProvider>();

    final playlistsToCache = playlists.take(10);

    for (final playlist in playlistsToCache) {
      final imageUrl = maProvider.api?.getImageUrl(playlist, size: 256);
      if (imageUrl != null) {
        precacheImage(
          CachedNetworkImageProvider(imageUrl),
          context,
        ).catchError((_) => false);
      }
    }
  }

  Widget _buildContent(double contentHeight, double availableWidth, ColorScheme colorScheme) {
    // Only show loading if we have no data at all
    if (_playlists.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_playlists.isEmpty) {
      return Center(
        child: Text(
          S.of(context)!.noPlaylistsFound,
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
        ),
      );
    }

    // Card layout: square artwork + text below (same as AlbumRow)
    // Text area: 8px gap + ~18px title + ~18px owner = ~44px, plus the
    // item's own 4px bottom padding (see itemBuilder below) that isn't
    // otherwise accounted for in this budget.
    const textAreaHeight = 56.0;
    // Size cards so exactly 4 fit across the row's width instead of
    // however many happen to fit given a height-driven size (which left a
    // 5th card peeking in). Capped by the row's own height so cards never
    // overflow it - if the width-driven size is shorter, the card simply
    // leaves a bit of empty space below instead of stretching to fill it.
    const targetColumns = 4;
    const itemMargin = 12.0; // 6 each side - the item's own margin also
    // contributes to the inset of the very first/last card, so the outer
    // Padding below only needs to make up the rest of the mini-player's
    // 12px-each-side margin (see edgeInset).
    const edgeInset = 12.0; // Matches the mini-player's own edge margin
    const outerPadding = 2 * edgeInset - itemMargin; // 6 each side
    final heightBasedMax = contentHeight - textAreaHeight;
    final widthBasedSize = (availableWidth - outerPadding) / targetColumns - itemMargin;
    // Small tolerance: the row-height formula's rounding can leave
    // heightBasedMax a fraction of a pixel short of widthBasedSize, which
    // would otherwise block the width-based size for an imperceptible
    // reason and leave a sliver of a 5th card peeking in again.
    const heightTolerance = 4.0;
    final cardWidth = widthBasedSize <= heightBasedMax + heightTolerance ? widthBasedSize : heightBasedMax;
    final itemExtent = cardWidth + itemMargin; // width + horizontal margins

    return Padding(
      // Constrains the viewport itself (unlike ListView's own `padding`,
      // which only insets content within an unchanged, full-width
      // viewport - leaving a 5th item visible in that leftover space).
      padding: const EdgeInsets.symmetric(horizontal: outerPadding / 2),
      child: ScrollConfiguration(
        behavior: const _StretchScrollBehavior(),
        child: ListView.builder(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          itemCount: _playlists.length,
          itemExtent: itemExtent,
          cacheExtent: 500, // Preload ~3 items ahead for smoother scrolling
          addAutomaticKeepAlives: false, // Row already uses AutomaticKeepAliveClientMixin
          addRepaintBoundaries: false, // Cards already have RepaintBoundary
          itemBuilder: (context, index) {
            final playlist = _playlists[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Container(
                key: ValueKey(playlist.uri ?? playlist.itemId),
                width: cardWidth,
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                child: PlaylistCard(
                  playlist: playlist,
                  heroTagSuffix: widget.heroTagSuffix,
                  imageCacheSize: 256,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.startBuild('PlaylistRow:${widget.title}');
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Total row height includes title + content (same as AlbumRow)
    final totalHeight = widget.rowHeight ?? 237.0; // Default: 44 title + 193 content
    const titleHeight = 44.0; // 12 top padding + ~24 text + 8 bottom padding
    final contentHeight = totalHeight - titleHeight;
    final availableWidth = MediaQuery.of(context).size.width;

    final result = RepaintBoundary(
      child: SizedBox(
        height: totalHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              child: Text(
                widget.title,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
            ),
            Expanded(
              child: _buildContent(contentHeight, availableWidth, colorScheme),
            ),
          ],
        ),
      ),
    );
    _logger.endBuild('PlaylistRow:${widget.title}');
    return result;
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
