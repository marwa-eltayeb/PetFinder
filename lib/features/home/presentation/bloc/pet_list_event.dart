import '../../../../core/utils/pet_type.dart';

abstract class PetListEvent {}

class LoadPets extends PetListEvent {
  final PetType? type;
  final int limit;
  final int page;

  LoadPets({this.type, this.limit = 10, this.page = 0});
}

class LoadMorePets extends PetListEvent {
  final PetType? type;
  final int limit;

  LoadMorePets({this.type, this.limit = 10});
}

class SearchPets extends PetListEvent {
  final String query;
  final PetType? type;
  SearchPets(this.query, {this.type});
}

class FilterPets extends PetListEvent {
  final String? origin;
  final String? temperament;
  final PetType? type;

  FilterPets({this.origin, this.temperament, this.type});
}