import 'package:bookly/core/router/app_routes.dart';
import 'package:bookly/core/theme/app_colors.dart';
import 'package:bookly/features/auth/auth_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _notifications = true;
  bool _location = true;

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            Row(
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _message('Settings saved automatically'),
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: 'Settings',
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 34,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80',
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alex Johnson',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'alex.johnson@email.com',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Edit profile  →',
                          style: TextStyle(
                            color: AppColors.lime,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.verified_rounded, color: AppColors.lime),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'YOUR ACTIVITY',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 11,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _StatCard(
                  icon: Icons.calendar_month_outlined,
                  value: '12',
                  label: 'Bookings',
                ),
                const SizedBox(width: 10),
                _StatCard(
                  icon: Icons.favorite_border_rounded,
                  value: '3',
                  label: 'Favorites',
                ),
                const SizedBox(width: 10),
                _StatCard(
                  icon: Icons.star_outline_rounded,
                  value: '4.9',
                  label: 'Rating',
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'ACCOUNT',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 11,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            _ProfileSection(
              children: [
                _ProfileTile(
                  icon: Icons.calendar_month_outlined,
                  title: 'My bookings',
                  subtitle: 'View your upcoming appointments',
                  onTap: () => context.go(AppRoutes.bookings),
                ),
                _ProfileTile(
                  icon: Icons.favorite_border_rounded,
                  title: 'Saved places',
                  subtitle: 'Manage your favorite businesses',
                  onTap: () => context.go(AppRoutes.favorites),
                ),
                _ProfileTile(
                  icon: Icons.location_on_outlined,
                  title: 'Kozhikode, Kerala',
                  subtitle: 'Your preferred location',
                  onTap: () => _message('Location picker coming soon'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'PREFERENCES',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 11,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            _ProfileSection(
              children: [
                _ProfileTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  subtitle: 'Booking reminders and updates',
                  trailing: Switch.adaptive(
                    value: _notifications,
                    activeThumbColor: AppColors.accentGreen,
                    onChanged: (value) =>
                        setState(() => _notifications = value),
                  ),
                ),
                _ProfileTile(
                  icon: Icons.my_location_rounded,
                  title: 'Use current location',
                  subtitle: 'Show places near you',
                  trailing: Switch.adaptive(
                    value: _location,
                    activeThumbColor: AppColors.accentGreen,
                    onChanged: (value) => setState(() => _location = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _ProfileSection(
              children: [
                _ProfileTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & support',
                  onTap: () =>
                      _message('Support is available from 9 AM to 6 PM'),
                ),
                _ProfileTile(
                  icon: Icons.logout_rounded,
                  title: 'Sign out',
                  titleColor: Colors.red,
                  onTap: () {
                    AuthStore.instance.signOut();
                    context.go(AppRoutes.login);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.accentGreen),
            const SizedBox(height: 7),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.mutedDark,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: titleColor ?? AppColors.ink),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w800, color: titleColor),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: const TextStyle(fontSize: 11, color: AppColors.mutedDark),
            ),
      trailing:
          trailing ??
          (onTap == null
              ? null
              : const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.muted,
                )),
    );
  }
}
