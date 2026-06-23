import 'package:flutter/material.dart';
import 'package:petfinder/core/theming/theme_data.dart';
import 'package:petfinder/core/utils/app_colors.dart';
import 'package:petfinder/core/widgets/pet_image.dart';

class FavoritePetCard extends StatelessWidget {
  final String name;
  final String image;
  final String origin;
  final VoidCallback onTap;
  final VoidCallback onFavourite;
  final bool isFavourite;

  const FavoritePetCard({
    super.key,
    required this.name,
    required this.image,
    required this.origin,
    required this.onTap,
    required this.onFavourite,
    required this.isFavourite,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: AppTheme.surface(context),
      elevation: colorScheme.brightness == Brightness.light ? 2 : 4,
      shadowColor: Colors.black.withValues(
        alpha: colorScheme.brightness == Brightness.light ? 0.05 : 0.2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: ColoredBox(
                  color: AppColors.lightSurfaceAlt,
                  child: PetImage(imageUrl: image, iconSize: 50),
                ),
              ),
            ),


            // Details Section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.red,),

                      const SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          origin,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 4),

                      IconButton(
                        onPressed: onFavourite,
                        icon: Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: isFavourite ? 'Remove from favorites' : 'Add to favorites',
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}