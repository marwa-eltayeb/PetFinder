import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petfinder/core/di/injection_container.dart';
import 'package:petfinder/core/presentation/cubit/theme_cubit.dart';
import 'package:petfinder/core/theming/theme_data.dart';
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/core/utils/snackbar_helper.dart';
import 'package:petfinder/core/widgets/bottom_nav_bar.dart';
import 'package:petfinder/core/widgets/category_chip.dart';
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
  String selectedCategory = 'All';
  late final PetListBloc _petListBloc;
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  final List<String> categories = [
    'All',
    'Cats',
    'Dogs',
    'Birds',
    'Fish',
    'Reptiles',
  ];

  PetListBloc createPetListBloc() {
    final bloc = sl<PetListBloc>();
    bloc.add(LoadPets());
    return bloc;
  }

  PetType? _getTypeFromCategory(String category) {
    return category == 'Cats'
        ? PetType.cat
        : category == 'Dogs'
        ? PetType.dog
        : null;
  }

  @override
  void initState() {
    super.initState();
    _petListBloc = createPetListBloc();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _petListBloc.close();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = _petListBloc.state;
      if (state is PetListLoaded && state.hasMoreData) {
        final type = _getTypeFromCategory(selectedCategory);
        _petListBloc.add(LoadMorePets(type: type));
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
        BlocProvider(create: (_) => sl<FavouritesBloc>()..add(LoadFavouritesEvent(type: null))),
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
                          final type = _getTypeFromCategory(selectedCategory);

                          if (query.isEmpty) {
                            _petListBloc.add(LoadPets(type: type));
                          } else {
                            _petListBloc.add(SearchPets(query, type: type));
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

              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryChip(
                      label: category,
                      isSelected: selectedCategory == category,
                      onTap: () => _handleCategorySelection(category),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Pet List + Favourites handling
              Expanded(
                child: BlocBuilder<PetListBloc, PetListState>(
                  bloc: _petListBloc,
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
                        return const Center(child: Text('No pets found.'));
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

                              final Pet pet = pets[index];
                              final isFavourite = favouriteIds.contains('${pet.id}_${pet.type.index}');

                              return PetCard(
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
                                        (f) => f.imageId == pet.id && f.type == pet.type,
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
                                      imageId: pet.id,
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
                      return Center(child: Text('Error: ${petState.message}'));
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

  void _handleCategorySelection(String category) {
    setState(() => selectedCategory = category);
    _searchController.clear();

    // Reset scroll position to top
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }

    PetType? type;
    if (category == 'Cats') type = PetType.cat;
    if (category == 'Dogs') type = PetType.dog;

    _petListBloc.add(LoadPets(type: type));
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
      builder: (_) => FilterSheet(
        origins: PetFilterUtils.extractOrigins(state.allPets),
        temperaments: PetFilterUtils.extractTemperaments(state.allPets),
        bloc: _petListBloc,
      ),
    );
  }
}
