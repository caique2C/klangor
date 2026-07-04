import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/media_item.dart';
import '../providers/music_assistant_provider.dart';
import '../services/image_prefetch_service.dart';

/// A CircleAvatar that shows the artist image from Music Assistant.
class ArtistAvatar extends StatefulWidget {
  final Artist artist;
  final double radius;
  final int imageSize;
  final String? heroTag;
  final ValueChanged<String?>? onImageLoaded;

  const ArtistAvatar({
    super.key,
    required this.artist,
    this.radius = 24,
    this.imageSize = 128,
    this.heroTag,
    this.onImageLoaded,
  });

  @override
  State<ArtistAvatar> createState() => _ArtistAvatarState();
}

class _ArtistAvatarState extends State<ArtistAvatar> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() {
    final provider = context.read<MusicAssistantProvider>();
    final maUrl = provider.getImageUrl(widget.artist, size: widget.imageSize);
    if (maUrl != null) {
      _imageUrl = maUrl;
      widget.onImageLoaded?.call(maUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget avatarContent;
    if (_imageUrl != null) {
      avatarContent = ClipOval(
        child: CachedNetworkImage(
          imageUrl: _imageUrl!,
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
          errorWidget: (context, url, error) => Container(
            color: colorScheme.surfaceVariant,
            child: Icon(Icons.person_rounded, color: colorScheme.onSurfaceVariant),
          ),
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
