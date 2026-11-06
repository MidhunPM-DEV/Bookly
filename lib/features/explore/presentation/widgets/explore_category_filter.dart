import 'package:bookly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum ExploreCategory {
  all('All'),
  salon('Salon'),
  barber('Barber'),
  fitness('Fitness'),
  clinic('Clinic'),
  spa('Spa');

  const ExploreCategory(this.label);

  final String label;

  Set<String> get filterValues =>
      this == ExploreCategory.all ? const {} : {label};
}

class ExploreCategoryFilter extends StatelessWidget {
  const ExploreCategoryFilter({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  final ExploreCategory selectedCategory;
  final ValueChanged<ExploreCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: ExploreCategory.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = ExploreCategory.values[index];
          final selected = category == selectedCategory;
          return ChoiceChip(
            label: Text(category.label),
            selected: selected,
            onSelected: (_) => onSelected(category),
            selectedColor: AppColors.ink,
            labelStyle: TextStyle(
              color: selected ? Colors.white : AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
            side: BorderSide(
              color: selected ? AppColors.ink : AppColors.chipOutline,
            ),
          );
        },
      ),
    );
  }
}
