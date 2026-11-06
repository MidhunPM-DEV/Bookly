import 'package:bookly/core/theme/app_colors.dart';
import 'package:bookly/features/home/data/models/home_models.dart';
import 'package:bookly/features/home/presentation/widgets/remote_image.dart';
import 'package:flutter/material.dart';

class PopularPlaceCard extends StatelessWidget {
  const PopularPlaceCard({
    super.key,
    required this.place,
    this.width = 230,
    this.onTap,
    this.isFavorite = false,
    this.onFavorite,
  });

  final PopularPlace place;
  final double width;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D063D2E),
              blurRadius: 16,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: SizedBox(
                height: 174,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    RemoteImage(url: place.imageUrl),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xB3000000)],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${place.distanceLabel} · ${place.category}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 10,
                      child: GestureDetector(
                        onTap: onFavorite,
                        child: CircleAvatar(
                          radius: 17,
                          backgroundColor: Colors.white.withValues(alpha: 0.94),
                          child: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFavorite ? Colors.red : AppColors.ink,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 12,
                      child: _RatingPill(rating: place.rating),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    place.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.mutedDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: place.tags.take(3).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.limeSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _prettyTag(tag),
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SERVICES FROM',
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.7,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '₹${place.startingPrice}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 19,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      FilledButton.icon(
                        onPressed: onTap,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                        label: const Text('View details'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.ink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _prettyTag(String tag) {
    if (tag.isEmpty) return tag;
    return '${tag[0].toUpperCase()}${tag.substring(1)}';
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF5C518)),
          const SizedBox(width: 3),
          Text(
            '$rating',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
