import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/favourites/domain/entities/favourite_entity.dart';

abstract class FavouritesState {}

class FavouritesInitial extends FavouritesState {}

class FavouritesLoading extends FavouritesState {}

class FavouritesLoaded extends FavouritesState {
  final List<FavouriteEntity> favourites;
  final PetType? activeType;
  FavouritesLoaded({required this.favourites, this.activeType});
}

class FavouritesError extends FavouritesState {
  final String message;
  final PetType? activeType;
  FavouritesError(this.message, {this.activeType});
}
