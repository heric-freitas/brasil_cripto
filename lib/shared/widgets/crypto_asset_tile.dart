import 'package:brasil_cripto/models/crypto_asset_model.dart';
import 'package:brasil_cripto/shared/utils/date_formatter.dart';
import 'package:brasil_cripto/shared/widgets/favorite_button.dart';
import 'package:flutter/material.dart';

class CryptoAssetTile extends StatelessWidget {
  final CryptoAssetModel asset;
  const CryptoAssetTile({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushNamed('/crypto-detail/', arguments: asset);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    asset.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FavoriteButton(
                    assetId: asset.id,
                  ), // USANDO O NOVO WIDGET AQUI
                ],
              ),
              Text(
                asset.symbol,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormatter.formatPrice(asset.priceUsd),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    DateFormatter.formatChangePercent(asset.changePercent24Hr),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: DateFormatter.getChangeColor(
                        asset.changePercent24Hr,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Volume 24h: ${DateFormatter.formatPrice(asset.volumeUsd24Hr)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
