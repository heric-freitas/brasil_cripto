import 'package:hive/hive.dart';
part 'asset_history_model.g.dart';

@HiveType(typeId: 1)
class AssetHistoryModel {
  @HiveField(0)
  final double priceUsd;
  @HiveField(1)
  final int time;

  AssetHistoryModel({
    required this.priceUsd,
    required this.time,
  });

  factory AssetHistoryModel.fromJson(Map<String, dynamic> json) {
    return AssetHistoryModel(
      priceUsd: double.parse(json['priceUsd']),
      time: json['time'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'priceUsd': priceUsd.toString(),
      'time': time,
    };
  }
}