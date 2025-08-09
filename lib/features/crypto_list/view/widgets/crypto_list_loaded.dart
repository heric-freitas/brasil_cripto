import 'package:brasil_cripto/shared/widgets/crypto_asset_tile.dart';
import 'package:flutter/material.dart';
import 'package:brasil_cripto/models/crypto_asset_model.dart';

class CryptoListLoaded extends StatelessWidget {
  final List<CryptoAssetModel> assets;

  const CryptoListLoaded({super.key, required this.assets});

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) {
      return const Center(child: Text('Nenhuma criptomoeda encontrada.'));
    }
    return ListView.builder(
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final asset = assets[index];
        return CryptoAssetTile(asset: asset);
      },
    );
  }
}
