import 'package:bookly/core/theme/app_colors.dart';
import 'package:bookly/features/home/data/models/home_models.dart';
import 'package:bookly/features/home/presentation/widgets/remote_image.dart';
import 'package:flutter/material.dart';

class ExplorePlaceCard extends StatelessWidget {
  const ExplorePlaceCard({
    super.key,
    required this.place,
    required this.isFavorite,
    required this.onFavorite,
    this.onTap,
  });

  final PopularPlace place;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 204,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox.expand(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      RemoteImage(url: place.imageUrl),
                      Positioned(
                        left: 8,
                        top: 8,
                        child: _ImageBadge(
                          icon: Icons.near_me_rounded,
                          label: place.distanceLabel,
                        ),
                      ),
                      if (place.verified)
                        const Positioned(
                          right: 8,
                          top: 8,
                          child: _ImageBadge(
                            icon: Icons.verified_rounded,
                            label: 'VERIFIED',
                            verified: true,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: onFavorite,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFE7E3DE)),
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 18,
                          color: isFavorite ? Colors.red : AppColors.ink,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    top: 38,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          place.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.mutedDark,
                            fontSize: 12,
                            height: 1.15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 17,
                              color: Color(0xFFF5A900),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${place.rating}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                ' (${place.reviewCountLabel})',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.mutedDark,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (place.nextAvailable != null || place.slotsOpen) ...[
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F5F0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.schedule_rounded,
                                  size: 14,
                                  color: AppColors.accentGreen,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    place.nextAvailable ?? 'Slots available',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      height: 1.1,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'From',
                                    style: TextStyle(
                                      color: AppColors.mutedDark,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    '₹${place.startingPrice}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      height: 1,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.openGreen,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'View',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 13,
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }
}

class _ImageBadge extends StatelessWidget {
  const _ImageBadge({
    required this.icon,
    required this.label,
    this.verified = false,
  });

  final IconData icon;
  final String label;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: verified
            ? const Color(0xE6111111)
            : Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: verified ? AppColors.lime : Colors.white),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
