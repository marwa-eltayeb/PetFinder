import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/details/data/datasources/pet_details_data_source.dart';
import '../../features/details/data/repositories/pet_details_repository_impl.dart';
import '../../features/details/domain/repositories/pet_details_repository.dart';
import '../../features/details/domain/use_cases/get_pet_details_use_case.dart';
import '../../features/details/presentation/bloc/pet_details_bloc.dart';
import '../../features/favourites/data/datsources/favourites_local_data_source.dart';
import '../../features/favourites/data/datsources/favourites_remote_data_source.dart';
import '../../features/favourites/data/repositories/favourite_repository_impl.dart';
import '../../features/favourites/domain/repositories/favourite_repository.dart';
import '../../features/favourites/presentation/bloc/favorites_bloc.dart';
import '../../features/home/data/datasources/pet_data_source.dart';
import '../../features/home/data/repositories/pet_repository_impl.dart';
import '../../features/home/domain/repositories/pet_repository.dart';
import '../../features/home/domain/use_cases/get_all_pets_use_case.dart';
import '../../features/home/domain/use_cases/search_pets_use_case.dart';
import '../../features/home/presentation/bloc/pet_list_bloc.dart';
import '../../features/favourites/domain/use_cases/get_favourites_use_case.dart';
import '../../features/favourites/domain/use_cases/add_favourite_use_case.dart';
import '../../features/favourites/domain/use_cases/remove_favourite_use_case.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> initAll() async {
  await initCore();
  await initPetList();
  await initPetDetails();
  await initFavourites();
}

Future<void> initCore() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
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
  sl.registerLazySingleton(() => GetPetDetailsUseCase(sl()));
  sl.registerFactory(() => PetDetailsBloc(sl()));
}

Future<void> initFavourites() async {
  sl.registerLazySingleton<FavouritesRemoteDataSource>(() => FavouritesDataSourceImpl(sl()));
  sl.registerLazySingleton<FavouritesLocalDataSource>(() => FavouritesLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<FavouritesRepository>(() => FavouritesRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetFavouritesUseCase(sl()));
  sl.registerLazySingleton(() => AddFavouriteUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFavouriteUseCase(sl()));
  sl.registerFactory(() => FavouritesBloc(sl(), sl(), sl()));
}