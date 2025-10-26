import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../features/details/data/datasources/pet_details_data_source.dart';
import '../../features/details/data/repositories/pet_details_repository_impl.dart';
import '../../features/details/domain/repositories/pet_details_repository.dart';
import '../../features/details/domain/use_cases/get_pet_details.dart';
import '../../features/details/presentation/bloc/pet_details_bloc.dart';
import '../../features/home/data/datasources/pet_data_source.dart';
import '../../features/home/data/repositories/pet_repository_impl.dart';
import '../../features/home/domain/repositories/pet_repository.dart';
import '../../features/home/domain/use_cases/get_all_pets_use_case.dart';
import '../../features/home/domain/use_cases/search_pets_use_case.dart';
import '../../features/home/presentation/bloc/pet_list_bloc.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> initAll() async {
  await initCore();
  await initPetList();
  await initPetDetails();
}

Future<void> initCore() async {
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioClient(sl()));
}

Future<void> initPetList() async {
  sl.registerLazySingleton<PetDataSource>(() => PetDataSourceImpl(sl()));
  sl.registerLazySingleton<PetRepository>(() => PetRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetAllPetsUseCase(sl()));
  sl.registerLazySingleton(() => SearchPetsUseCase(sl()));
  sl.registerFactory(() => PetListBloc(sl(), sl()));
}

Future<void> initPetDetails() async {
  sl.registerLazySingleton<PetDetailsDataSource>(() => PetDetailsDataSourceImpl(sl()));
  sl.registerLazySingleton<PetDetailsRepository>(() => PetDetailsRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetPetDetails(sl()));
  sl.registerFactory(() => PetDetailsBloc(sl()));
}