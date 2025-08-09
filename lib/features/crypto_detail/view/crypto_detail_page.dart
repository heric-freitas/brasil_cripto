import 'package:brasil_cripto/features/crypto_detail/view/widgets/crypto_detail_loaded.dart';
import 'package:brasil_cripto/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:brasil_cripto/features/crypto_detail/bloc/crypto_detail_bloc.dart';
import 'package:brasil_cripto/features/crypto_detail/bloc/crypto_detail_event.dart';
import 'package:brasil_cripto/features/crypto_detail/bloc/crypto_detail_state.dart';
import 'package:brasil_cripto/models/crypto_asset_model.dart';
import 'package:brasil_cripto/shared/widgets/error_message_widget.dart';
import 'package:brasil_cripto/shared/widgets/favorite_button.dart';

class CryptoDetailPage extends StatefulWidget {
  final CryptoAssetModel asset;

  const CryptoDetailPage({super.key, required this.asset});

  @override
  State<CryptoDetailPage> createState() => _CryptoDetailPageState();
}

class _CryptoDetailPageState extends State<CryptoDetailPage> {
  late final CryptoDetailBloc _cryptoDetailBloc;

  @override
  void initState() {
    super.initState();
    _cryptoDetailBloc = Injector.get<CryptoDetailBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cryptoDetailBloc.add(LoadCryptoDetail(assetId: widget.asset.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.asset.name),
        centerTitle: true,
        actions: [
          FavoriteButton(assetId: widget.asset.id, color: Colors.white),
        ],
      ),
      body: BlocBuilder<CryptoDetailBloc, CryptoDetailState>(
        bloc: _cryptoDetailBloc,
        builder: (context, state) => switch (state) {
          CryptoDetailLoading() => LoadingWidget(),
          CryptoDetailLoaded(:final asset, :final history) =>
            CryptoDetailLoadedWidget(asset: asset, history: history),
          CryptoDetailError(:final message) => ErrorMessageWidget(
            message: message,
            onRetry: () => _cryptoDetailBloc.add(
              LoadCryptoDetail(assetId: widget.asset.id),
            ),
          ),
          _ => LoadingWidget(),
        },
      ),
    );
  }
}
