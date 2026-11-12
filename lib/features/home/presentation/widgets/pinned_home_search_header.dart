import 'package:bookly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PinnedHomeSearchHeader extends StatelessWidget {
  const PinnedHomeSearchHeader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _PinnedHomeSearchHeaderDelegate(child: child),
    );
  }
}

class _PinnedHomeSearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _PinnedHomeSearchHeaderDelegate({required this.child});

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
  bool shouldRebuild(covariant _PinnedHomeSearchHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
