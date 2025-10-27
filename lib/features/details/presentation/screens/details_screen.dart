import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petfinder/core/di/injection_container.dart';
import 'package:petfinder/core/utils/app_colors.dart';
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/core/utils/snackbar_helper.dart';
import 'package:petfinder/features/favourites/presentation/bloc/favorites_bloc.dart';
import 'package:petfinder/features/favourites/presentation/bloc/favorites_event.dart';
import 'package:petfinder/features/favourites/presentation/bloc/favorites_state.dart';
import '../../../favourites/domain/entities/favourite_entity.dart';
import '../bloc/pet_details_bloc.dart';
import '../bloc/pet_details_event.dart';
import '../bloc/pet_details_states.dart';
import 'widgets/info_card.dart';

class DetailsScreen extends StatefulWidget {
  final PetType type;
  final dynamic petId;

  const DetailsScreen({super.key, required this.type, required this.petId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final PetDetailsBloc _bloc;
  late final FavouritesBloc _favouritesBloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<PetDetailsBloc>();
    _favouritesBloc = sl<FavouritesBloc>();
    _bloc.add(LoadPetDetails(widget.type, widget.petId));
    _favouritesBloc.add(LoadFavouritesEvent(type: widget.type));
  }

  @override
  void dispose() {
    _bloc.close();
    _favouritesBloc.close();
    super.dispose();
  }

  bool _isFavourite(String imageId, PetType type, FavouritesState state) {
    if (state is FavouritesLoaded) {
      return state.favourites.any(
            (f) => f.imageId == imageId && f.type == type,
      );
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _bloc),
        BlocProvider.value(value: _favouritesBloc),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<PetDetailsBloc, PetDetailsState>(
            builder: (context, petState) {
              if (petState is PetDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (petState is PetDetailsLoaded) {
                final pet = petState.details;

                return BlocBuilder<FavouritesBloc, FavouritesState>(
                  builder: (context, favState) {
                    final isFavourite =
                    _isFavourite(pet.id.toString(), widget.type, favState);

                    return Column(
                      children: [
                        // Header with image and favourite button
                        Stack(
                          clipBehavior: Clip.hardEdge,
                          children: [
                            Container(
                              height: 380,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE8F8F6),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(32),
                                  bottomRight: Radius.circular(32),
                                ),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Center(
                                child: pet.imageUrl != null
                                    ? Image.network(
                                  pet.imageUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 380,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.pets,
                                    size: 100,
                                    color: AppColors.primary,
                                  ),
                                )
                                    : const Icon(
                                  Icons.pets,
                                  size: 100,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: 16,
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 16,
                              child: GestureDetector(
                                onTap: () {
                                  if (isFavourite) {
                                    // Remove from favourites
                                    FavouriteEntity? fav;
                                    if (favState is FavouritesLoaded) {
                                      try {
                                        fav = favState.favourites.firstWhere((f) => f.imageId == pet.id.toString() && f.type == widget.type,);
                                      } catch (_) {
                                        fav = null;
                                      }
                                    }
                                    if (fav != null) {
                                      _favouritesBloc.add(RemoveFavouriteEvent(
                                        type: widget.type,
                                        favouriteId: fav.id,
                                      ));
                                      SnackBarHelper.showInfo(context,
                                          '${pet.name} removed from favourites');
                                    }
                                  } else {
                                    // Add to favourites
                                    _favouritesBloc.add(AddFavouriteEvent(
                                      type: pet.type,
                                      imageId: pet.id,
                                      subId: 'user123',
                                      name: pet.name,
                                      imageUrl: pet.imageUrl ?? '',
                                      origin: pet.origin ?? 'Unknown',
                                    ));
                                    SnackBarHelper.showInfo(context,
                                        '${pet.name} added to favourites');
                                  }
                                },
                                child: Icon(
                                  isFavourite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: AppColors.primary,
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Details section
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          pet.name,
                                          style: const TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '\$${'35'}',
                                        style: const TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        pet.origin ?? 'Unknown location',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InfoCard(
                                          title: 'Gender',
                                          value: 'Unknown',
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: InfoCard(
                                          title: 'Age',
                                          value: pet.lifeSpan ?? 'Unknown',
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: InfoCard(
                                          title: 'Weight',
                                          value: pet.weight ?? 'Unknown',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'About:',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    pet.description ??
                                        'No description available',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                      height: 1.6,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        SnackBarHelper.showInfo(context,
                                            "Adopting ${pet.name}...");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        'Adopt me',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else if (petState is PetDetailsError) {
                return Center(
                  child: Text(
                    'Error: ${petState.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
