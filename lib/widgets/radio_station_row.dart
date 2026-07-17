import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../l10n/app_localizations.dart';
import '../models/media_item.dart';
import '../providers/music_assistant_provider.dart';
import '../services/debug_logger.dart';
import 'radio_station_card.dart';

class RadioStationRow extends StatefulWidget {
  final String title;
  final Future<List<MediaItem>> Function() loadRadioStations;
  final String? heroTagSuffix;
  final double? rowHeight;
  final List<MediaItem>? Function()? getCachedRadioStations;

  const RadioStationRow({
    super.key,
    required this.title,
    required this.loadRadioStations,
    this.heroTagSuffix,
    this.rowHeight,
    this.getCachedRadioStations,
  });

  @override
  State<RadioStationRow> createState() => _RadioStationRowState();
}

class _RadioStationRowState extends State<RadioStationRow> with AutomaticKeepAliveClientMixin {
  List<MediaItem> _radioStations = [];
  bool _isLoading = true;
  bool _hasLoaded = false;

  static final _logger = DebugLogger();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Get cached data synchronously BEFORE first build (no spinner flash)
    final cached = widget.getCachedRadioStations?.call();
    if (cached != null && cached.isNotEmpty) {
      _radioStations = cached;
      _isLoading = false;
    }
    _loadRadioStations();
  }

  Future<void> _loadRadioStations() async {
    if (_hasLoaded) return;
    _hasLoaded = true;

    // Load fresh data
    try {
      final freshStations = await widget.loadRadioStations();
      if (mounted && freshStations.isNotEmpty) {
        setState(() {
          _radioStations = freshStations;
          _isLoading = false;
        });
        // Pre-cache images for smooth hero animations
        _precacheRadioImages(freshStations);
      }
    } catch (e) {
      // Silent failure - keep showing cached data
    }

    if (mounted && _isLoading) {
      setState(() => _isLoading = false);
    }
  }

  void _precacheRadioImages(List<MediaItem> stations) {
    if (!mounted) return;
    final maProvider = context.read<MusicAssistantProvider>();

    final stationsToCache = stations.take(10);

    for (final station in stationsToCache) {
      final imageUrl = maProvider.api?.getImageUrl(station, size: 256);
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
    if (_radioStations.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_radioStations.isEmpty) {
      return Center(
        child: Text(
          S.of(context)!.noRadioStations,
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
        ),
      );
    }

    // Card layout: circle image + name below (same as ArtistRow)
    // Text area: 8px gap + ~36px for 2-line name = ~44px
    const textAreaHeight = 44.0;
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
          itemCount: _radioStations.length,
          itemExtent: itemExtent,
          cacheExtent: 500, // Preload ~3 items ahead for smoother scrolling
          addAutomaticKeepAlives: false, // Row already uses AutomaticKeepAliveClientMixin
          addRepaintBoundaries: false, // Cards already have RepaintBoundary
          itemBuilder: (context, index) {
            final station = _radioStations[index];
            return Container(
              key: ValueKey(station.uri ?? station.itemId),
              width: cardWidth,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RadioStationCard(
                radioStation: station,
                heroTagSuffix: widget.heroTagSuffix,
                imageCacheSize: 256,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.startBuild('RadioStationRow:${widget.title}');
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Total row height includes title + content (same as ArtistRow)
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
    _logger.endBuild('RadioStationRow:${widget.title}');
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
