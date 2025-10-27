import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';

class FavoritePetCard extends StatelessWidget {
  final String name;
  final String image;
  final String origin;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool isFavourite;

  const FavoritePetCard({
    super.key,
    required this.name,
    required this.image,
    required this.origin,
    required this.onTap,
    required this.onFavorite,
    required this.isFavourite,
  });

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage = image.startsWith('http');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F8F6),
                  ),
                  child: isNetworkImage
                      ? Image.network(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.pets,
                          size: 50,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  )
                      : Image.asset(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.pets,
                          size: 50,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.red,
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          origin,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 4),

                      GestureDetector(
                        onTap: onFavorite,
                        child: Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: AppColors.primary,
                          size: 20,
                        ),
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