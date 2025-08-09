import 'package:brasil_cripto/features/favorite_crypto_view/bloc/favorite_crypto_view_event.dart';
import 'package:brasil_cripto/shared/widgets/crypto_asset_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:brasil_cripto/features/favorite_crypto_view/bloc/favorite_crypto_view_bloc.dart';
import 'package:brasil_cripto/features/favorite_crypto_view/bloc/favorite_crypto_view_state.dart';
import 'package:brasil_cripto/shared/widgets/error_message_widget.dart';

class FavoriteCryptoListPage extends StatefulWidget {
  const FavoriteCryptoListPage({super.key});

  @override
  State<FavoriteCryptoListPage> createState() => _FavoriteCryptoListPageState();
}

class _FavoriteCryptoListPageState extends State<FavoriteCryptoListPage> {
  late final FavoriteCryptoViewBloc _favoriteCryptoViewBloc;

  @override
  void initState() {
    super.initState();
    _favoriteCryptoViewBloc = Injector.get<FavoriteCryptoViewBloc>();
    _favoriteCryptoViewBloc.add(LoadFavoriteCryptoAssets());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Criptomoedas Favoritas'),
        centerTitle: true,
      ),
      body: BlocBuilder<FavoriteCryptoViewBloc, FavoriteCryptoViewState>(
        bloc: _favoriteCryptoViewBloc,
        builder: (context, viewState) {
          if (viewState is FavoriteCryptoViewLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewState is FavoriteCryptoViewLoaded) {
            final favoriteAssets = viewState.favoriteAssets;

            if (favoriteAssets.isEmpty) {
              return const Center(
                child: Text('Você não tem criptomoedas favoritas ainda.'),
              );
            }

            return ListView.builder(
              itemCount: favoriteAssets.length,
              itemBuilder: (context, index) {
                final asset = favoriteAssets[index];
                return CryptoAssetTile(asset: asset);
              },
            );
          } else if (viewState is FavoriteCryptoViewError) {
            return ErrorMessageWidget(
              message: viewState.message,
              onRetry: () =>
                  _favoriteCryptoViewBloc.add(LoadFavoriteCryptoAssets()),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
