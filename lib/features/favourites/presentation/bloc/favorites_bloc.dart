import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petfinder/core/utils/pet_type.dart';
import 'package:petfinder/features/favourites/domain/use_cases/add_favourite_use_case.dart';
import 'package:petfinder/features/favourites/domain/use_cases/get_favourites_use_case.dart';
import 'package:petfinder/features/favourites/domain/use_cases/remove_favourite_use_case.dart';
import 'package:petfinder/features/favourites/presentation/bloc/favorites_event.dart';
import 'package:petfinder/features/favourites/presentation/bloc/favorites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  final GetFavouritesUseCase getFavouritesUseCase;
  final AddFavouriteUseCase addFavouriteUseCase;
  final RemoveFavouriteUseCase removeFavouriteUseCase;

  FavouritesBloc(this.getFavouritesUseCase, this.addFavouriteUseCase, this.removeFavouriteUseCase) : super(FavouritesInitial()) {
    on<LoadFavouritesEvent>(_onGetFavourites);
    on<AddFavouriteEvent>(_onAddFavourite);
    on<RemoveFavouriteEvent>(_onRemoveFavourite);
  }

  Future<void> _onGetFavourites(LoadFavouritesEvent event, Emitter<FavouritesState> emit,) async {
    const supportedTypes = {null, PetType.cat, PetType.dog};
    if (!supportedTypes.contains(event.type)) {
      emit(FavouritesLoaded(favourites: [], activeType: event.type));
      return;
    }

    emit(FavouritesLoading());
    try {
      if (event.type == null) {
        // Fetch both cats and dogs
        final cats = await getFavouritesUseCase(PetType.cat);
        final dogs = await getFavouritesUseCase(PetType.dog);
        emit(FavouritesLoaded(favourites: [...cats, ...dogs], activeType: null));
      } else {
        final favourites = await getFavouritesUseCase(event.type!);
        emit(FavouritesLoaded(favourites: favourites, activeType: event.type));
      }
    } catch (e) {
      emit(FavouritesError(e.toString(), activeType: event.type));
    }
  }

  Future<void> _onAddFavourite(AddFavouriteEvent event, Emitter<FavouritesState> emit) async {
    try {
      final newFavourite = await addFavouriteUseCase(
        event.type,
        event.imageId,
        event.petId,
        event.subId,
        event.name,
        event.imageUrl,
        event.origin,
      );

      if (state is FavouritesLoaded) {
        final current = state as FavouritesLoaded;
        final updatedFavourites = [...current.favourites, newFavourite];
        emit(FavouritesLoaded(favourites: updatedFavourites, activeType: current.activeType));
      } else {
        add(LoadFavouritesEvent(type: null));
      }
    } catch (e) {
      emit(FavouritesError(e.toString()));
    }
  }

  Future<void> _onRemoveFavourite(RemoveFavouriteEvent event, Emitter<FavouritesState> emit) async {
    try {
      await removeFavouriteUseCase(event.type, event.favouriteId);

      if (state is FavouritesLoaded) {
        final current = state as FavouritesLoaded;
        final updated = current.favourites.where((f) => f.id != event.favouriteId).toList();
        emit(FavouritesLoaded(favourites: updated, activeType: current.activeType));
      } else {
        add(LoadFavouritesEvent(type: null));
      }
    } catch (e) {
      emit(FavouritesError(e.toString()));
    }
  }

  bool isFavourite(String imageId, PetType type) {
    if (state is FavouritesLoaded) {
      final current = (state as FavouritesLoaded).favourites;
      return current.any((f) => f.imageId == imageId && f.type == type);
    }
    return false;
  }
}