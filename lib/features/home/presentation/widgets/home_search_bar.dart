import 'package:bookly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onFilter,
    this.onClear,
    this.filterActive = false,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilter;
  final VoidCallback? onClear;
  final bool filterActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Container(
        height: 52,
        padding: const EdgeInsets.only(left: 16, right: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE7E3DE)),
        ),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: AppColors.muted),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                textInputAction: TextInputAction.search,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Search clinics, salons...',
                  hintStyle: TextStyle(
                    color: AppColors.muted,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  tooltip: 'Clear search',
                  onPressed: onClear,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.mutedDark,
                  ),
                );
              },
            ),
            IconButton(
              tooltip: 'Filters',
              onPressed: onFilter,
              icon: Badge(
                isLabelVisible: filterActive,
                smallSize: 8,
                backgroundColor: AppColors.accentGreen,
                child: const Icon(Icons.tune_rounded, color: AppColors.ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
