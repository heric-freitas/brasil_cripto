import 'package:bloc/bloc.dart';
import 'package:brasil_cripto/models/crypto_asset_model.dart';
import 'package:brasil_cripto/models/asset_history_model.dart';
import 'package:brasil_cripto/services/api_service.dart';
import 'package:brasil_cripto/services/local_storage_service.dart';
import 'crypto_detail_event.dart';
import 'crypto_detail_state.dart';

class CryptoDetailBloc extends Bloc<CryptoDetailEvent, CryptoDetailState> {
  final ApiService _apiService;
  final LocalStorageService _localStorageService;

  CryptoDetailBloc(this._apiService, this._localStorageService)
    : super(CryptoDetailInitial()) {
    on<LoadCryptoDetail>(_onLoadCryptoDetail);
  }

  Future<void> _onLoadCryptoDetail(
    LoadCryptoDetail event,
    Emitter<CryptoDetailState> emit,
  ) async {
    emit(CryptoDetailLoading());

    CryptoAssetModel? cachedAsset;
    List<AssetHistoryModel> cachedHistory = [];

    cachedAsset = _localStorageService.getCryptoAssetById(event.assetId);
    cachedHistory = await _localStorageService.getAssetHistory(event.assetId);

    if (cachedAsset != null && cachedHistory.isNotEmpty) {
      emit(CryptoDetailLoaded(asset: cachedAsset, history: cachedHistory));
    }

    try {
      final asset = await _apiService.getAssetById(event.assetId);
      final history = await _apiService.getAssetHistory(event.assetId);

      await _localStorageService.saveCryptoAssets([asset]);
      await _localStorageService.saveAssetHistory(asset.id, history);

      emit(CryptoDetailLoaded(asset: asset, history: history));
    } catch (e) {
      if (cachedAsset != null && cachedHistory.isNotEmpty) {
        emit(
          CryptoDetailLoaded(
            asset: cachedAsset,
            history: cachedHistory,
            updateErrorMessage:
                'Falha ao carregar dados atualizados: ${e.toString()}',
          ),
        );
      } else {
        emit(CryptoDetailError('Falha ao carregar detalhes: ${e.toString()}'));
      }
    }
  }
}
