import '../../domain/entities/pet.dart';
import '../../../../core/utils/pet_type.dart';

abstract class PetListState {}

class PetListInitial extends PetListState {}

class PetListLoading extends PetListState {}

class PetListLoaded extends PetListState {
  final List<Pet> pets;
  final PetType? filter;
  PetListLoaded(this.pets, {this.filter});
}

class PetListError extends PetListState {
  final String message;
  PetListError(this.message);
}
