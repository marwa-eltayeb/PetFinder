import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petfinder/core/di/injection_container.dart';
import 'package:petfinder/core/routing/routes.dart';
import 'package:petfinder/core/widgets/bottom_nav_bar.dart';
import 'package:petfinder/core/widgets/category_filter_row.dart';
import 'package:petfinder/core/widgets/error_state_view.dart' show ErrorStateView;
import 'package:petfinder/features/favourites/presentation/bloc/favorites_bloc.dart';
import 'package:petfinder/features/favourites/presentation/bloc/favorites_event.dart';
import 'package:petfinder/features/favourites/presentation/bloc/favorites_state.dart';
import 'package:petfinder/features/favourites/presentation/screens/widgets/favorite_pet_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavouritesBloc _favouritesBloc;

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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProvider.value(
      value: _favouritesBloc,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
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
                    color: colorScheme.onSurface,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              CategoryFilterRow(
                onCategorySelected: (petType) {
                  _favouritesBloc.add(LoadFavouritesEvent(type: petType));
                },
              ),

              const SizedBox(height: 24),

              Expanded(
                child: BlocBuilder<FavouritesBloc, FavouritesState>(
                  buildWhen: (previous, current) {
                    if (previous.runtimeType != current.runtimeType) {return true;}
                    if (previous is FavouritesLoaded && current is FavouritesLoaded) {
                      return !listEquals(
                        previous.favourites,
                        current.favourites,
                      );
                    }
                    return true;
                  },
                  builder: (context, state) {
                    if (state is FavouritesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FavouritesError) {
                      return ErrorStateView(
                        message: state.message,
                        onRetry: () => context.read<FavouritesBloc>().add(LoadFavouritesEvent(type: state.activeType)),
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
                                color: colorScheme.onSurface,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No favourites yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start adding pets to your favourites!',
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
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
                                  'petId': fav.petId,
                                  'imageId': fav.imageId,
                                  'imageUrl': fav.imageUrl,
                                },
                              );
                            },
                            onFavourite: () {
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


