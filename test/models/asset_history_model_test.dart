import 'package:flutter_test/flutter_test.dart';
import 'package:brasil_cripto/models/asset_history_model.dart';

void main() {
  group('AssetHistoryModel', () {
    test('fromJson parses values correctly', () {
      final json = {'priceUsd': '123.45', 'time': 1720000000};
      final model = AssetHistoryModel.fromJson(json);
      expect(model.priceUsd, 123.45);
      expect(model.time, 1720000000);
    });

    test('toJson serializes values correctly', () {
      final model = AssetHistoryModel(priceUsd: 987.65, time: 1720001234);
      final json = model.toJson();
      expect(json['priceUsd'], '987.65');
      expect(json['time'], 1720001234);
    });

    test('fromJson throws on invalid priceUsd', () {
      final json = {'priceUsd': 'invalid', 'time': 1};
      expect(() => AssetHistoryModel.fromJson(json), throwsA(isA<FormatException>()));
    });
  });
}