import 'package:brasil_cripto/features/crypto_detail/view/widgets/detail_row.dart';
import 'package:brasil_cripto/models/crypto_asset_model.dart';
import 'package:brasil_cripto/shared/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class AssetOverview extends StatelessWidget {
  final CryptoAssetModel asset;

  const AssetOverview({super.key, required this.asset});

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
            Text(
              asset.symbol,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    DateFormatter.formatPrice(asset.priceUsd),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  DateFormatter.formatChangePercent(asset.changePercent24Hr),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: DateFormatter.getChangeColor(
                      asset.changePercent24Hr,
                    ),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
            const SizedBox(height: 10),
            DetailRow(label: 'Rank:', value: asset.rank),
            DetailRow(
              label: 'Capitalização de Mercado:',
              value: DateFormatter.formatPrice(asset.marketCapUsd),
            ),
            DetailRow(
              label: 'Volume (24h):',
              value: DateFormatter.formatPrice(asset.volumeUsd24Hr),
            ),
          ],
        ),
      ),
    );
  }
}
