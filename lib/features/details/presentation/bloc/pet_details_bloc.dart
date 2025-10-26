import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petfinder/features/details/presentation/bloc/pet_details_event.dart';
import 'package:petfinder/features/details/presentation/bloc/pet_details_states.dart';

import '../../domain/use_cases/get_pet_details_use_case.dart';

class PetDetailsBloc extends Bloc<PetDetailsEvent, PetDetailsState> {
  final GetPetDetailsUseCase getPetDetails;

  PetDetailsBloc(this.getPetDetails) : super(PetDetailsInitial()) {
    on<LoadPetDetails>((event, emit) async {
      emit(PetDetailsLoading());
      try {
        final details = await getPetDetails(event.type, event.id);
        emit(PetDetailsLoaded(details));
      } catch (e) {
        emit(PetDetailsError(e.toString()));
      }
    });
  }
}