enum PetType { cat, dog, bird, fish, reptile }

extension PetTypeExtension on PetType {
  String get displayName {
    switch (this) {
      case PetType.cat: return 'Cats';
      case PetType.dog: return 'Dogs';
      case PetType.bird: return 'Birds';
      case PetType.fish: return 'Fish';
      case PetType.reptile: return 'Reptiles';
    }
  }
}