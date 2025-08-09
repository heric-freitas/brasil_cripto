import 'package:bloc/bloc.dart';
import 'package:brasil_cripto/shared/favorites/bloc/favorite_bloc.dart';
import 'package:brasil_cripto/shared/favorites/bloc/favorite_state.dart';
import 'package:brasil_cripto/services/api_service.dart';
import 'favorite_crypto_view_event.dart';
import 'favorite_crypto_view_state.dart';

class FavoriteCryptoViewBloc
    extends Bloc<FavoriteCryptoViewEvent, FavoriteCryptoViewState> {
  final FavoriteBloc _favoriteBloc;
  final ApiService _apiService;

  FavoriteCryptoViewBloc(this._favoriteBloc, this._apiService)
    : super(FavoriteCryptoViewInitial()) {
    on<LoadFavoriteCryptoAssets>(_onLoadFavoriteCryptoAssets);

    _favoriteBloc.stream.listen((favoriteState) {
      if (favoriteState is FavoritesLoaded) {
        add(LoadFavoriteCryptoAssets());
      }
    });
  }

  Future<void> _onLoadFavoriteCryptoAssets(
    LoadFavoriteCryptoAssets event,
    Emitter<FavoriteCryptoViewState> emit,
  ) async {
    final currentFavoriteIds = _favoriteBloc.state is FavoritesLoaded
        ? (_favoriteBloc.state as FavoritesLoaded).favoriteAssetIds
        : <String>[];

    if (currentFavoriteIds.isEmpty) {
      emit(const FavoriteCryptoViewLoaded([]));
      return;
    }

    emit(FavoriteCryptoViewLoading());

    try {
      final allAssets = await _apiService.getAssets();

      final favoriteAssets = allAssets
          .where((asset) => currentFavoriteIds.contains(asset.id))
          .toList();

      emit(FavoriteCryptoViewLoaded(favoriteAssets));
    } catch (e) {
      emit(
        FavoriteCryptoViewError(
          'Falha ao carregar criptomoedas favoritas: ${e.toString()}',
        ),
      );
    }
  }
}
