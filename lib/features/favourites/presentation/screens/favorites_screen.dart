import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petfinder/core/di/injection_container.dart';
import 'package:petfinder/core/routing/routes.dart';
import 'package:petfinder/core/theming/theme_data.dart';
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/core/widgets/bottom_nav_bar.dart';
import 'package:petfinder/core/widgets/category_chip.dart';
import 'package:petfinder/features/favourites/presentation/bloc/favorites_bloc.dart';
import 'package:petfinder/features/favourites/presentation/bloc/favorites_event.dart';
import 'package:petfinder/features/favourites/presentation/bloc/favorites_state.dart';
import 'package:petfinder/features/favourites/presentation/widgets/favorite_pet_card.dart';

import '../../../../core/widgets/error_state_view.dart';


class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String selectedCategory = 'All';
  late final FavouritesBloc _favouritesBloc;

  final List<String> categories = [
    'All',
    'Cats',
    'Dogs',
    'Birds',
    'Fish',
    'Reptiles',
  ];

  @override
  void initState() {
    super.initState();
    _favouritesBloc = sl<FavouritesBloc>();
    _favouritesBloc.add(LoadFavouritesEvent(type: null));
  }

  @override
  void dispose() {
    _favouritesBloc.close();
    super.dispose();
  }

  PetType? _getTypeFromCategory() {
    switch (selectedCategory) {
      case 'Cats': return PetType.cat;
      case 'Dogs': return PetType.dog;
      case 'Birds': return PetType.bird;
      case 'Fish': return PetType.fish;
      case 'Reptiles': return PetType.reptile;
      default: return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _favouritesBloc,
      child: Scaffold(
        backgroundColor: AppTheme.background(context),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Your Favourite Pets',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary(context),
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
                        _favouritesBloc.add(
                          LoadFavouritesEvent(type: _getTypeFromCategory()),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<FavouritesBloc, FavouritesState>(
                  builder: (context, state) {
                    if (state is FavouritesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FavouritesError) {
                      return ErrorStateView(
                        message: state.message,
                        onRetry: () => context.read<FavouritesBloc>().add(LoadFavouritesEvent(type: _getTypeFromCategory())),
                      );
                    } else if (state is FavouritesLoaded) {
                      final favourites = state.favourites;
                      if (favourites.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_border,
                                size: 64,
                                color: AppTheme.textSecondary(context),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No favourites yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary(context),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start adding pets to your favourites!',
                                style: TextStyle(
                                  color: AppTheme.textSecondary(context),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: favourites.length,
                        itemBuilder: (context, index) {
                          final fav = favourites[index];
                          return FavoritePetCard(
                            name: fav.breedName ?? fav.imageId,
                            image: fav.imageUrl ?? 'assets/images/placeholder.png',
                            origin: fav.origin ?? 'Unknown',
                            isFavourite: true,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.detailsScreen,
                                arguments: {
                                  'type': fav.type,
                                  'petId': fav.imageId,
                                },
                              );
                            },
                            onFavorite: () {
                              _favouritesBloc.add(
                                RemoveFavouriteEvent(
                                  type: fav.type,
                                  favouriteId: fav.id,
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 1),
      ),
    );
  }
}