import 'package:hive/hive.dart';
part 'crypto_asset_model.g.dart';

@HiveType(typeId: 0)
class CryptoAssetModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String rank;
  @HiveField(2)
  final String symbol;
  @HiveField(3)
  final String name;
  @HiveField(4)
  final String supply;
  @HiveField(5)
  final String? maxSupply;
  @HiveField(6)
  final String marketCapUsd;
  @HiveField(7)
  final String volumeUsd24Hr;
  @HiveField(8)
  final String priceUsd;
  @HiveField(9)
  final String changePercent24Hr;
  @HiveField(10)
  final String? vwap24Hr;

  CryptoAssetModel({
    required this.id,
    required this.rank,
    required this.symbol,
    required this.name,
    required this.supply,
    this.maxSupply,
    required this.marketCapUsd,
    required this.volumeUsd24Hr,
    required this.priceUsd,
    required this.changePercent24Hr,
    this.vwap24Hr,
  });

  factory CryptoAssetModel.fromJson(Map<String, dynamic> json) {
    return CryptoAssetModel(
      id: json['id'] as String? ?? '',
      rank: json['rank'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
      name: json['name'] as String? ?? '',
      supply: json['supply'] as String? ?? '',
      maxSupply: json['maxSupply'] as String? ?? '',
      marketCapUsd: json['marketCapUsd'] as String? ?? '',
      volumeUsd24Hr: json['volumeUsd24Hr'] as String? ?? '',
      priceUsd: json['priceUsd'] as String? ?? '',
      changePercent24Hr: json['changePercent24Hr'] as String? ?? '',
      vwap24Hr: json['vwap24Hr'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rank': rank,
      'symbol': symbol,
      'name': name,
      'supply': supply,
      'maxSupply': maxSupply,
      'marketCapUsd': marketCapUsd,
      'volumeUsd24Hr': volumeUsd24Hr,
      'priceUsd': priceUsd,
      'changePercent24Hr': changePercent24Hr,
      'vwap24Hr': vwap24Hr,
    };
  }
}
