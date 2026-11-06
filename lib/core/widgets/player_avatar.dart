import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../entities/enums.dart';
import '../theme/colors.dart';

/// Circular player photo with an initial-letter fallback and tier ring.
class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    super.key,
    required this.name,
    this.photoUrl,
    this.tier,
    this.size = 48,
  });

  final String name;
  final String? photoUrl;
  final Tier? tier;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ring = tier == null ? scheme.outlineVariant : AppColors.tier(tier!);
    final initial = name.isEmpty ? '?' : name.characters.first;
    final fallback = Center(
      child: Text(
        initial,
        style: TextStyle(fontSize: size * 0.4, fontWeight: FontWeight.w800),
      ),
    );
    final url = photoUrl;
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(shape: BoxShape.circle, color: ring),
      child: ClipOval(
        child: ColoredBox(
          color: scheme.surfaceContainerHighest,
          child: url == null
              ? fallback
              : CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => fallback,
                  errorWidget: (_, _, _) => fallback,
                ),
        ),
      ),
    );
  }
}
