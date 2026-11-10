import 'package:bookly/features/explore/presentation/widgets/explore_place_card.dart';
import 'package:bookly/features/favorites/favorites_store.dart';
import 'package:bookly/features/home/data/models/home_models.dart';
import 'package:flutter/material.dart';

class ExplorePlacesList extends StatelessWidget {
  const ExplorePlacesList({
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
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final place = places[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AnimatedBuilder(
              animation: FavoritesStore.instance,
              builder: (context, _) => ExplorePlaceCard(
                place: place,
                onTap: () => onPlaceTap(place),
                isFavorite: isFavorite(place),
                onFavorite: () => onFavorite(place),
              ),
            ),
          );
        }, childCount: places.length),
      ),
    );
  }
}
