import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../../features/home/data/datasources/pet_data_source.dart';
import '../../features/home/data/repositories/pet_repository_impl.dart';
import '../../features/home/domain/repositories/pet_repository.dart';
import '../../features/home/domain/use_cases/get_all_pets.dart';
import '../../features/home/presentation/bloc/pet_list_bloc.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> initAll() async {
  await initCore();
  await initPetList();
}

Future<void> initCore() async {
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioClient(sl()));
}

Future<void> initPetList() async {
  sl.registerLazySingleton<PetDataSource>(() => PetDataSourceImpl(sl()));
  sl.registerLazySingleton<PetRepository>(() => PetRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetAllPets(sl()));
  sl.registerFactory(() => PetListBloc(sl()));
}

