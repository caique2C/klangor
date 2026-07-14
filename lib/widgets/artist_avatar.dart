import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/media_item.dart';
import '../providers/music_assistant_provider.dart';
import '../services/image_prefetch_service.dart';
import '../services/debug_logger.dart';

/// A CircleAvatar that shows the artist image from Music Assistant.
class ArtistAvatar extends StatefulWidget {
  final Artist artist;
  final double radius;
  final int imageSize;
  final String? heroTag;

  const ArtistAvatar({
    super.key,
    required this.artist,
    this.radius = 24,
    this.imageSize = 128,
    this.heroTag,
  });

  @override
  State<ArtistAvatar> createState() => _ArtistAvatarState();
}

class _ArtistAvatarState extends State<ArtistAvatar> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Computed fresh every build (cheap - just a metadata lookup + string
    // build) rather than cached in State: a cached value could only ever
    // go stale if the artist's underlying image data changes - e.g. a
    // library re-sync minting a new server-side image id after the MA
    // server restarts/upgrades - and there's no reliable, cheap signal for
    // "did that change" that's worth chasing instead of just not caching.
    final imageUrl = context.read<MusicAssistantProvider>().getImageUrl(widget.artist, size: widget.imageSize);

    Widget avatarContent;
    if (imageUrl != null) {
      avatarContent = ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: widget.radius * 2,
          height: widget.radius * 2,
          fit: BoxFit.cover,
          // PERF: Use imageSize for memory cache to reduce decode overhead.
          // Only constrain one dimension so non-square source photos (e.g.
          // band photos) keep their aspect ratio during decode instead of
          // being squashed to a square before BoxFit.cover can crop them.
          memCacheWidth: widget.imageSize,
          // Share the cache artist images are prefetched into after sync.
          cacheManager: ArtistImageCacheManager(),
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          placeholder: (context, url) => Container(
            color: colorScheme.surfaceVariant,
            child: Icon(Icons.person_rounded, color: colorScheme.onSurfaceVariant),
          ),
          errorWidget: (context, url, error) {
            DebugLogger().log('⚠️ ArtistAvatar: failed to load $url for "${widget.artist.name}": $error');
            return Container(
              color: colorScheme.surfaceVariant,
              child: Icon(Icons.person_rounded, color: colorScheme.onSurfaceVariant),
            );
          },
        ),
      );
    } else {
      avatarContent = CircleAvatar(
        radius: widget.radius,
        backgroundColor: colorScheme.surfaceVariant,
        child: Icon(Icons.person_rounded, color: colorScheme.onSurfaceVariant),
      );
    }

    final avatar = SizedBox(
      width: widget.radius * 2,
      height: widget.radius * 2,
      child: avatarContent,
    );

    if (widget.heroTag != null) {
      return Hero(
        tag: widget.heroTag!,
        child: avatar,
      );
    }

    return avatar;
  }
}
