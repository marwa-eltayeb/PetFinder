import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/home/domain/entities/pet.dart';

abstract class PetListState {}

class PetListInitial extends PetListState {}

class PetListLoading extends PetListState {}

class PetListLoaded extends PetListState {
  final List<PetEntity> allPets;
  final List<PetEntity> filteredPets;
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
  final List<PetEntity> allPets;
  final List<PetEntity> filteredPets;
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
