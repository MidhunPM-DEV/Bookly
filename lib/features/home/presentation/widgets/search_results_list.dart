import 'package:bookly/core/theme/app_colors.dart';
import 'package:bookly/features/home/data/models/home_models.dart';
import 'package:bookly/features/home/presentation/widgets/remote_image.dart';
import 'package:flutter/material.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({
    super.key,
    required this.query,
    required this.results,
    required this.onPlaceTap,
  });

  final String query;
  final List<PopularPlace> results;
  final ValueChanged<PopularPlace> onPlaceTap;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded, size: 40, color: AppColors.muted),
            const SizedBox(height: 12),
            Text(
              query.isEmpty ? 'No places match these filters' : 'No results for “$query”',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try another name, category, or clear filters.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.mutedDark, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Text(
            '${results.length} ${results.length == 1 ? 'place' : 'places'} found',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.mutedDark,
            ),
          ),
        ),
        ...results.map(
          (place) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: _SearchResultTile(
              place: place,
              onTap: () => onPlaceTap(place),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.place, required this.onTap});

  final PopularPlace place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: RemoteImage(url: place.imageUrl),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${place.category} · ${place.distanceLabel}',
                      style: const TextStyle(
                        color: AppColors.mutedDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF5C518)),
                        const SizedBox(width: 2),
                        Text(
                          '${place.rating}',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
                        ),
                        const Spacer(),
                        Text(
                          'From ₹${place.startingPrice}',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
