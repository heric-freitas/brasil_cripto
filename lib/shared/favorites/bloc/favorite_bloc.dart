import 'package:bloc/bloc.dart';
import 'package:brasil_cripto/services/local_storage_service.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final LocalStorageService _localStorageService;

  FavoriteBloc(this._localStorageService) : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoading());
    try {
      final favoriteIds = _localStorageService.getFavoriteAssetIds();
      emit(FavoritesLoaded(favoriteIds));
    } catch (e) {
      emit(FavoriteError('Falha ao carregar favoritos: ${e.toString()}'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      if (event.isFavorite) {
        await _localStorageService.addFavorite(event.assetId);
      } else {
        await _localStorageService.removeFavorite(event.assetId);
      }
      final favoriteIds = _localStorageService.getFavoriteAssetIds();
      emit(FavoritesLoaded(favoriteIds));
      emit(
        FavoriteActionSuccess(
          assetId: event.assetId,
          isFavorite: event.isFavorite,
        ),
      );
    } catch (e) {
      emit(FavoriteError('Falha ao alternar favorito: ${e.toString()}'));
    }
  }

  bool isAssetFavorite(String assetId) {
    if (state is FavoritesLoaded) {
      return (state as FavoritesLoaded).favoriteAssetIds.contains(assetId);
    }
    return _localStorageService.isFavorite(assetId);
  }
}
