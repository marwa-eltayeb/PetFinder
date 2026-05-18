import 'package:petfinder/features/favourites/domain/entities/favourite_entity.dart';

abstract class FavouritesState {}

class FavouritesInitial extends FavouritesState {}

class FavouritesLoading extends FavouritesState {}

class FavouritesLoaded extends FavouritesState {
  final List<FavouriteEntity> favourites;

  FavouritesLoaded({required this.favourites});
}

class FavouritesError extends FavouritesState {
  final String message;
  FavouritesError(this.message);
}
