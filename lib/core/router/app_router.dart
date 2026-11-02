import 'package:bookly/core/router/app_routes.dart';
import 'package:bookly/features/bookings/presentation/pages/bookings_page.dart';
import 'package:bookly/features/business/presentation/pages/business_details_page.dart';
import 'package:bookly/features/auth/auth_store.dart';
import 'package:bookly/features/auth/presentation/pages/login_page.dart';
import 'package:bookly/features/auth/presentation/pages/create_account_page.dart';
import 'package:bookly/features/explore/presentation/pages/explore_page.dart';
import 'package:bookly/features/favorites/presentation/pages/favorites_page.dart';
import 'package:bookly/features/home/presentation/pages/home_page.dart';
import 'package:bookly/features/home/presentation/pages/main_shell.dart';
import 'package:bookly/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

abstract final class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    refreshListenable: AuthStore.instance,
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final isLogin = state.matchedLocation == AppRoutes.login;
      final isCreateAccount = state.matchedLocation == AppRoutes.createAccount;
      if (!AuthStore.instance.isSignedIn && !isLogin && !isCreateAccount) {
        return AppRoutes.login;
      }
      if (AuthStore.instance.isSignedIn && isLogin) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.createAccount,
        builder: (context, state) => const CreateAccountPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.explore,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ExplorePage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.bookings,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: BookingsPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favorites,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: FavoritesPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ProfilePage()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/business/:id',
        builder: (context, state) {
          return BusinessDetailsPage(businessId: state.pathParameters['id']!);
        },
      ),
    ],
  );
}
