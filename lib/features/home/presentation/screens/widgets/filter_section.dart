import 'package:flutter/material.dart';
import 'filter_chip_item.dart';

class FilterSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final void Function(String) onTap;

  const FilterSection({
    super.key,
    required this.title,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, top: 16),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map(
                (item) => FilterChipItem(
              label: item,
              onTap: () => onTap(item),
            ),
          )
          .toList(),
        ),
      ],
    );
  }
}