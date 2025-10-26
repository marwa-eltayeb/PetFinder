import 'package:flutter/material.dart';

import '../routing/routes.dart';
import '../utils/app_colors.dart';
import '../utils/snackbar_helper.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavBarItem(
            icon: Icons.home,
            isSelected: currentIndex == 0,
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.homeScreen);
            },
          ),
          NavBarItem(
            icon: Icons.favorite_border,
            isSelected: currentIndex == 1,
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.favoritesScreen);
            },
          ),
          NavBarItem(
            icon: Icons.chat_bubble_outline,
            isSelected: currentIndex == 2,
            onTap: () {
              SnackBarHelper.showInfo(context, 'ChatScreen coming soon!');
            },
          ),
          NavBarItem(
            icon: Icons.person_outline,
            isSelected: currentIndex == 3,
            onTap: () {
              SnackBarHelper.showInfo(context, 'ProfileScreen coming soon!');
            },
          ),
        ],
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const NavBarItem({
    Key? key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : AppColors.textSecondary,
          size: 24,
        ),
      ),
    );
  }
}