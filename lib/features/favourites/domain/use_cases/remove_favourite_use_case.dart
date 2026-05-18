import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/favourites/domain/repositories/favourite_repository.dart';

class RemoveFavouriteUseCase {
  final FavouritesRepository repository;

  RemoveFavouriteUseCase(this.repository);

  Future<void> call(PetType type, int id) =>
      repository.removeFavourite(type, id);
}
