import 'package:petfinder/features/details/domain/entities/pet_details.dart';

abstract class PetDetailsState {}
class PetDetailsInitial extends PetDetailsState {}
class PetDetailsLoading extends PetDetailsState {}
class PetDetailsLoaded extends PetDetailsState {
  final PetDetails details;
  PetDetailsLoaded(this.details);
}
class PetDetailsError extends PetDetailsState {
  final String message;
  PetDetailsError(this.message);
}
