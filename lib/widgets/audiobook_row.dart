import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/image_prefetch_service.dart';
import '../l10n/app_localizations.dart';
import '../models/media_item.dart';
import '../providers/music_assistant_provider.dart';
import '../services/debug_logger.dart';
import '../utils/page_transitions.dart';
import '../screens/audiobook_detail_screen.dart';
import '../constants/hero_tags.dart';
import '../services/library_status_service.dart';
import 'provider_icon.dart';
import 'media_context_menu.dart';
import 'library_status_builder.dart';

class AudiobookRow extends StatefulWidget {
  final String title;
  final Future<List<Audiobook>> Function() loadAudiobooks;
  final String? heroTagSuffix;
  final double? rowHeight;
  /// Optional: synchronous getter for cached data (for instant display)
  final List<Audiobook>? Function()? getCachedAudiobooks;

  const AudiobookRow({
    super.key,
    required this.title,
    required this.loadAudiobooks,
    this.heroTagSuffix,
    this.rowHeight,
    this.getCachedAudiobooks,
  });

  @override
  State<AudiobookRow> createState() => _AudiobookRowState();
}

class _AudiobookRowState extends State<AudiobookRow> with AutomaticKeepAliveClientMixin {
  List<Audiobook> _audiobooks = [];
  bool _isLoading = true;
  bool _hasLoaded = false;
  bool _hasPrecachedAudiobooks = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Get cached data synchronously BEFORE first build (no spinner flash)
    final cached = widget.getCachedAudiobooks?.call();
    if (cached != null && cached.isNotEmpty) {
      _audiobooks = cached;
      _isLoading = false;
    }
    _loadAudiobooks();
  }

  Future<void> _loadAudiobooks() async {
    if (_hasLoaded) return;
    _hasLoaded = true;

    // Load fresh data (always update - fresh data may have updated progress)
    try {
      final freshAudiobooks = await widget.loadAudiobooks();
      if (mounted && freshAudiobooks.isNotEmpty) {
        setState(() {
          _audiobooks = freshAudiobooks;
          _isLoading = false;
        });
        // Pre-cache images for smooth hero animations
        _precacheAudiobookImages(freshAudiobooks);
      }
    } catch (e) {
      // Silent failure - keep showing cached data
    }

    if (mounted && _isLoading) {
      setState(() => _isLoading = false);
    }
  }

  /// Pre-cache audiobook images so Hero animations are smooth on first tap
  void _precacheAudiobookImages(List<Audiobook> audiobooks) {
    if (!mounted || _hasPrecachedAudiobooks) return;
    _hasPrecachedAudiobooks = true;

    final maProvider = context.read<MusicAssistantProvider>();

    // Only precache first ~10 visible items
    final audiobooksToCache = audiobooks.take(10);

    for (final audiobook in audiobooksToCache) {
      final imageUrl = maProvider.api?.getImageUrl(audiobook, size: 256);
      if (imageUrl != null) {
        precacheImage(
          CachedNetworkImageProvider(imageUrl, cacheManager: AlbumImageCacheManager()),
          context,
        ).catchError((_) {
          // Silently ignore precache errors
        });
      }
    }
  }

  static final _logger = DebugLogger();

  Widget _buildContent(double contentHeight, double availableWidth, ColorScheme colorScheme, MusicAssistantProvider maProvider) {
    // Only show loading if we have no data at all
    if (_audiobooks.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_audiobooks.isEmpty) {
      return Center(
        child: Text(
          S.of(context)!.noAudiobooks,
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
        ),
      );
    }

    const textAreaHeight = 44.0;
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
    final itemExtent = cardWidth + itemMargin;

    return Padding(
      // Constrains the viewport itself (unlike ListView's own `padding`,
      // which only insets content within an unchanged, full-width
      // viewport - leaving a 5th item visible in that leftover space).
      padding: const EdgeInsets.symmetric(horizontal: outerPadding / 2),
      child: ScrollConfiguration(
        behavior: const _StretchScrollBehavior(),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _audiobooks.length,
          itemExtent: itemExtent,
          cacheExtent: 500,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          itemBuilder: (context, index) {
            final audiobook = _audiobooks[index];
            return Container(
              key: ValueKey(audiobook.uri ?? audiobook.itemId),
              width: cardWidth,
              margin: const EdgeInsets.symmetric(horizontal: 6.0),
              child: _AudiobookCard(
                audiobook: audiobook,
                heroTagSuffix: widget.heroTagSuffix ?? 'home_${widget.title.replaceAll(' ', '_').toLowerCase()}',
                maProvider: maProvider,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.startBuild('AudiobookRow:${widget.title}');
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final maProvider = context.read<MusicAssistantProvider>();

    final totalHeight = widget.rowHeight ?? 237.0;
    const titleHeight = 44.0;
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
              child: _buildContent(contentHeight, availableWidth, colorScheme, maProvider),
            ),
          ],
        ),
      ),
    );
    _logger.endBuild('AudiobookRow:${widget.title}');
    return result;
  }
}

class _AudiobookCard extends StatefulWidget {
  final Audiobook audiobook;
  final String heroTagSuffix;
  final MusicAssistantProvider maProvider;

  const _AudiobookCard({
    required this.audiobook,
    required this.heroTagSuffix,
    required this.maProvider,
  });

  @override
  State<_AudiobookCard> createState() => _AudiobookCardState();
}

class _AudiobookCardState extends State<_AudiobookCard> with LibraryStatusMixin {
  @override
  String get libraryItemKey => LibraryStatusService.makeKey(
    'audiobook',
    widget.audiobook.provider,
    widget.audiobook.itemId,
  );

  @override
  void initState() {
    super.initState();
    // Initialize status in centralized service from widget data
    final service = LibraryStatusService.instance;
    final key = libraryItemKey;
    if (!service.isInLibrary(key) && widget.audiobook.inLibrary) {
      service.setLibraryStatus(key, true);
    }
    if (!service.isFavorite(key) && (widget.audiobook.favorite ?? false)) {
      service.setFavoriteStatus(key, true);
    }
  }

  Future<void> _toggleFavorite() async {
    final maProvider = context.read<MusicAssistantProvider>();
    final currentFavorite = isFavorite;
    final newState = !currentFavorite;

    // Optimistic update via centralized service
    setFavoriteStatus(newState);

    try {
      bool success;
      if (newState) {
        String actualProvider = widget.audiobook.provider;
        String actualItemId = widget.audiobook.itemId;

        if (widget.audiobook.providerMappings != null && widget.audiobook.providerMappings!.isNotEmpty) {
          final mapping = widget.audiobook.providerMappings!.firstWhere(
            (m) => m.available && m.providerInstance != 'library',
            orElse: () => widget.audiobook.providerMappings!.firstWhere(
              (m) => m.available,
              orElse: () => widget.audiobook.providerMappings!.first,
            ),
          );
          actualProvider = mapping.providerDomain;
          actualItemId = mapping.itemId;
        }

        success = await maProvider.addToFavorites(
          mediaType: 'audiobook',
          itemId: actualItemId,
          provider: actualProvider,
        );
      } else {
        int? libraryItemId;
        if (widget.audiobook.provider == 'library') {
          libraryItemId = int.tryParse(widget.audiobook.itemId);
        } else if (widget.audiobook.providerMappings != null) {
          final libraryMapping = widget.audiobook.providerMappings!.firstWhere(
            (m) => m.providerInstance == 'library',
            orElse: () => widget.audiobook.providerMappings!.first,
          );
          if (libraryMapping.providerInstance == 'library') {
            libraryItemId = int.tryParse(libraryMapping.itemId);
          }
        }

        if (libraryItemId == null) {
          rollbackFavoriteOperation();
          return;
        }

        success = await maProvider.removeFromFavorites(
          mediaType: 'audiobook',
          libraryItemId: libraryItemId,
        );
      }

      if (success && mounted) {
        completeFavoriteOperation();
        maProvider.invalidateHomeCache();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newState ? S.of(context)!.addedToFavorites : S.of(context)!.removedFromFavorites),
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        rollbackFavoriteOperation();
      }
    } catch (e) {
      rollbackFavoriteOperation();
    }
  }

  Future<void> _toggleLibrary() async {
    final maProvider = context.read<MusicAssistantProvider>();
    final currentInLibrary = isInLibrary;
    final newState = !currentInLibrary;

    try {
      if (newState) {
        String? actualProvider;
        String? actualItemId;

        if (widget.audiobook.providerMappings != null && widget.audiobook.providerMappings!.isNotEmpty) {
          final nonLibraryMapping = widget.audiobook.providerMappings!.where(
            (m) => m.providerInstance != 'library' && m.providerDomain != 'library',
          ).firstOrNull;

          if (nonLibraryMapping != null) {
            actualProvider = nonLibraryMapping.providerDomain;
            actualItemId = nonLibraryMapping.itemId;
          }
        }

        if (actualProvider == null || actualItemId == null) {
          if (widget.audiobook.provider != 'library') {
            actualProvider = widget.audiobook.provider;
            actualItemId = widget.audiobook.itemId;
          } else {
            return;
          }
        }

        // Optimistic update via centralized service
        setLibraryStatus(newState);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context)!.addedToLibrary),
              duration: const Duration(seconds: 1),
            ),
          );
        }

        final success = await maProvider.addToLibrary(
          mediaType: 'audiobook',
          provider: actualProvider,
          itemId: actualItemId,
        );

        if (success) {
          completeLibraryOperation();
        } else {
          rollbackLibraryOperation();
        }
      } else {
        int? libraryItemId;
        if (widget.audiobook.provider == 'library') {
          libraryItemId = int.tryParse(widget.audiobook.itemId);
        } else if (widget.audiobook.providerMappings != null) {
          final libraryMapping = widget.audiobook.providerMappings!.firstWhere(
            (m) => m.providerInstance == 'library',
            orElse: () => widget.audiobook.providerMappings!.first,
          );
          if (libraryMapping.providerInstance == 'library') {
            libraryItemId = int.tryParse(libraryMapping.itemId);
          }
        }

        if (libraryItemId == null) return;

        // Optimistic update via centralized service
        setLibraryStatus(newState);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context)!.removedFromLibrary),
              duration: const Duration(seconds: 1),
            ),
          );
        }

        final success = await maProvider.removeFromLibrary(
          mediaType: 'audiobook',
          libraryItemId: libraryItemId,
        );

        if (success) {
          completeLibraryOperation();
        } else {
          rollbackLibraryOperation();
        }
      }
    } catch (e) {
      rollbackLibraryOperation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final imageUrl = widget.maProvider.getImageUrl(widget.audiobook, size: 256);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          FadeSlidePageRoute(
            child: AudiobookDetailScreen(
              audiobook: widget.audiobook,
              heroTagSuffix: widget.heroTagSuffix,
              initialImageUrl: imageUrl,
            ),
          ),
        );
      },
      onLongPressStart: (details) {
        MediaContextMenu.show(
          context: context,
          position: details.globalPosition,
          mediaType: ContextMenuMediaType.audiobook,
          item: widget.audiobook,
          isFavorite: isFavorite,
          isInLibrary: isInLibrary,
          onToggleFavorite: _toggleFavorite,
          onToggleLibrary: _toggleLibrary,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Hero(
                  tag: HeroTags.audiobookCover + (widget.audiobook.uri ?? widget.audiobook.itemId) + '_${widget.heroTagSuffix}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: colorScheme.surfaceContainerHighest,
                      child: imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              cacheManager: AlbumImageCacheManager(),
                              // PERF: Duration.zero for hero-wrapped images
                              fadeInDuration: Duration.zero,
                              fadeOutDuration: Duration.zero,
                              memCacheWidth: 256,
                              memCacheHeight: 256,
                              placeholder: (_, __) => Center(
                                child: Icon(
                                  Icons.menu_book,
                                  size: 48,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              errorWidget: (_, __, ___) => Center(
                                child: Icon(
                                  Icons.menu_book,
                                  size: 48,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.menu_book,
                                size: 48,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                    ),
                  ),
                ),
                // Progress indicator
                if (widget.audiobook.progress > 0)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      child: LinearProgressIndicator(
                        value: widget.audiobook.progress,
                        backgroundColor: Colors.black54,
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                        minHeight: 4,
                      ),
                    ),
                  ),
                // Provider icon overlay
                if (widget.audiobook.providerMappings?.isNotEmpty == true)
                  ProviderIconOverlay(
                    domain: widget.audiobook.providerMappings!.first.providerDomain,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Hero(
            tag: HeroTags.audiobookTitle + (widget.audiobook.uri ?? widget.audiobook.itemId) + '_${widget.heroTagSuffix}',
            child: Material(
              color: Colors.transparent,
              child: Text(
                widget.audiobook.name,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Text(
            widget.audiobook.authorsString,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

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
