import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petfinder/core/di/injection_container.dart';
import 'package:petfinder/core/theming/theme_data.dart';
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/core/utils/snackbar_helper.dart';
import 'package:petfinder/core/widgets/error_state_view.dart';
import 'package:petfinder/features/details/presentation/bloc/pet_details_bloc.dart';
import 'package:petfinder/features/details/presentation/bloc/pet_details_event.dart';
import 'package:petfinder/features/details/presentation/bloc/pet_details_states.dart';
import 'package:petfinder/features/details/presentation/screens/widgets/info_card.dart';
import 'package:petfinder/features/favourites/domain/entities/favourite_entity.dart';
import 'package:petfinder/features/favourites/presentation/bloc/favorites_bloc.dart';
import 'package:petfinder/features/favourites/presentation/bloc/favorites_event.dart';
import 'package:petfinder/features/favourites/presentation/bloc/favorites_state.dart';

class DetailsScreen extends StatefulWidget {
  final PetType type;
  final dynamic petId;
  final String? imageId;
  final String? imageUrl;

  const DetailsScreen({
    super.key,
    required this.type,
    required this.petId,
    this.imageId,
    this.imageUrl,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late final PetDetailsBloc _petDetailsBloc;
  late final FavouritesBloc _favouritesBloc;

  @override
  void initState() {
    super.initState();
    _petDetailsBloc = sl<PetDetailsBloc>();
    _favouritesBloc = sl<FavouritesBloc>();
    _petDetailsBloc.add(
      LoadPetDetails(
        widget.type,
        widget.petId,
        imageId: widget.imageId,
        imageUrl: widget.imageUrl,
      ),
    );
    _favouritesBloc.add(LoadFavouritesEvent(type: widget.type));
  }

  @override
  void dispose() {
    _petDetailsBloc.close();
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
        BlocProvider.value(value: _petDetailsBloc),
        BlocProvider.value(value: _favouritesBloc),
      ],
      child: Scaffold(
        backgroundColor: AppTheme.background(context),
        body: SafeArea(
          child: BlocBuilder<PetDetailsBloc, PetDetailsState>(
            builder: (context, petState) {
              if (petState is PetDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (petState is PetDetailsLoaded) {
                final pet = petState.details;
                final imageUrl = petState.imageUrl;
                final imageId = petState.imageId;

                return Column(
                  children: [
                    // Header with image and favourite button
                    Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        // Image Section
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
                          child: CachedNetworkImage(
                            imageUrl: imageUrl ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Icon(
                                Icons.pets,
                                size: 100,
                                color: AppTheme.primary(context),
                              ),
                            ),
                          ),
                        ),

                        // Back button and favourite button
                        Positioned(
                          top: 20,
                          left: 16,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: AppTheme.primary(context),
                              size: 20,
                            ),
                          ),
                        ),

                        Positioned(
                          top: 20,
                          right: 16,
                          child: BlocBuilder<FavouritesBloc, FavouritesState>(
                            builder: (context, favState) {
                              final isFavourite = _isFavourite(imageId ?? '', widget.type, favState);
                              return GestureDetector(
                                onTap: () {
                                  if (isFavourite) {
                                    // Remove from favourites
                                    FavouriteEntity? fav;
                                    if (favState is FavouritesLoaded) {
                                      fav = favState.favourites.cast<FavouriteEntity?>().firstWhere(
                                          (f) => f?.imageId == imageId && f?.type == widget.type,
                                          orElse: () => null,
                                      );
                                    }
                                    if (fav != null) {
                                      _favouritesBloc.add(
                                        RemoveFavouriteEvent(
                                          type: widget.type,
                                          favouriteId: fav.id,
                                        ),
                                      );
                                      SnackBarHelper.showInfo(
                                        context,
                                        '${pet.name} removed from favourites',
                                      );
                                    }
                                  } else {
                                    // Add to favourites
                                    _favouritesBloc.add(
                                      AddFavouriteEvent(
                                        type: pet.type,
                                        imageId: imageId ?? '',
                                        subId: 'user123',
                                        name: pet.name,
                                        imageUrl: imageUrl ?? '',
                                        origin: pet.origin ?? 'Unknown',
                                      ),
                                    );
                                    SnackBarHelper.showInfo(
                                      context,
                                      '${pet.name} added to favourites',
                                    );
                                  }
                                },
                                child: Icon(
                                  isFavourite ? Icons.favorite : Icons.favorite_border,
                                  color: AppTheme.primary(context),
                                  size: 28,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    // Details section
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        color: AppTheme.background(context),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      pet.name,
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary(context),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\$${'35'}',
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primary(context),
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
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textSecondary(context),
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
                              Text(
                                'About:',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary(context),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                pet.description ?? 'No description available',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondary(context),
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {
                                    SnackBarHelper.showInfo(
                                      context,
                                      "Adopting ${pet.name}...",
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primary(context),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
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
              } else if (petState is PetDetailsError) {
                return ErrorStateView(
                  message: petState.message,
                  onRetry: () => context.read<PetDetailsBloc>().add(
                    LoadPetDetails(widget.type, widget.petId),
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
