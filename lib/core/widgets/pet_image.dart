import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:petfinder/core/theming/theme_data.dart';

class PetImage extends StatelessWidget {
  final String imageUrl;
  final double iconSize;

  const PetImage({super.key, required this.imageUrl, this.iconSize = 40});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
      errorWidget: (_, __, ___) => Icon(Icons.pets, size: iconSize, color: AppTheme.primary(context)),
    );
  }
}