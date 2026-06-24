import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurfaceAlt,
          border: Border.all(
            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}