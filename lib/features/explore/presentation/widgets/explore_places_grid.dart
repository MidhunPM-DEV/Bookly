import 'package:bookly/features/home/data/models/home_models.dart';
import 'package:bookly/features/explore/presentation/widgets/place_discovery_card.dart';
import 'package:flutter/material.dart';

class ExplorePlacesGrid extends StatelessWidget {
  const ExplorePlacesGrid({
    super.key,
    required this.places,
    required this.onPlaceTap,
    required this.isFavorite,
    required this.onFavorite,
  });

  final List<PopularPlace> places;
  final ValueChanged<PopularPlace> onPlaceTap;
  final bool Function(PopularPlace) isFavorite;
  final ValueChanged<PopularPlace> onFavorite;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final place = places[index];
          return PlaceDiscoveryCard(
            place: place,
            onTap: () => onPlaceTap(place),
            isFavorite: isFavorite(place),
            onFavorite: () => onFavorite(place),
          );
        }, childCount: places.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          mainAxisExtent: 320,
        ),
      ),
    );
  }
}
