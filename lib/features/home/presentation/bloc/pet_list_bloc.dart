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

  int _currentPage = 0;
  bool _hasMoreData = true;

  PetListBloc(this.getAllPets, this.searchPets) : super(PetListInitial()) {
    on<LoadPets>(_onLoadPets);
    on<LoadMorePets>(_onLoadMorePets);
    on<SearchPets>(_onSearchPets);
    on<FilterPets>(_onFilterPets);
  }

  Future<void> _onLoadPets(LoadPets event, Emitter<PetListState> emit) async {
    emit(PetListLoading());
    try {
      // Reset pagination state when loading fresh
      _currentPage = 0;
      _hasMoreData = true;

      _allPets = await getAllPets(limit: event.limit, page: event.page);

      // Get pets for this category
      final categoryPets = event.type != null
          ? _allPets.where((p) => p.type == event.type).toList()
          : _allPets;

      // Determine if more data is available
      _hasMoreData = _allPets.length >= event.limit;

      emit(PetListLoaded(
        allPets: categoryPets,
        filteredPets: categoryPets,
        petType: event.type,
        hasMoreData: _hasMoreData,
      ));

    } catch (e) {
      emit(PetListError(e.toString()));
    }
  }

  Future<void> _onLoadMorePets(LoadMorePets event, Emitter<PetListState> emit) async {
    final currentState = state;
    if (currentState is! PetListLoaded) return;

    // Don't load if no more data
    if (!_hasMoreData) return;

    // Emit loading more state (keeps existing data visible)
    emit(PetListLoadingMore(
      allPets: currentState.allPets,
      filteredPets: currentState.filteredPets,
      petType: currentState.petType,
    ));

    try {
      // Increment page and fetch next batch
      _currentPage++;
      final newPets = await getAllPets(limit: event.limit, page: _currentPage);

      bool shouldStopLoading = false;

      if (event.type != null) {
        // Check if that specific type has no more data
        final newCategoryPets = newPets.where((p) => p.type == event.type).toList();
        shouldStopLoading = newCategoryPets.isEmpty || newCategoryPets.length < event.limit;
      } else {
        // Stop only if fewer than limit fetched
        shouldStopLoading = newPets.length < 5;
      }

      if (shouldStopLoading) {
        _hasMoreData = false;
      }

      // Append new unique pets to existing list
      _allPets.addAll(newPets);

      // Get pets for current category
      final categoryPets = event.type != null
          ? _allPets.where((p) => p.type == event.type).toList()
          : _allPets;

      emit(PetListLoaded(
        allPets: categoryPets,
        filteredPets: categoryPets,
        petType: event.type,
        hasMoreData: _hasMoreData,
      ));

    } catch (e) {
      // On error, restore previous state
      emit(currentState);
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
        hasMoreData: false,
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
        hasMoreData: currentState.hasMoreData,
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
      hasMoreData: currentState.hasMoreData,
    ));
  }

}