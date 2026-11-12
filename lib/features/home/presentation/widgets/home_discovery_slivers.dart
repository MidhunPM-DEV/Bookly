import 'package:bookly/features/favorites/favorites_store.dart';
import 'package:bookly/features/home/data/models/home_models.dart';
import 'package:bookly/features/home/presentation/widgets/category_chips.dart';
import 'package:bookly/features/home/presentation/widgets/home_spotlight_card.dart';
import 'package:bookly/features/home/presentation/widgets/nearby_salon_card.dart';
import 'package:bookly/features/home/presentation/widgets/popular_place_card.dart';
import 'package:bookly/features/home/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';

List<Widget> buildHomeDiscoverySlivers({
  required int selectedCategory,
  required ValueChanged<int> onCategorySelected,
  required VoidCallback onExploreNearby,
  required VoidCallback onExplorePopular,
  required ValueChanged<String> onPlaceTap,
  required VoidCallback onSeeAllNearby,
}) {
  final nearby = HomeMockData.nearby;
  final favorites = FavoritesStore.instance;

  return [
    const SliverToBoxAdapter(child: SizedBox(height: 12)),
    SliverToBoxAdapter(
      child: HomeSpotlightCard(onExplore: onExploreNearby),
    ),
    const SliverToBoxAdapter(child: SizedBox(height: 24)),
    SliverToBoxAdapter(
      child: CategoryChips(
        categories: HomeMockData.categories,
        selectedIndex: selectedCategory,
        onSelected: onCategorySelected,
      ),
    ),
    const SliverToBoxAdapter(child: SizedBox(height: 28)),
    SliverToBoxAdapter(
      child: SectionHeader(
        title: 'Nearby services',
        action: 'See all',
        onAction: onSeeAllNearby,
      ),
    ),
    const SliverToBoxAdapter(child: SizedBox(height: 12)),
    SliverToBoxAdapter(
      child: NearbySalonCard(
        salon: nearby,
        isFavorite: favorites.contains(nearby.id),
        onFavorite: () => favorites.toggle(nearby.id),
        onView: () => onPlaceTap(nearby.id),
      ),
    ),
    const SliverToBoxAdapter(child: SizedBox(height: 30)),
    SliverToBoxAdapter(
      child: SectionHeader(
        title: 'Recommended for you',
        action: 'Explore',
        onAction: onExplorePopular,
      ),
    ),
    const SliverToBoxAdapter(child: SizedBox(height: 12)),
    SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final place = HomeMockData.popular[index];
        return Padding(
          padding: EdgeInsets.fromLTRB(20, index == 0 ? 0 : 12, 20, 0),
          child: PopularPlaceCard(
            place: place,
            width: double.infinity,
            onTap: () => onPlaceTap(place.id),
            isFavorite: favorites.contains(place.id),
            onFavorite: () => favorites.toggle(place.id),
          ),
        );
      }, childCount: HomeMockData.popular.length),
    ),
    const SliverToBoxAdapter(child: SizedBox(height: 28)),
  ];
}
