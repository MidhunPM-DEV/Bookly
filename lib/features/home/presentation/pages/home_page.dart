import 'package:bookly/core/theme/app_colors.dart';
import 'package:bookly/core/router/app_routes.dart';
import 'package:bookly/features/home/data/models/home_models.dart';
import 'package:bookly/features/favorites/favorites_store.dart';
import 'package:bookly/features/home/presentation/widgets/book_again_card.dart';
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

  int _selectedCategory = 0;
  String _query = '';
  SearchFilters _filters = const SearchFilters();

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
    return 'Good evening';
  }

  @override
  void dispose() {
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
            animation: FavoritesStore.instance,
            builder: (context, _) => CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: HomeHeader(
                    dateLabel: _dateLabel,
                    greeting: _greeting,
                    userName: HomeMockData.userName,
                    location: HomeMockData.location,
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
                  SliverToBoxAdapter(
                    child: CategoryChips(
                      categories: HomeMockData.categories,
                      selectedIndex: _selectedCategory,
                      onSelected: (index) =>
                          setState(() => _selectedCategory = index),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 22)),
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Nearby',
                      action: 'See all (18)',
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
                  const SliverToBoxAdapter(child: SizedBox(height: 26)),
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
                  const SliverToBoxAdapter(child: SizedBox(height: 26)),
                  SliverToBoxAdapter(
                    child: BookAgainCard(
                      visit: HomeMockData.recentVisit,
                      onRebook: () =>
                          _openBusiness(HomeMockData.recentVisit.businessId),
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
