import 'package:petfinder/features/favourites/domain/entities/favourite_entity.dart';

import '../repositories/favourite_repository.dart';
import '../../../../core/utils/pet_type.dart';

class AddFavouriteUseCase {
  final FavouritesRepository repository;

  AddFavouriteUseCase(this.repository);

  Future<FavouriteEntity> call(
    PetType type,
    String imageId,
    String subId,
    String name,
    String imageUrl,
    String origin,
  ) => repository.addFavourite(type, imageId, subId, name, imageUrl, origin);
}
