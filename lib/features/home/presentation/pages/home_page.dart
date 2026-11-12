import 'package:bookly/core/theme/app_colors.dart';
import 'package:bookly/core/router/app_routes.dart';
import 'package:bookly/features/auth/auth_store.dart';
import 'package:bookly/features/home/data/models/home_models.dart';
import 'package:bookly/features/favorites/favorites_store.dart';
import 'package:bookly/features/home/presentation/widgets/home_discovery_slivers.dart';
import 'package:bookly/features/home/presentation/widgets/home_header.dart';
import 'package:bookly/features/home/presentation/widgets/home_search_bar.dart';
import 'package:bookly/features/home/presentation/widgets/pinned_home_search_header.dart';
import 'package:bookly/features/home/presentation/widgets/search_filter_sheet.dart';
import 'package:bookly/features/home/presentation/widgets/search_results_list.dart';
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
    if (hour < 16) return 'Good afternoon';
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
                PinnedHomeSearchHeader(
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
                if (_isSearching)
                  SliverToBoxAdapter(
                    child: SearchResultsList(
                      query: _query.trim(),
                      results: _results,
                      onPlaceTap: (place) => _openBusiness(place.id),
                    ),
                  )
                else
                  ...buildHomeDiscoverySlivers(
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (index) =>
                        setState(() => _selectedCategory = index),
                    onExploreNearby: () =>
                        _openBusiness(HomeMockData.nearby.id),
                    onExplorePopular: () => _snack('Explore popular'),
                    onPlaceTap: _openBusiness,
                    onSeeAllNearby: () => _snack('See all nearby'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
