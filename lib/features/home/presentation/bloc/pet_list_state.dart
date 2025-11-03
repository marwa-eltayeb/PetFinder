import '../../domain/entities/pet.dart';
import '../../../../core/utils/pet_type.dart';

abstract class PetListState {}

class PetListInitial extends PetListState {}

class PetListLoading extends PetListState {}

class PetListLoaded extends PetListState {
  final List<Pet> allPets;
  final List<Pet> filteredPets;
  final PetType? petType;
  final bool hasMoreData;

  PetListLoaded({
    required this.allPets,
    required this.filteredPets,
    this.petType,
    this.hasMoreData = false,
  });
}

class PetListLoadingMore extends PetListState {
  final List<Pet> allPets;
  final List<Pet> filteredPets;
  final PetType? petType;

  PetListLoadingMore({
    required this.allPets,
    required this.filteredPets,
    this.petType,
  });
}

class PetListError extends PetListState {
  final String message;
  PetListError(this.message);
}
