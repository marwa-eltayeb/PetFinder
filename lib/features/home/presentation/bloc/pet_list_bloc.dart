import 'package:flutter_bloc/flutter_bloc.dart';
import 'pet_list_event.dart';
import 'pet_list_state.dart';
import '../../domain/use_cases/get_all_pets.dart';
import '../../domain/entities/pet.dart';

class PetListBloc extends Bloc<PetListEvent, PetListState> {
  final GetAllPets getAllPets;
  List<Pet> _allPets = [];

  PetListBloc(this.getAllPets) : super(PetListInitial()) {
    on<LoadPets>((event, emit) async {
      emit(PetListLoading());
      try {
        _allPets = await getAllPets(limit: event.limit, page: event.page);
        // filter locally if a type was chosen
        if (event.type != null) {
          final filtered = _allPets.where((p) => p.type == event.type).toList();
          emit(PetListLoaded(filtered));
        } else {
          emit(PetListLoaded(_allPets));
        }
      } catch (e) {
        emit(PetListError(e.toString()));
      }
    });
  }
}
