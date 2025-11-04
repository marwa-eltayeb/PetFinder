import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/details/domain/entities/pet_details.dart';
import 'package:petfinder/features/details/domain/use_cases/get_pet_details_use_case.dart';
import 'package:petfinder/features/details/presentation/bloc/pet_details_bloc.dart';
import 'package:petfinder/features/details/presentation/bloc/pet_details_event.dart';
import 'package:petfinder/features/details/presentation/bloc/pet_details_states.dart';

import 'pet_details_bloc_test.mocks.dart';

@GenerateMocks([GetPetDetailsUseCase])
void main() {
  late PetDetailsBloc bloc;
  late MockGetPetDetailsUseCase mockGetPetDetailsUseCase;

  setUp(() {
    mockGetPetDetailsUseCase = MockGetPetDetailsUseCase();
    bloc = PetDetailsBloc(mockGetPetDetailsUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  group('LoadPetDetails', () {
    final tPetType = PetType.cat;
    final tId = '123';
    final tPetDetails = PetDetails(
      id: '123',
      name: 'Persian',
      type: PetType.cat,
      origin: 'Iran',
      temperament: 'Calm, Friendly',
      description: 'A beautiful long-haired cat breed',
      imageUrl: 'https://cdn2.thecatapi.com/images/test.jpg',
      weight: '3-5',
      lifeSpan: '12-17',
    );

    blocTest<PetDetailsBloc, PetDetailsState>('should emit [PetDetailsLoading, PetDetailsLoaded] when data is fetched successfully',
      build: () {
        when(mockGetPetDetailsUseCase(tPetType, tId))
            .thenAnswer((_) async => tPetDetails);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadPetDetails(tPetType, tId)),
      expect: () => [
        isA<PetDetailsLoading>(),
        isA<PetDetailsLoaded>()
            .having((state) => state.details.id, 'id', '123')
            .having((state) => state.details.name, 'name', 'Persian')
            .having((state) => state.details.type, 'type', PetType.cat),
      ],
      verify: (_) {
        verify(mockGetPetDetailsUseCase(tPetType, tId));
      },
    );

    blocTest<PetDetailsBloc, PetDetailsState>('should emit [PetDetailsLoading, PetDetailsError] when fetching fails',
      build: () {
        when(mockGetPetDetailsUseCase(tPetType, tId))
            .thenThrow(Exception('Failed to load'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadPetDetails(tPetType, tId)),
      expect: () => [
        isA<PetDetailsLoading>(),
        isA<PetDetailsError>()
            .having((state) => state.message, 'message', contains('Exception')),
      ],
    );

    test('initial state should be PetDetailsInitial', () {
      expect(bloc.state, isA<PetDetailsInitial>());
    });
  });
}