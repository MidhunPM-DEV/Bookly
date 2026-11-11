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
    const heroHeight = 172.0;
    const surfaceColor = Color(0xFFFFFEFC);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A111111),
              blurRadius: 22,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: heroHeight,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        RemoteImage(url: place.imageUrl),
                        Positioned(
                          top: 14,
                          left: 14,
                          child: _OverlayPill(
                            background: const Color(0xD9000000),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${place.distanceLabel} · ${place.category}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Material(
                            color: Colors.white.withValues(alpha: 0.96),
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: onFavorite,
                              child: SizedBox(
                                width: 42,
                                height: 42,
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: isFavorite
                                      ? Colors.red.shade400
                                      : AppColors.ink,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 14,
                          bottom: 20,
                          child: _OverlayPill(
                            background: const Color(0xFFFDFCF8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFFFB928),
                                  size: 19,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  '${place.rating}',
                                  style: const TextStyle(
                                    color: AppColors.ink,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomPaint(
                    painter: _CardSurfacePainter(surfaceColor),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 25, 16, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 24,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            place.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.mutedDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 7,
                            runSpacing: 7,
                            children: place.tags.take(3).map((tag) {
                              return _ServiceChip(tag: tag);
                            }).toList(),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'SERVICES FROM',
                                      style: TextStyle(
                                        color: AppColors.mutedDark,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Text(
                                      '₹${place.startingPrice}',
                                      style: const TextStyle(
                                        color: Color(0xFF0C3518),
                                        fontSize: 30,
                                        height: 1.05,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 1,
                                height: 42,
                                color: const Color(0xFFDCDCD5),
                              ),
                              const SizedBox(width: 12),
                              FilledButton.icon(
                                onPressed: onTap,
                                icon: const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 18,
                                ),
                                label: const Text('View details'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF0B3417),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 14,
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: heroHeight - 34,
                left: 0,
                right: 0,
                height: 52,
                child: IgnorePointer(
                  child: CustomPaint(painter: _CardWavePainter(surfaceColor)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverlayPill extends StatelessWidget {
  const _OverlayPill({required this.background, required this.child});

  final Color background;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    final label = tag.isEmpty
        ? tag
        : '${tag[0].toUpperCase()}${tag.substring(1)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EFCF),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_iconFor(tag), size: 17, color: const Color(0xFF12381B)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF12381B),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String value) {
    return switch (value.toLowerCase()) {
      'spa' => Icons.spa_outlined,
      'massage' => Icons.self_improvement_rounded,
      'aromatherapy' => Icons.eco_outlined,
      'barber' || 'haircut' || 'hair' => Icons.content_cut_rounded,
      'beard' => Icons.face_retouching_natural_rounded,
      'fade' => Icons.person_outline_rounded,
      _ => Icons.spa_outlined,
    };
  }
}

class _CardSurfacePainter extends CustomPainter {
  const _CardSurfacePainter(this.surfaceColor);

  final Color surfaceColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(surfaceColor, BlendMode.src);

    final accentPaint = Paint()..color = const Color(0xFFEAF0D8);
    final leftAccent = Path()
      ..moveTo(0, 12)
      ..cubicTo(
        size.width * 0.13,
        0,
        size.width * 0.2,
        18,
        size.width * 0.3,
        26,
      )
      ..cubicTo(size.width * 0.18, 38, size.width * 0.08, 52, 0, 78)
      ..close();
    canvas.drawPath(leftAccent, accentPaint);

    final rightAccent = Path()
      ..moveTo(size.width, 22)
      ..cubicTo(size.width * 0.83, 40, size.width * 0.88, 55, size.width, 74)
      ..close();
    canvas.drawPath(rightAccent, accentPaint);

    final bottomAccent = Path()
      ..moveTo(size.width * 0.36, size.height)
      ..cubicTo(
        size.width * 0.49,
        size.height - 24,
        size.width * 0.59,
        size.height + 5,
        size.width * 0.74,
        size.height,
      )
      ..close();
    canvas.drawPath(bottomAccent, accentPaint);
  }

  @override
  bool shouldRepaint(covariant _CardSurfacePainter oldDelegate) {
    return oldDelegate.surfaceColor != surfaceColor;
  }
}

class _CardWavePainter extends CustomPainter {
  const _CardWavePainter(this.surfaceColor);

  final Color surfaceColor;

  @override
  void paint(Canvas canvas, Size size) {
    final wave = Path()
      ..moveTo(0, 12)
      ..cubicTo(
        size.width * 0.18,
        -3,
        size.width * 0.24,
        15,
        size.width * 0.46,
        27,
      )
      ..cubicTo(size.width * 0.71, 42, size.width * 0.84, 10, size.width, 22)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(wave, Paint()..color = surfaceColor);

    final accent = Path()
      ..moveTo(0, 12)
      ..cubicTo(
        size.width * 0.18,
        -3,
        size.width * 0.24,
        15,
        size.width * 0.46,
        27,
      )
      ..cubicTo(size.width * 0.68, 40, size.width * 0.84, 10, size.width, 22)
      ..lineTo(size.width, 30)
      ..cubicTo(
        size.width * 0.82,
        19,
        size.width * 0.7,
        48,
        size.width * 0.46,
        35,
      )
      ..cubicTo(size.width * 0.24, 23, size.width * 0.16, 5, 0, 22)
      ..close();
    canvas.drawPath(accent, Paint()..color = const Color(0xFFDDE8C7));
  }

  @override
  bool shouldRepaint(covariant _CardWavePainter oldDelegate) {
    return oldDelegate.surfaceColor != surfaceColor;
  }
}
