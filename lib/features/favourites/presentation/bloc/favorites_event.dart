import '../../../../core/utils/pet_type.dart';

abstract class FavouritesEvent {}

class LoadFavouritesEvent extends FavouritesEvent {
  final PetType? type;

  LoadFavouritesEvent({this.type});
}

class AddFavouriteEvent extends FavouritesEvent {
  final PetType type;
  final String imageId;
  final String subId;
  final String name;
  final String imageUrl;
  final String origin;

  AddFavouriteEvent({
    required this.type,
    required this.imageId,
    required this.subId,
    required this.name,
    required this.imageUrl,
    required this.origin,
  });
}

class RemoveFavouriteEvent extends FavouritesEvent {
  final PetType type;
  final int favouriteId;

  RemoveFavouriteEvent({required this.type, required this.favouriteId});
}
