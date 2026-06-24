import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petfinder/core/di/injection_container.dart';
import 'package:petfinder/core/presentation/cubit/theme_cubit.dart';
import 'package:petfinder/core/theming/theme_data.dart';
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/core/utils/snackbar_helper.dart';
import 'package:petfinder/core/widgets/bottom_nav_bar.dart';
import 'package:petfinder/core/widgets/category_filter_row.dart';
import 'package:petfinder/core/widgets/error_state_view.dart';
import 'package:petfinder/features/details/presentation/screens/details_screen.dart';
import 'package:petfinder/features/favourites/presentation/bloc/favorites_bloc.dart';
import 'package:petfinder/features/favourites/presentation/bloc/favorites_event.dart';
import 'package:petfinder/features/favourites/presentation/bloc/favorites_state.dart';
import 'package:petfinder/features/home/domain/entities/pet.dart';
import 'package:petfinder/features/home/domain/utils/pet_filter_utils.dart';
import 'package:petfinder/features/home/presentation/bloc/pet_list_bloc.dart';
import 'package:petfinder/features/home/presentation/bloc/pet_list_event.dart';
import 'package:petfinder/features/home/presentation/bloc/pet_list_state.dart';
import 'package:petfinder/features/home/presentation/screens/widgets/filter_button.dart';
import 'package:petfinder/features/home/presentation/screens/widgets/filter_sheet.dart';
import 'package:petfinder/features/home/presentation/screens/widgets/pet_card.dart';
import 'package:petfinder/features/home/presentation/screens/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PetListBloc _petListBloc;
  late final FavouritesBloc _favouritesBloc;
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  PetType? _selectedType;

  @override
  void initState() {
    super.initState();
    _petListBloc = sl<PetListBloc>()..add(LoadPets());
    _favouritesBloc = sl<FavouritesBloc>()..add(LoadFavouritesEvent(type: null));
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _petListBloc.close();
    _favouritesBloc.close();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = _petListBloc.state;
      if (state is PetListLoaded && state.hasMoreData) {
        _petListBloc.add(LoadMorePets(type: _selectedType));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _petListBloc),
        BlocProvider.value(value: _favouritesBloc),
      ],
      child: Scaffold(
        backgroundColor: AppTheme.background(context),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Find Your Forever Pet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary(context),
                      ),
                    ),

                    // Theme Toggle Button
                    BlocBuilder<ThemeCubit, ThemeMode>(
                      builder: (context, themeMode) {
                        final isDark = themeMode == ThemeMode.dark;

                        return IconButton(
                          onPressed: () {
                            sl<ThemeCubit>().toggleTheme();
                          },
                          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                        );
                      },
                    ),

                  ],
                ),
              ),

              // Search + Filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomSearchBar(
                        onChanged: (query) {
                          if (query.isEmpty) {
                            _petListBloc.add(LoadPets(type: _selectedType));
                          } else {
                            _petListBloc.add(SearchPets(query, type: _selectedType));
                          }
                        },
                        controller: _searchController,
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilterButton(onTap: () => _showFilterSheet()),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Categories
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary(context),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              CategoryFilterRow(
                onCategorySelected: (petType) {
                  _selectedType = petType;
                  _searchController.clear();
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(0);
                  }
                  _petListBloc.add(LoadPets(type: petType));
                },
              ),

              const SizedBox(height: 24),

              // Pet List + Favourites handling
              Expanded(
                child: BlocBuilder<PetListBloc, PetListState>(
                  bloc: _petListBloc,
                  buildWhen: (previous, current) {
                    if (previous.runtimeType != current.runtimeType) return true;
                    if (previous is PetListLoaded && current is PetListLoaded) {
                      return previous.filteredPets != current.filteredPets ||
                          previous.hasMoreData != current.hasMoreData;
                    }
                    return true;
                  },
                  builder: (context, petState) {
                    if (petState is PetListLoading) {
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    } else if (petState is PetListLoaded || petState is PetListLoadingMore) {
                      final pets = petState is PetListLoaded ? petState.filteredPets
                          : (petState as PetListLoadingMore).filteredPets;

                      final hasMoreData = petState is PetListLoaded
                          ? petState.hasMoreData
                          : false;

                      final isLoadingMore = petState is PetListLoadingMore;

                      if (pets.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No ${_selectedType?.displayName ?? 'Pets'} found',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Coming soon!',
                                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                              ),
                            ],
                          ),
                        );
                      }

                      return BlocSelector<FavouritesBloc, FavouritesState, Set<String>>(
                        selector: (state) {
                          if (state is FavouritesLoaded) {
                            return state.favourites
                                .map((f) => '${f.imageId}_${f.type.index}')
                                .toSet();
                          }
                          return <String>{};
                        },
                        builder: (context, favouriteIds) {
                          return ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: pets.length + (hasMoreData || isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {

                              if (index >= pets.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                );
                              }

                              final PetEntity pet = pets[index];
                              final keyString = '${pet.imageId}_${pet.type.index}';
                              final isFavourite = favouriteIds.contains(keyString);

                              return PetCard(
                                key: ValueKey(keyString),
                                name: pet.name,
                                image: pet.imageUrl ?? 'assets/images/placeholder.png',
                                gender: pet.type == PetType.cat ? 'Cat' : 'Dog',
                                age: pet.origin ?? 'Unknown origin',
                                distance: '${index + 1}.0 km away',
                                isFavourite: isFavourite,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailsScreen(
                                        type: pet.type,
                                        petId: pet.id,
                                        imageId: pet.imageId,
                                        imageUrl: pet.imageUrl,
                                      ),
                                    ),
                                  );
                                },
                                onFavorite: () {
                                  final favBloc = context.read<FavouritesBloc>();
                                  if (isFavourite) {
                                    final state = favBloc.state;
                                    if (state is FavouritesLoaded) {
                                      final favourite = state.favourites.firstWhere(
                                        (f) => f.imageId == pet.imageId && f.type == pet.type,
                                      );
                                      favBloc.add(RemoveFavouriteEvent(
                                        type: pet.type,
                                        favouriteId: favourite.id,
                                      ));
                                      SnackBarHelper.showInfo(
                                        context,
                                        '${pet.name} removed from favourites',
                                      );
                                    }
                                  } else {
                                    favBloc.add(AddFavouriteEvent(
                                      type: pet.type,
                                      imageId: pet.imageId ?? '',
                                      petId: pet.id,
                                      subId: 'user123',
                                      name: pet.name,
                                      imageUrl: pet.imageUrl ?? '',
                                      origin: pet.origin ?? 'Unknown',
                                    ));
                                    SnackBarHelper.showInfo(
                                      context,
                                      '${pet.name} added to favourites',
                                    );
                                  }
                                },
                              );
                            },
                          );
                        },
                      );
                    } else if (petState is PetListError) {
                      return ErrorStateView(
                        message: petState.message,
                        onRetry: () => context.read<PetListBloc>().add(LoadPets()),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 0),
      ),
    );
  }

  void _showFilterSheet() {
    final state = _petListBloc.state;
    if (state is! PetListLoaded) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: _petListBloc,
        child: FilterSheet(
          origins: PetFilterUtils.extractOrigins(state.allPets),
          temperaments: PetFilterUtils.extractTemperaments(state.allPets),
        ),
      ),
    );
  }
}
