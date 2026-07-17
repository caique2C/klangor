import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../l10n/app_localizations.dart';
import '../models/media_item.dart';
import '../providers/music_assistant_provider.dart';
import '../services/debug_logger.dart';
import '../services/image_prefetch_service.dart';
import 'artist_card.dart';

class ArtistRow extends StatefulWidget {
  final String title;
  final Future<List<Artist>> Function() loadArtists;
  final String? heroTagSuffix;
  final double? rowHeight;
  /// Optional: synchronous getter for cached data (for instant display)
  final List<Artist>? Function()? getCachedArtists;
  /// Optional: signal to trigger in-place reload without destroying the widget
  final ValueNotifier<int>? refreshSignal;

  const ArtistRow({
    super.key,
    required this.title,
    required this.loadArtists,
    this.heroTagSuffix,
    this.rowHeight,
    this.getCachedArtists,
    this.refreshSignal,
  });

  @override
  State<ArtistRow> createState() => _ArtistRowState();
}

class _ArtistRowState extends State<ArtistRow> with AutomaticKeepAliveClientMixin {
  List<Artist> _artists = [];
  bool _isLoading = true;
  bool _hasLoaded = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Get cached data synchronously BEFORE first build (no spinner flash)
    final cached = widget.getCachedArtists?.call();
    if (cached != null && cached.isNotEmpty) {
      _artists = cached;
      _isLoading = false;
    }
    _loadArtists();
    widget.refreshSignal?.addListener(_onRefreshSignal);
  }

  void _onRefreshSignal() {
    if (!mounted) return;
    _hasLoaded = false;
    _loadArtists();
  }

  @override
  void dispose() {
    widget.refreshSignal?.removeListener(_onRefreshSignal);
    super.dispose();
  }

  Future<void> _loadArtists() async {
    if (_hasLoaded) return;
    _hasLoaded = true;

    // Load fresh data (always update - fresh data may have images that cached data lacks)
    try {
      final freshArtists = await widget.loadArtists();
      if (mounted && freshArtists.isNotEmpty) {
        setState(() {
          _artists = freshArtists;
          _isLoading = false;
        });
        // Pre-cache images for smooth hero animations
        _precacheArtistImages(freshArtists);
      }
    } catch (e) {
      // Silent failure - keep showing cached data
    }

    if (mounted && _isLoading) {
      setState(() => _isLoading = false);
    }
  }

  /// Pre-cache artist images so hero animations are smooth on first tap
  void _precacheArtistImages(List<Artist> artists) {
    if (!mounted) return;
    final maProvider = context.read<MusicAssistantProvider>();

    // Only precache first ~10 visible items to avoid excessive network/memory use
    final artistsToCache = artists.take(10);

    for (final artist in artistsToCache) {
      final imageUrl = maProvider.api?.getImageUrl(artist, size: 256);
      if (imageUrl != null) {
        // Use CachedNetworkImageProvider to warm the cache
        precacheImage(
          CachedNetworkImageProvider(imageUrl, cacheManager: ArtistImageCacheManager()),
          context,
        ).catchError((_) {
          // Silently ignore precache errors
        });
      }
    }
  }

  static final _logger = DebugLogger();

  Widget _buildContent(double contentHeight, double availableWidth, ColorScheme colorScheme) {
    // Only show loading if we have no data at all
    if (_artists.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_artists.isEmpty) {
      return Center(
        child: Text(
          S.of(context)!.noArtistsFound,
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
        ),
      );
    }

    // Card layout: circle image + name below
    // Text area: 8px gap + ~36px for 2-line name = ~44px, plus a small
    // safety margin since actual rendered text height can exceed the estimate.
    const textAreaHeight = 48.0;
    // Size cards so exactly 4 fit across the row's width instead of
    // however many happen to fit given a height-driven size (which left a
    // 5th card peeking in). Capped by the row's own height so cards never
    // overflow it - if the width-driven size is shorter, the card simply
    // leaves a bit of empty space below instead of stretching to fill it.
    const targetColumns = 4;
    const itemMargin = 16.0; // 8 each side - the item's own margin also
    // contributes to the inset of the very first/last card, so the outer
    // Padding below only needs to make up the rest of the mini-player's
    // 12px-each-side margin (see edgeInset).
    const edgeInset = 12.0; // Matches the mini-player's own edge margin
    const outerPadding = 2 * edgeInset - itemMargin; // 4 each side
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
          scrollDirection: Axis.horizontal,
          itemCount: _artists.length,
          itemExtent: itemExtent,
          cacheExtent: 500, // Preload ~3 items ahead for smoother scrolling
          addAutomaticKeepAlives: false, // Row already uses AutomaticKeepAliveClientMixin
          addRepaintBoundaries: false, // Cards already have RepaintBoundary
          itemBuilder: (context, index) {
            final artist = _artists[index];
            return Container(
              key: ValueKey(artist.uri ?? artist.itemId),
              width: cardWidth,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ArtistCard(
                artist: artist,
                heroTagSuffix: widget.heroTagSuffix,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.startBuild('ArtistRow:${widget.title}');
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Total row height includes title + content
    final totalHeight = widget.rowHeight ?? 207.0; // Default: 44 title + 163 content
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
    _logger.endBuild('ArtistRow:${widget.title}');
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
