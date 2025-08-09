import 'package:bloc/bloc.dart';
import 'package:brasil_cripto/models/crypto_asset_model.dart';
import 'package:brasil_cripto/services/api_service.dart';
import 'package:brasil_cripto/services/local_storage_service.dart';
import 'crypto_event.dart';
import 'crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final ApiService _apiService;
  final LocalStorageService _localStorageService;

  CryptoBloc(this._apiService, this._localStorageService)
    : super(CryptoInitial()) {
    on<LoadCryptoAssets>(_onLoadCryptoAssets);
  }

  Future<void> _onLoadCryptoAssets(
    LoadCryptoAssets event,
    Emitter<CryptoState> emit,
  ) async {
    emit(CryptoLoading());

    List<CryptoAssetModel> cachedAssets = [];
    if (event.searchTerm == null || event.searchTerm!.isEmpty) {
      cachedAssets = await _localStorageService.getCryptoAssets();
      if (cachedAssets.isNotEmpty) {
        emit(CryptoLoaded(cachedAssets, fromCache: true));
      }
    }

    try {
      final List<CryptoAssetModel> assets = await _apiService.getAssets(
        search: event.searchTerm,
      );
      if (event.searchTerm == null || event.searchTerm!.isEmpty) {
        await _localStorageService.saveCryptoAssets(assets);
      }
      emit(CryptoLoaded(assets));
    } catch (e) {
      if (cachedAssets.isNotEmpty) {
        emit(
          CryptoLoaded(
            cachedAssets,
            fromCache: true,
            updateErrorMessage:
                'Falha ao carregar dados atualizados: ${e.toString()}',
          ),
        );
      } else {
        emit(CryptoError('Falha ao carregar criptomoedas: ${e.toString()}'));
      }
    }
  }
}
