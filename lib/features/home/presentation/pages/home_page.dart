import 'dart:async';

import 'package:bookly/core/theme/app_colors.dart';
import 'package:bookly/core/router/app_routes.dart';
import 'package:bookly/features/auth/auth_store.dart';
import 'package:bookly/features/home/data/models/home_models.dart';
import 'package:bookly/features/favorites/favorites_store.dart';
import 'package:bookly/features/home/presentation/widgets/category_chips.dart';
import 'package:bookly/features/home/presentation/widgets/home_header.dart';
import 'package:bookly/features/home/presentation/widgets/home_search_bar.dart';
import 'package:bookly/features/home/presentation/widgets/nearby_salon_card.dart';
import 'package:bookly/features/home/presentation/widgets/popular_place_card.dart';
import 'package:bookly/features/home/presentation/widgets/search_filter_sheet.dart';
import 'package:bookly/features/home/presentation/widgets/search_results_list.dart';
import 'package:bookly/features/home/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  Timer? _clockTimer;

  int _selectedCategory = 0;
  String _query = '';
  SearchFilters _filters = const SearchFilters();

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  bool get _isSearching => _query.trim().isNotEmpty || _filters.isActive;

  List<PopularPlace> get _results => HomeMockData.search(
    query: _query,
    categories: _filters.categories,
    slotsOpenOnly: _filters.slotsOpenOnly,
  );

  String get _dateLabel {
    return DateFormat('EEEE, MMM d').format(DateTime.now()).toUpperCase();
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    if (hour < 21) return 'Good evening';
    return 'Good night';
  }

  String get _displayName {
    final name = AuthStore.instance.userName?.trim();
    if (name == null || name.isEmpty) return 'there';
    return name.split(RegExp(r'\s+')).first;
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _onQueryChanged(String value) {
    setState(() => _query = value);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
    _searchFocus.requestFocus();
  }

  void _openBusiness(String businessId) {
    context.push(AppRoutes.business(businessId));
  }

  Future<void> _openFilters() async {
    final next = await showSearchFilterSheet(context, current: _filters);
    if (next == null || !mounted) return;
    setState(() => _filters = next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: AnimatedBuilder(
            animation: Listenable.merge([
              FavoritesStore.instance,
              AuthStore.instance,
            ]),
            builder: (context, _) => CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: HomeHeader(
                    dateLabel: _dateLabel,
                    greeting: _greeting,
                    userName: _displayName,
                    location: 'Location not set',
                    onChangeLocation: () => _snack('Change location'),
                    onNotifications: () => _snack('Notifications'),
                    onProfile: () => _snack('Profile'),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _PinnedSearchHeaderDelegate(
                    child: HomeSearchBar(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      filterActive: _filters.isActive,
                      onChanged: _onQueryChanged,
                      onSubmitted: _onQueryChanged,
                      onClear: _clearSearch,
                      onFilter: _openFilters,
                    ),
                  ),
                ),
                if (_isSearching)
                  SliverToBoxAdapter(
                    child: SearchResultsList(
                      query: _query.trim(),
                      results: _results,
                      onPlaceTap: (place) => _openBusiness(place.id),
                    ),
                  )
                else ...[
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  SliverToBoxAdapter(
                    child: _HomeSpotlightCard(
                      onExplore: () => _openBusiness(HomeMockData.nearby.id),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverToBoxAdapter(
                    child: CategoryChips(
                      categories: HomeMockData.categories,
                      selectedIndex: _selectedCategory,
                      onSelected: (index) =>
                          setState(() => _selectedCategory = index),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 28)),
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Nearby',
                      action: 'See all (${HomeMockData.catalog.length})',
                      onAction: () => _snack('See all nearby'),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  SliverToBoxAdapter(
                    child: NearbySalonCard(
                      salon: HomeMockData.nearby,
                      isFavorite: FavoritesStore.instance.contains(
                        HomeMockData.nearby.id,
                      ),
                      onFavorite: () => FavoritesStore.instance.toggle(
                        HomeMockData.nearby.id,
                      ),
                      onView: () => _openBusiness(HomeMockData.nearby.id),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 30)),
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Popular near you',
                      action: 'Explore',
                      onAction: () => _snack('Explore popular'),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 236,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: HomeMockData.popular.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final place = HomeMockData.popular[index];
                          return PopularPlaceCard(
                            place: place,
                            width: index == 0 ? 248 : 210,
                            onTap: () => _openBusiness(place.id),
                            isFavorite: FavoritesStore.instance.contains(
                              place.id,
                            ),
                            onFavorite: () =>
                                FavoritesStore.instance.toggle(place.id),
                          );
                        },
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 28)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeSpotlightCard extends StatelessWidget {
  const _HomeSpotlightCard({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(20, 18, 14, 14),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A111111),
            blurRadius: 18,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -34,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.lime.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 42,
            bottom: -62,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.lime.withValues(alpha: 0.12),
                  width: 18,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lime,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'BOOK YOUR MOMENT',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: AppColors.lime,
                    size: 22,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const SizedBox(
                width: 250,
                child: Text(
                  'Your next good moment starts here.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    height: 1.16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Find trusted places around you and book with confidence.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onExplore,
                icon: const Icon(Icons.explore_outlined, size: 17),
                label: const Text('Explore places'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.ink,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PinnedSearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _PinnedSearchHeaderDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 76;

  @override
  double get maxExtent => 76;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(color: AppColors.background, child: child);
  }

  @override
  bool shouldRebuild(covariant _PinnedSearchHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
