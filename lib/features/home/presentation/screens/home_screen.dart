import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petfinder/core/widgets/bottom_nav_bar.dart';
import 'package:petfinder/core/widgets/category_chip.dart';
import 'package:petfinder/features/home/presentation/screens/widgets/filter_button.dart';
import 'package:petfinder/features/home/presentation/screens/widgets/pet_card.dart';
import 'package:petfinder/features/home/presentation/screens/widgets/search_bar.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/pet_type.dart';
import '../../../details/presentation/screens/details_screen.dart';
import '../../domain/entities/pet.dart';
import '../bloc/pet_list_bloc.dart';
import '../bloc/pet_list_event.dart';
import '../bloc/pet_list_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  late final PetListBloc _petListBloc;
  late final TextEditingController _searchController;

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

  @override
  void initState() {
    super.initState();
    _petListBloc = createPetListBloc();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _petListBloc.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _petListBloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
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
                    const Text(
                      'Find Your Forever Pet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_outlined),
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
                          final type = selectedCategory == 'Cats'
                              ? PetType.cat
                              : selectedCategory == 'Dogs'
                              ? PetType.dog
                              : null;

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
                    FilterButton(onTap: () {}),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Categories
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
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

              // Pet List
              Expanded(
                child: BlocBuilder<PetListBloc, PetListState>(
                  bloc: _petListBloc,
                  builder: (context, state) {
                    if (state is PetListLoading) {
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    } else if (state is PetListLoaded) {
                      final pets = state.pets;
                      if (pets.isEmpty) {
                        return const Center(child: Text('No pets found.'));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: pets.length,
                        itemBuilder: (context, index) {
                          final Pet pet = pets[index];
                          return PetCard(
                            name: pet.name,
                            image:
                                pet.imageUrl ?? 'assets/images/placeholder.png',
                            gender: pet.type == PetType.cat ? 'Cat' : 'Dog',
                            age: pet.origin ?? 'Unknown origin',
                            distance: '${index + 1}.0 km away',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailsScreen(
                                    type: pet.type,
                                    petId: pet.type == PetType.cat
                                        ? pet.id
                                        : int.parse(pet.id),
                                  ),
                                ),
                              );
                            },
                            onFavorite: () {},
                          );
                        },
                      );
                    } else if (state is PetListError) {
                      return Center(child: Text('Error: ${state.message}'));
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

    // Reset search bar text
    _searchController.clear();

    // Decide which type to load
    PetType? type;
    if (category == 'Cats') type = PetType.cat;
    if (category == 'Dogs') type = PetType.dog;

    _petListBloc.add(LoadPets(type: type));
  }

}
