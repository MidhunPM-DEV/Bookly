import 'package:bookly/core/router/app_routes.dart';
import 'package:bookly/core/theme/app_colors.dart';
import 'package:bookly/features/home/data/models/home_models.dart';
import 'package:bookly/features/favorites/favorites_store.dart';
import 'package:bookly/features/home/presentation/widgets/popular_place_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _searchController = TextEditingController();
  int _selectedCategory = 0;

  static const _categories = [
    'All',
    'Salon',
    'Barber',
    'Fitness',
    'Clinic',
    'Spa',
  ];

  List<PopularPlace> get _places {
    final query = _searchController.text.trim().toLowerCase();
    final category = _categories[_selectedCategory];
    return HomeMockData.catalog.where((place) {
      final matchesCategory = category == 'All' || place.category == category;
      final matchesQuery =
          query.isEmpty ||
          '${place.name} ${place.subtitle} ${place.category} ${place.tags.join(' ')}'
              .toLowerCase()
              .contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
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
              child: _ExploreHeader(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final selected = index == _selectedCategory;
                    return ChoiceChip(
                      label: Text(_categories[index]),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = index),
                      selectedColor: AppColors.ink,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                      side: BorderSide(
                        color: selected ? AppColors.ink : AppColors.chipOutline,
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                child: Row(
                  children: [
                    const Text(
                      'Discover places',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${places.length} found',
                      style: const TextStyle(
                        color: AppColors.mutedDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
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
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final place = places[index];
                    return PopularPlaceCard(
                      place: place,
                      width: double.infinity,
                      onTap: () => context.push(AppRoutes.business(place.id)),
                      isFavorite: FavoritesStore.instance.contains(place.id),
                      onFavorite: () =>
                          FavoritesStore.instance.toggle(place.id),
                    );
                  }, childCount: places.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 310,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ExploreHeader extends StatelessWidget {
  const _ExploreHeader({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Explore',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            'Find your next favorite place',
            style: TextStyle(
              color: AppColors.mutedDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Search salons, gyms, clinics...',
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.muted,
              ),
              filled: true,
              fillColor: AppColors.searchFill,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Color(0xFFE7E3DE)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Color(0xFFE7E3DE)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
