import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:brasil_cripto/models/crypto_asset_model.dart';

void main() {
  setUpAll(() async {
    await setUpTestHive();
    Hive.registerAdapter(CryptoAssetModelAdapter());
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  test('persists and reads CryptoAssetModel from Hive box', () async {
    final box = await Hive.openBox<CryptoAssetModel>('crypto_assets_box');
    final asset = CryptoAssetModel(
      id: 'bitcoin',
      rank: '1',
      symbol: 'BTC',
      name: 'Bitcoin',
      supply: '19700000',
      maxSupply: '21000000',
      marketCapUsd: '1200000000000',
      volumeUsd24Hr: '25000000000',
      priceUsd: '60000',
      changePercent24Hr: '1.23',
      vwap24Hr: '59500',
    );
    await box.put(asset.id, asset);
    final read = box.get('bitcoin');
    expect(read, isNotNull);
    expect(read!.id, 'bitcoin');
    expect(read.rank, '1');
    expect(read.symbol, 'BTC');
    expect(read.name, 'Bitcoin');
    expect(read.supply, '19700000');
    expect(read.maxSupply, '21000000');
    expect(read.marketCapUsd, '1200000000000');
    expect(read.volumeUsd24Hr, '25000000000');
    expect(read.priceUsd, '60000');
    expect(read.changePercent24Hr, '1.23');
    expect(read.vwap24Hr, '59500');
    await box.close();
  });

  test('overwrites value for same key', () async {
    final box = await Hive.openBox<CryptoAssetModel>('crypto_assets_box');
    final a1 = CryptoAssetModel(
      id: 'ethereum',
      rank: '2',
      symbol: 'ETH',
      name: 'Ethereum',
      supply: '120000000',
      maxSupply: '',
      marketCapUsd: '400000000000',
      volumeUsd24Hr: '15000000000',
      priceUsd: '3000',
      changePercent24Hr: '-0.5',
      vwap24Hr: '',
    );
    final a2 = CryptoAssetModel(
      id: 'ethereum',
      rank: '2',
      symbol: 'ETH',
      name: 'Ethereum',
      supply: '121000000',
      maxSupply: '',
      marketCapUsd: '410000000000',
      volumeUsd24Hr: '16000000000',
      priceUsd: '3100',
      changePercent24Hr: '0.2',
      vwap24Hr: '',
    );
    await box.put('ethereum', a1);
    await box.put('ethereum', a2);
    final read = box.get('ethereum');
    expect(read, isNotNull);
    expect(read!.supply, '121000000');
    expect(read.marketCapUsd, '410000000000');
    expect(read.priceUsd, '3100');
    await box.close();
  });
}
