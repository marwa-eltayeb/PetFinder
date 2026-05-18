import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/favourites/domain/entities/favourite_entity.dart';
import 'package:petfinder/features/favourites/domain/repositories/favourite_repository.dart';

class GetFavouritesUseCase {
  final FavouritesRepository repository;

  GetFavouritesUseCase(this.repository);

  Future<List<FavouriteEntity>> call(PetType type) =>
      repository.getFavourites(type);
}
