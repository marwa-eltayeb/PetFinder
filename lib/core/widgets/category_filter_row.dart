import 'package:flutter/material.dart';
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/core/widgets/category_chip.dart';

class CategoryFilterRow extends StatefulWidget {
  const CategoryFilterRow({super.key, required this.onCategorySelected});

  final ValueChanged<PetType?> onCategorySelected;

  @override
  State<CategoryFilterRow> createState() => _CategoryFilterRowState();
}

class _CategoryFilterRowState extends State<CategoryFilterRow> {
  PetType? selectedType;

  final List<PetType?> categories = [null, ...PetType.values];

  String _getLabel(PetType? type) => type?.displayName ?? 'All';

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final type = categories[index];
          return CategoryChip(
            label: _getLabel(type),
            isSelected: selectedType == type,
            onTap: () {
              setState(() => selectedType = type);
              widget.onCategorySelected(type);
            },
          );
        },
      ),
    );
  }
}


