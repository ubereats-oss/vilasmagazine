import 'package:flutter/material.dart';

import '../../../../data/models/category.dart';

class CategoryChipBar extends StatelessWidget {
  const CategoryChipBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<Category> categories;
  final Category? selectedCategory;
  final ValueChanged<Category?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected =
              category.isAll && selectedCategory == null ||
              selectedCategory?.slug == category.slug;

          return ChoiceChip(
            label: Text(category.name),
            selected: selected,
            onSelected: (_) => onSelected(category.isAll ? null : category),
          );
        },
      ),
    );
  }
}
