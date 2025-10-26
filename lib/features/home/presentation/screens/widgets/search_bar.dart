import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final Widget leading;

  const CustomSearchBar({
    Key? key,
    required this.hintText,
    required this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          leading,
          const SizedBox(width: 12),
          Text(
            hintText,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}