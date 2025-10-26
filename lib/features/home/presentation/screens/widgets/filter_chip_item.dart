import 'package:flutter/material.dart';

class FilterChipItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const FilterChipItem({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blueAccent),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}