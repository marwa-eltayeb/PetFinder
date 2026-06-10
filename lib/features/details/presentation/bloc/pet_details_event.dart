import 'package:petfinder/core/utils/pet_type.dart';

abstract class PetDetailsEvent {}

class LoadPetDetails extends PetDetailsEvent {
  final PetType type;
  final dynamic id;
  final String? imageId;
  final String? imageUrl;

  LoadPetDetails(this.type, this.id, {this.imageId, this.imageUrl});
}