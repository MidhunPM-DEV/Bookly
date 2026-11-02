import 'package:bookly/core/theme/app_colors.dart';
import 'package:bookly/features/home/data/models/home_models.dart';
import 'package:flutter/material.dart';

class SearchFilters {
  const SearchFilters({
    this.categories = const {},
    this.slotsOpenOnly = false,
  });

  final Set<String> categories;
  final bool slotsOpenOnly;

  bool get isActive => categories.isNotEmpty || slotsOpenOnly;

  SearchFilters copyWith({
    Set<String>? categories,
    bool? slotsOpenOnly,
  }) {
    return SearchFilters(
      categories: categories ?? this.categories,
      slotsOpenOnly: slotsOpenOnly ?? this.slotsOpenOnly,
    );
  }
}

Future<SearchFilters?> showSearchFilterSheet(
  BuildContext context, {
  required SearchFilters current,
}) {
  return showModalBottomSheet<SearchFilters>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => _SearchFilterSheet(initial: current),
  );
}

class _SearchFilterSheet extends StatefulWidget {
  const _SearchFilterSheet({required this.initial});

  final SearchFilters initial;

  @override
  State<_SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<_SearchFilterSheet> {
  late Set<String> _categories;
  late bool _slotsOpenOnly;

  @override
  void initState() {
    super.initState();
    _categories = {...widget.initial.categories};
    _slotsOpenOnly = widget.initial.slotsOpenOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + MediaQuery.paddingOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.chipOutline,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Filters',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _categories.clear();
                    _slotsOpenOnly = false;
                  });
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Category',
            style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.mutedDark),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: HomeMockData.categories.map((category) {
              final selected = _categories.contains(category.label);
              return FilterChip(
                label: Text(category.label),
                selected: selected,
                onSelected: (value) {
                  setState(() {
                    if (value) {
                      _categories.add(category.label);
                    } else {
                      _categories.remove(category.label);
                    }
                  });
                },
                selectedColor: AppColors.ink,
                checkmarkColor: AppColors.lime,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.ink,
                ),
                backgroundColor: AppColors.surface,
                side: BorderSide(
                  color: selected ? AppColors.ink : AppColors.chipOutline,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Slots open now',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            value: _slotsOpenOnly,
            activeThumbColor: AppColors.ink,
            activeTrackColor: AppColors.lime,
            onChanged: (value) => setState(() => _slotsOpenOnly = value),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.lime,
                foregroundColor: AppColors.ink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                  SearchFilters(
                    categories: _categories,
                    slotsOpenOnly: _slotsOpenOnly,
                  ),
                );
              },
              child: const Text(
                'Show results',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
