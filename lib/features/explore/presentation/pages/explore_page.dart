import 'package:bookly/core/router/app_routes.dart';
import 'package:bookly/core/theme/app_colors.dart';
import 'package:bookly/features/home/data/models/home_models.dart';
import 'package:bookly/features/favorites/favorites_store.dart';
import 'package:bookly/features/explore/presentation/widgets/explore_category_filter.dart';
import 'package:bookly/features/explore/presentation/widgets/explore_header.dart';
import 'package:bookly/features/explore/presentation/widgets/explore_results_header.dart';
import 'package:bookly/features/explore/presentation/widgets/explore_places_grid.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _searchController = TextEditingController();
  ExploreCategory _selectedCategory = ExploreCategory.all;

  List<PopularPlace> get _places {
    return HomeMockData.search(
      query: _searchController.text,
      categories: _selectedCategory.filterValues,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final places = _places;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ExploreHeader(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
              ),
            ),
            SliverToBoxAdapter(
              child: ExploreCategoryFilter(
                selectedCategory: _selectedCategory,
                onSelected: (category) =>
                    setState(() => _selectedCategory = category),
              ),
            ),
            SliverToBoxAdapter(
              child: ExploreResultsHeader(resultCount: places.length),
            ),
            if (places.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'No places match your search',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              )
            else
              ExplorePlacesGrid(
                places: places,
                onPlaceTap: (place) =>
                    context.push(AppRoutes.business(place.id)),
                isFavorite: (place) =>
                    FavoritesStore.instance.contains(place.id),
                onFavorite: (place) => FavoritesStore.instance.toggle(place.id),
              ),
          ],
        ),
      ),
    );
  }
}
