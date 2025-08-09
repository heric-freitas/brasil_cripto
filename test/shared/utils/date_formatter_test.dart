// test/date_formatter_test.dart
import 'package:brasil_cripto/shared/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateFormatter', () {
    test('formatTimestamp returns expected string', () {
      final ts = DateTime(2023, 1, 2, 3, 4).millisecondsSinceEpoch;
      final formatted = DateFormatter.formatTimestamp(ts);
      expect(formatted, '02/01/2023 03:04');
    });

    test('formatPrice returns original on invalid input', () {
      expect(DateFormatter.formatPrice('abc'), 'abc');
    });

    test('formatChangePercent formats with sign and 2 decimals', () {
      expect(DateFormatter.formatChangePercent('1.2345'), '+1.23%');
      expect(DateFormatter.formatChangePercent('-0.9876'), '-0.99%');
      expect(DateFormatter.formatChangePercent('0'), '0.00%');
    });

    test('formatChangePercent returns original on invalid input', () {
      expect(DateFormatter.formatChangePercent('xyz'), 'xyz');
    });

    test('getChangeColor returns correct color', () {
      expect(DateFormatter.getChangeColor('1.0'), Colors.green);
      expect(DateFormatter.getChangeColor('-0.1'), Colors.red);
      expect(DateFormatter.getChangeColor('0'), Colors.grey);
    });

    test('getChangeColor returns grey on invalid input', () {
      expect(DateFormatter.getChangeColor('invalid'), Colors.grey);
    });
  });
}
