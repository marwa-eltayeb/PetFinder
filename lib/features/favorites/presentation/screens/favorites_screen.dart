import 'package:flutter/material.dart';
import 'package:petfinder/features/favorites/presentation/widgets/favorite_pet_card.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../../core/widgets/category_chip.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String selectedCategory = 'All';

  final List<String> categories = ['All', 'Cats', 'Dogs', 'Birds', 'Fish', 'Reptiles'];

  final List<Map<String, dynamic>> favoritePets = [
    {
      'name': 'Joli',
      'image': 'assets/images/joli.png',
      'distance': '1.6 km away',
    },
    {
      'name': 'Oliver',
      'image': 'assets/images/oliver.png',
      'distance': '2 km away',
    },
    {
      'name': 'Tom',
      'image': 'assets/images/tom.png',
      'distance': '2.7 km away',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Your Favorite Pets',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return CategoryChip(
                    label: categories[index],
                    isSelected: selectedCategory == categories[index],
                    onTap: () {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: favoritePets.length,
                itemBuilder: (context, index) {
                  return FavoritePetCard(
                    name: favoritePets[index]['name'],
                    image: favoritePets[index]['image'],
                    distance: favoritePets[index]['distance'],
                    onTap: () {},
                    onFavorite: () {
                      setState(() {
                        favoritePets.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}