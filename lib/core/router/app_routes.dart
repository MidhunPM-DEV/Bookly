abstract final class AppRoutes {
  static const home = '/home';
  static const explore = '/explore';
  static const bookings = '/bookings';
  static const favorites = '/favorites';
  static const profile = '/profile';
  static const login = '/login';
  static const createAccount = '/create-account';

  static String business(String id) => '/business/$id';
}
