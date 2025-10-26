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
  }

  Future<void> _onLoadPets(LoadPets event, Emitter<PetListState> emit) async {
    emit(PetListLoading());
    try {
      _allPets = await getAllPets(limit: event.limit, page: event.page);
      final pets = event.type != null
          ? _allPets.where((p) => p.type == event.type).toList()
          : _allPets;
      emit(PetListLoaded(pets));
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

      emit(PetListLoaded(filtered, filter: event.type));
    } catch (e) {
      emit(PetListError(e.toString()));
    }
  }
}
