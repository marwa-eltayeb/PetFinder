import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petfinder/features/home/domain/use_cases/search_pets_use_case.dart';
import 'pet_list_event.dart';
import 'pet_list_state.dart';
import '../../domain/use_cases/get_all_pets_use_case.dart';
import '../../domain/entities/pet.dart';

class PetListBloc extends Bloc<PetListEvent, PetListState> {
  final GetAllPetsUseCase getAllPets;
  final SearchPetsUseCase searchPets;
  List<Pet> _allPets = [];

  PetListBloc(this.getAllPets, this.searchPets) : super(PetListInitial()) {
    on<LoadPets>(_onLoadPets);
    on<SearchPets>(_onSearchPets);
    on<FilterPets>(_onFilterPets);
  }

  Future<void> _onLoadPets(LoadPets event, Emitter<PetListState> emit) async {
    emit(PetListLoading());
    try {
      _allPets = await getAllPets(limit: event.limit, page: event.page);

      // Get pets for this category
      final categoryPets = event.type != null
          ? _allPets.where((p) => p.type == event.type).toList()
          : _allPets;

      emit(PetListLoaded(
        allPets: categoryPets,
        filteredPets: categoryPets,
        petType: event.type,
      ));

    } catch (e) {
      emit(PetListError(e.toString()));
    }
  }

  Future<void> _onSearchPets(SearchPets event, Emitter<PetListState> emit) async {
    emit(PetListLoading());
    try {
      final results = await searchPets(event.query);

      final filtered = (event.type != null)
          ? results.where((p) => p.type == event.type).toList()
          : results;

      emit(PetListLoaded(
        allPets: filtered,
        filteredPets: filtered,
        petType: event.type,
      ));
    } catch (e) {
      emit(PetListError(e.toString()));
    }
  }

  Future<void> _onFilterPets(FilterPets event, Emitter<PetListState> emit) async {
    final currentState = state;
    if (currentState is! PetListLoaded) return;

    List<Pet> filtered = currentState.allPets;

    // If both are null, show all pets
    if (event.origin == null && event.temperament == null) {
      emit(PetListLoaded(
        allPets: currentState.allPets,
        filteredPets: currentState.allPets,
        petType: currentState.petType,
      ));
      return;
    }

    // Filter by origin
    if (event.origin != null && event.origin!.isNotEmpty) {
      filtered = filtered
          .where((p) => (p.origin ?? '')
          .toLowerCase()
          .contains(event.origin!.toLowerCase()))
          .toList();
    }

    // Filter by temperament
    if (event.temperament != null && event.temperament!.isNotEmpty) {
      filtered = filtered
          .where((p) => (p.temperament ?? '')
          .toLowerCase()
          .contains(event.temperament!.toLowerCase()))
          .toList();
    }

    emit(PetListLoaded(
      allPets: currentState.allPets,
      filteredPets: filtered,
      petType: currentState.petType,
    ));
  }

}