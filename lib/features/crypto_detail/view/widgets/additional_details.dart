import 'package:brasil_cripto/features/crypto_detail/view/widgets/detail_row.dart';
import 'package:brasil_cripto/models/crypto_asset_model.dart';
import 'package:brasil_cripto/shared/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class AdditionalDetails extends StatelessWidget {
  final CryptoAssetModel asset;
  const AdditionalDetails({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Outros Detalhes:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DetailRow(
              label: 'Oferta:',
              value: DateFormatter.formatPrice(asset.supply),
            ),
            DetailRow(
              label: 'Oferta Máxima:',
              value: DateFormatter.formatPrice(asset.maxSupply ?? ''),
            ),
            DetailRow(
              label: 'VWAP 24h:',
              value: DateFormatter.formatPrice(asset.vwap24Hr ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}
