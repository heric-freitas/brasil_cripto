import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:brasil_cripto/models/crypto_asset_model.dart';
import 'package:brasil_cripto/models/asset_history_model.dart';

class LocalStorageService {
  static const String _cryptoAssetsBox = 'cryptoAssetsBox';
  static const String _assetHistoryBoxPrefix = 'assetHistoryBox_';
  static const String _favoritesBox = 'favoritesBox';

  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    Hive.registerAdapter(CryptoAssetModelAdapter());
    Hive.registerAdapter(AssetHistoryModelAdapter());

    await openCryptoAssetsBox();
    await openFavoritesBox();
  }

  Future<Box<CryptoAssetModel>> openCryptoAssetsBox() async {
    return await Hive.openBox<CryptoAssetModel>(_cryptoAssetsBox);
  }

  Future<Box<String>> openFavoritesBox() async {
    return await Hive.openBox<String>(_favoritesBox);
  }

  Future<Box<AssetHistoryModel>> openAssetHistoryBox(String assetId) async {
    return await Hive.openBox<AssetHistoryModel>(
      '$_assetHistoryBoxPrefix$assetId',
    );
  }

  Future<void> saveCryptoAssets(List<CryptoAssetModel> assets) async {
    final box = await openCryptoAssetsBox();
    await box.clear();
    for (var asset in assets) {
      await box.put(asset.id, asset);
    }
  }

  Future<List<CryptoAssetModel>> getCryptoAssets() async {
    final box = await openCryptoAssetsBox();
    return box.values.toList();
  }

  CryptoAssetModel? getCryptoAssetById(String id) {
    final box = Hive.box<CryptoAssetModel>(_cryptoAssetsBox);
    return box.get(id);
  }

  Future<void> saveAssetHistory(
    String assetId,
    List<AssetHistoryModel> history,
  ) async {
    final historyBox = await Hive.openBox<AssetHistoryModel>(
      'history_${assetId}_box',
    );
    await historyBox.clear();
    await historyBox.addAll(history);
    await historyBox.close();
  }

  Future<List<AssetHistoryModel>> getAssetHistory(String assetId) async {
    try {
      final historyBox = await openAssetHistoryBox(assetId);
      return historyBox.values.toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addFavorite(String assetId) async {
    final box = Hive.box<String>(_favoritesBox);
    await box.put(assetId, assetId);
  }

  Future<void> removeFavorite(String assetId) async {
    final box = Hive.box<String>(_favoritesBox);
    await box.delete(assetId);
  }

  bool isFavorite(String assetId) {
    final box = Hive.box<String>(_favoritesBox);
    return box.containsKey(assetId);
  }

  List<String> getFavoriteAssetIds() {
    final box = Hive.box<String>(_favoritesBox);
    return box.values.toList();
  }
}
