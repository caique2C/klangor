import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../l10n/app_localizations.dart';
import '../models/media_item.dart';
import '../providers/music_assistant_provider.dart';
import '../services/debug_logger.dart';
import 'playlist_card.dart';
import 'radio_station_card.dart';

class DiscoveryRow extends StatefulWidget {
  final String title;
  final Future<List<MediaItem>> Function() loadItems;
  final String? heroTagSuffix;
  final double? rowHeight;
  /// Optional: synchronous getter for cached data (for instant display)
  final List<MediaItem>? Function()? getCachedItems;

  const DiscoveryRow({
    super.key,
    required this.title,
    required this.loadItems,
    this.heroTagSuffix,
    this.rowHeight,
    this.getCachedItems,
  });

  @override
  State<DiscoveryRow> createState() => _DiscoveryRowState();
}

class _DiscoveryRowState extends State<DiscoveryRow> with AutomaticKeepAliveClientMixin {
  List<MediaItem> _items = [];
  bool _isLoading = true;
  bool _hasLoaded = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Get cached data synchronously BEFORE first build (no spinner flash)
    final cached = widget.getCachedItems?.call();
    if (cached != null && cached.isNotEmpty) {
      _items = cached;
      _isLoading = false;
    }
    _loadItems();
  }

  Future<void> _loadItems() async {
    if (_hasLoaded) return;
    _hasLoaded = true;

    // Load fresh data (always update - fresh data may have images that cached data lacks)
    try {
      final freshItems = await widget.loadItems();
      if (mounted && freshItems.isNotEmpty) {
        setState(() {
          _items = freshItems;
          _isLoading = false;
        });
        // Pre-cache images for smooth hero animations
        _precacheImages(freshItems);
      }
    } catch (e) {
      // Silent failure - keep showing cached data
    }

    if (mounted && _isLoading) {
      setState(() => _isLoading = false);
    }
  }

  /// Pre-cache images so hero animations are smooth on first tap
  void _precacheImages(List<MediaItem> items) {
    if (!mounted) return;
    final maProvider = context.read<MusicAssistantProvider>();

    // Only precache first ~10 visible items to avoid excessive network/memory use
    final itemsToCache = items.take(10);

    for (final item in itemsToCache) {
      final imageUrl = maProvider.api?.getImageUrl(item, size: 256);
      if (imageUrl != null) {
        // Use CachedNetworkImageProvider to warm the cache
        precacheImage(
          CachedNetworkImageProvider(imageUrl),
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
    if (_items.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_items.isEmpty) {
      return Center(
        child: Text(
          S.of(context)!.noAlbumsFound,
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
        ),
      );
    }

    // Card layout: square artwork + text below
    // Text area: 8px gap + ~18px title + ~18px subtitle = ~44px, plus the
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
          itemCount: _items.length,
          itemExtent: itemExtent,
          cacheExtent: 500, // Preload ~3 items ahead for smoother scrolling
          addAutomaticKeepAlives: false, // Row already uses AutomaticKeepAliveClientMixin
          addRepaintBoundaries: false, // Cards already have RepaintBoundary
          itemBuilder: (context, index) {
            final item = _items[index];
            final key = ValueKey(item.uri ?? item.itemId);

            Widget card;
            if (item is Playlist) {
              card = PlaylistCard(
                playlist: item,
                heroTagSuffix: widget.heroTagSuffix,
                imageCacheSize: 256,
              );
            } else if (item.mediaType == MediaType.radio) {
              card = RadioStationCard(
                radioStation: item,
                heroTagSuffix: widget.heroTagSuffix,
                imageCacheSize: 256,
              );
            } else {
              // Fallback for other media types
              card = _buildFallbackCard(item, cardWidth);
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Container(
                key: key,
                width: cardWidth,
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                child: card,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFallbackCard(MediaItem item, double width) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIconForMediaType(item.mediaType),
                size: 48,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.name,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _getIconForMediaType(MediaType type) {
    switch (type) {
      case MediaType.album:
        return Icons.album;
      case MediaType.artist:
        return Icons.person;
      case MediaType.track:
        return Icons.music_note;
      case MediaType.playlist:
        return Icons.playlist_play;
      case MediaType.radio:
        return Icons.radio;
      case MediaType.audiobook:
        return Icons.book;
      case MediaType.podcast:
        return Icons.podcasts;
      case MediaType.podcastEpisode:
        return Icons.podcasts;
      default:
        return Icons.audiotrack;
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.startBuild('DiscoveryRow:${widget.title}');
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Total row height includes title + content
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
    _logger.endBuild('DiscoveryRow:${widget.title}');
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
