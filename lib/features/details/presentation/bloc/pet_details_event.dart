import '../../../../core/utils/pet_type.dart';

abstract class PetDetailsEvent {}
class LoadPetDetails extends PetDetailsEvent {
  final PetType type;
  final dynamic id;
  LoadPetDetails(this.type, this.id);
}
