import 'package:flutter/material.dart';
import 'package:petfinder/core/theming/theme_data.dart';
import 'package:petfinder/core/utils/app_colors.dart';
import 'package:petfinder/core/widgets/pet_image.dart';

class PetCard extends StatelessWidget {
  final String name;
  final String image;
  final String gender;
  final String age;
  final String distance;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool isFavourite;

  const PetCard({
    super.key,
    required this.name,
    required this.image,
    required this.gender,
    required this.age,
    required this.distance,
    required this.onTap,
    required this.onFavorite,
    required this.isFavourite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surface(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [

            // Image Section
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: AppColors.lightSurfaceAlt,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: PetImage(imageUrl: image, iconSize: 40),
              ),
            ),

            const SizedBox(width: 16),

            // Details Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    gender,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    age,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary(context),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onFavorite,
              icon: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_border,
                color: AppTheme.primary(context),
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}