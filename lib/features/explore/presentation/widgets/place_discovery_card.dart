import 'package:bookly/core/theme/app_colors.dart';
import 'package:bookly/features/home/data/models/home_models.dart';
import 'package:flutter/material.dart';

class PlaceDiscoveryCard extends StatefulWidget {
  const PlaceDiscoveryCard({
    super.key,
    required this.place,
    this.onTap,
    this.isFavorite = false,
    this.onFavorite,
  });

  final PopularPlace place;
  final VoidCallback? onTap;
  final bool isFavorite;
  final VoidCallback? onFavorite;

  @override
  State<PlaceDiscoveryCard> createState() => _PlaceDiscoveryCardState();
}

class _PlaceDiscoveryCardState extends State<PlaceDiscoveryCard> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed != value) {
      setState(() => _isPressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;
    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    children: [
                      Positioned.fill(child: _PlaceImage(place.imageUrl)),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: widget.onFavorite,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.88),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                widget.isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 18,
                                color: widget.isFavorite
                                    ? Colors.red.shade400
                                    : AppColors.ink,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(13, 12, 13, 12),
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
                        const SizedBox(height: 4),
                        Text(
                          '${place.category} · ${place.subtitle}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.mutedDark,
                            fontSize: 11.5,
                            height: 1.25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 15,
                              color: Color(0xFFF5C518),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${place.rating} (${place.reviewCountLabel})',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppColors.muted,
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              child: Text(
                                place.distanceLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.mutedDark,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _AvailabilityBadge(isOpen: place.slotsOpen),
                            const Spacer(),
                            Text(
                              '₹${place.startingPrice}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Services from ₹${place.startingPrice}',
                                  style: const TextStyle(
                                    color: AppColors.mutedDark,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'View details',
                                  style: TextStyle(
                                    color: AppColors.ink,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 13,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.isOpen});

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final color = isOpen ? AppColors.openGreen : AppColors.mutedDark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: isOpen ? const Color(0xFFE9F6EE) : AppColors.searchFill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isOpen ? 'Open now' : 'Closed',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _PlaceImage extends StatelessWidget {
  const _PlaceImage(this.imageUrl);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const _ImagePlaceholder(),
      loadingBuilder: (context, child, progress) {
        return progress == null ? child : const _ImagePlaceholder();
      },
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFFEDEAE5),
      child: Center(
        child: Icon(
          Icons.storefront_outlined,
          color: AppColors.muted,
          size: 30,
        ),
      ),
    );
  }
}
