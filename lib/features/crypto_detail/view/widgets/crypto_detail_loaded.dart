import 'package:brasil_cripto/features/crypto_detail/view/widgets/additional_details.dart';
import 'package:brasil_cripto/features/crypto_detail/view/widgets/asset_overview.dart';
import 'package:brasil_cripto/features/crypto_detail/view/widgets/price_chart.dart';
import 'package:brasil_cripto/models/asset_history_model.dart';
import 'package:brasil_cripto/models/crypto_asset_model.dart';
import 'package:brasil_cripto/shared/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class CryptoDetailLoadedWidget extends StatelessWidget {
  final CryptoAssetModel asset;
  final List<AssetHistoryModel> history;
  const CryptoDetailLoadedWidget({
    super.key,
    required this.asset,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AssetOverview(asset: asset),
          const SizedBox(height: 20),
          Text(
            'Histórico de Preço (${history.isNotEmpty ? DateFormatter.formatTimestamp(history.first.time) : 'N/A'} - ${history.isNotEmpty ? DateFormatter.formatTimestamp(history.last.time) : 'N/A'})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          PriceChart(history: history),
          const SizedBox(height: 20),
          AdditionalDetails(asset: asset),
        ],
      ),
    );
  }
}
