import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  static String formatTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(dateTime);
  }

  static String formatPrice(String priceUsd) {
    try {
      final double price = double.parse(priceUsd);
      final NumberFormat currencyFormatter = NumberFormat.currency(
        locale: 'pt_BR',
        symbol: 'R\$',
        decimalDigits: price < 0.01 ? 8 : 2,
      );
      return currencyFormatter.format(price);
    } catch (e) {
      return priceUsd;
    }
  }

  static String formatChangePercent(String changePercent24Hr) {
    try {
      final double percent = double.parse(changePercent24Hr);
      final String sign = percent > 0 ? '+' : '';
      return '$sign${percent.toStringAsFixed(2)}%';
    } catch (e) {
      return changePercent24Hr;
    }
  }

  static Color getChangeColor(String changePercent24Hr) {
    try {
      final double percent = double.parse(changePercent24Hr);
      if (percent > 0) {
        return Colors.green;
      } else if (percent < 0) {
        return Colors.red;
      } else {
        return Colors.grey;
      }
    } catch (e) {
      return Colors.grey;
    }
  }
}
