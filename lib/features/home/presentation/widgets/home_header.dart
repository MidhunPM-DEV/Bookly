import 'package:bookly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.dateLabel,
    required this.greeting,
    required this.userName,
    required this.location,
    this.onChangeLocation,
    this.onNotifications,
    this.onProfile,
  });

  final String dateLabel;
  final String greeting;
  final String userName;
  final String location;
  final VoidCallback? onChangeLocation;
  final VoidCallback? onNotifications;
  final VoidCallback? onProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Bookly',
                style: TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onNotifications,
                tooltip: 'Notifications',
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: Color(0xFFE2EAE5)),
                ),
                icon: Badge(
                  smallSize: 7,
                  backgroundColor: AppColors.openGreen,
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onProfile,
                child: CircleAvatar(
                  radius: 19,
                  backgroundColor: AppColors.limeSoft,
                  foregroundColor: AppColors.ink,
                  child: Text(
                    _initials(userName),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting, $userName',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, size: 18, color: AppColors.ink),
              const SizedBox(width: 4),
              Expanded(
                child: GestureDetector(
                  onTap: onChangeLocation,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          location,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: AppColors.ink,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
