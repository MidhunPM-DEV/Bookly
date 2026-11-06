import 'package:bookly/core/theme/app_colors.dart';
import 'package:bookly/features/home/data/models/home_models.dart';
import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<HomeCategory> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 10),
          child: Row(
            children: [
              Text(
                'EXPLORE SERVICES',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.muted,
                ),
              ),
              Spacer(),
              Text(
                'Swipe to explore',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 42,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final category = categories[index];
              final selected = index == selectedIndex;
              return GestureDetector(
                onTap: () => onSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.ink : AppColors.limeSoft,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: selected ? AppColors.ink : AppColors.limeSoft,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _categoryIcon(category.label),
                        size: 16,
                        color: selected ? Colors.white : AppColors.ink,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        _categoryLabel(category.label),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: selected ? Colors.white : AppColors.ink,
                        ),
                      ),
                      if (category.dot) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.lime,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _categoryIcon(String label) {
    switch (label) {
      case 'Clinics':
        return Icons.local_hospital_outlined;
      case 'Salons':
        return Icons.content_cut_rounded;
      case 'Spa':
        return Icons.spa_outlined;
      default:
        return Icons.auto_awesome_outlined;
    }
  }

  String _categoryLabel(String label) => label == 'Fitness' ? 'Style' : label;
}
