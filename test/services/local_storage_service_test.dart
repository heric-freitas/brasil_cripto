import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:brasil_cripto/services/local_storage_service.dart';
import 'package:hive/hive.dart';

import 'package:brasil_cripto/models/crypto_asset_model.dart';
import 'package:brasil_cripto/models/asset_history_model.dart';

class _FakePathProviderPlatform extends PathProviderPlatform {
  _FakePathProviderPlatform(this._applicationDocumentsPath);

  final String _applicationDocumentsPath;

  @override
  Future<String?> getApplicationDocumentsPath() async {
    return _applicationDocumentsPath;
  }
}

CryptoAssetModel makeCryptoAsset({
  required String id,
  String? name,
  String? symbol,
}) {
  throw UnimplementedError(
    'Ajuste o helper makeCryptoAsset conforme o seu modelo.',
  );
}

AssetHistoryModel makeAssetHistory({
  required int time,
  required String priceUsd,
}) {
  throw UnimplementedError(
    'Ajuste o helper makeAssetHistory conforme o seu modelo.',
  );
}

void main() {
  late Directory tempDir;
  late LocalStorageService service;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    tempDir = await Directory.systemTemp.createTemp('brasil_cripto_hive_test_');

    PathProviderPlatform.instance = _FakePathProviderPlatform(tempDir.path);

    service = LocalStorageService();
    await service.init();
  });

  tearDown(() async {
    await Hive.close();
    await service.openCryptoAssetsBox();
    await service.openFavoritesBox();
  });

  tearDownAll(() async {
    try {
      await Hive.deleteFromDisk();
    } catch (_) {}
    try {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    } catch (_) {}
  });

  group('init()', () {
    test('deve abrir cryptoAssetsBox e favoritesBox', () async {
      expect(Hive.isBoxOpen('cryptoAssetsBox'), isTrue);
      expect(Hive.isBoxOpen('favoritesBox'), isTrue);
    });
  });

  group('Favoritos', () {
    test(
      'addFavorite / isFavorite / getFavoriteAssetIds / removeFavorite',
      () async {
        const String assetId = 'bitcoin';

        if (Hive.isBoxOpen('favoritesBox')) {
          final box = Hive.box<String>('favoritesBox');
          await box.clear();
        }

        await service.addFavorite(assetId);
        expect(service.isFavorite(assetId), isTrue);

        final favs = service.getFavoriteAssetIds();
        expect(favs.contains(assetId), isTrue);

        await service.removeFavorite(assetId);
        expect(service.isFavorite(assetId), isFalse);
        final favsAfter = service.getFavoriteAssetIds();
        expect(favsAfter.contains(assetId), isFalse);
      },
    );
  });

  group('CryptoAssets (persistência local)', () {
    test('saveCryptoAssets / getCryptoAssets / getCryptoAssetById', () async {
      final assetA = CryptoAssetModel(
        id: 'btc',
        name: 'Bitcoin',
        symbol: 'BTC',
        priceUsd: '100.0',
        changePercent24Hr: '0.0',
        marketCapUsd: '1000000000000',
        volumeUsd24Hr: '10000000000',
        rank: '',
        supply: '',
      );
      final assetB = CryptoAssetModel(
        id: 'eth',
        name: 'Ethereum',
        symbol: 'ETH',
        priceUsd: '200.0',
        changePercent24Hr: '0.0',
        marketCapUsd: '2000000000000',
        volumeUsd24Hr: '20000000000',
        rank: '',
        supply: '',
      );

      await service.saveCryptoAssets([assetA, assetB]);

      final list = await service.getCryptoAssets();
      expect(list.length, 2);

      final gotBtc = service.getCryptoAssetById('btc');
      final gotEth = service.getCryptoAssetById('eth');

      expect(gotBtc, isNotNull);
      expect(gotEth, isNotNull);
    });
  });

  group('AssetHistory (BUG de nomenclatura de box)', () {
    test(
      'saveAssetHistory cria "history_<assetId>_box" e getAssetHistory lê "assetHistoryBox_<assetId>"',
      () async {
        const assetId = 'btc';

        if (Hive.isBoxOpen('history_${assetId}_box')) {
          await Hive.box('history_${assetId}_box').clear();
          await Hive.box('history_${assetId}_box').close();
        }
        if (Hive.isBoxOpen('assetHistoryBox_$assetId')) {
          await Hive.box('assetHistoryBox_$assetId').clear();
          await Hive.box('assetHistoryBox_$assetId').close();
        }

        final h1 = AssetHistoryModel(time: 1000, priceUsd: 100.0);
        final h2 = AssetHistoryModel(time: 2000, priceUsd: 200.0);

        await service.saveAssetHistory(assetId, [h1, h2]);

        final read = await service.getAssetHistory(assetId);

        expect(read, isEmpty);

        final altBox = await Hive.openBox<AssetHistoryModel>(
          'history_${assetId}_box',
        );
        expect(altBox.values.length, 2);
        await altBox.close();
      },
    );
  });
}
