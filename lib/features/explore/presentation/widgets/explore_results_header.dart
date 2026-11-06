import 'package:bookly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ExploreResultsHeader extends StatelessWidget {
  const ExploreResultsHeader({super.key, required this.resultCount});

  final int resultCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Row(
        children: [
          const Text(
            'Discover places',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const Spacer(),
          Text(
            '$resultCount found',
            style: const TextStyle(
              color: AppColors.mutedDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
