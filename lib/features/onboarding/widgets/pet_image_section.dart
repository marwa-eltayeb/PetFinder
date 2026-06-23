import 'package:flutter/material.dart';

class PetImageSection extends StatelessWidget {
  final String imagePath;

  const PetImageSection({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.45,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
      ),
    );
  }
}