import 'package:brasil_cripto/features/crypto_list/view/widgets/crypto_list_loaded.dart';
import 'package:brasil_cripto/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:brasil_cripto/features/crypto_list/bloc/crypto_bloc.dart';
import 'package:brasil_cripto/features/crypto_list/bloc/crypto_event.dart';
import 'package:brasil_cripto/features/crypto_list/bloc/crypto_state.dart';
import 'package:brasil_cripto/shared/widgets/error_message_widget.dart';
import 'package:brasil_cripto/shared/widgets/search_bar_widget.dart';
import 'dart:async';

class CryptoListPage extends StatefulWidget {
  const CryptoListPage({super.key});

  @override
  State<CryptoListPage> createState() => _CryptoListPageState();
}

class _CryptoListPageState extends State<CryptoListPage> {
  late final CryptoBloc _cryptoBloc;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _cryptoBloc = Injector.get<CryptoBloc>();
    _cryptoBloc.add(const LoadCryptoAssets());
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (value.isEmpty) {
        _cryptoBloc.add(const LoadCryptoAssets(searchTerm: null));
      } else {
        _cryptoBloc.add(LoadCryptoAssets(searchTerm: value));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BrasilCripto'),
        centerTitle: true,
        bottom: SearchBarWidget(
          controller: _searchController,
          focusNode: _searchFocusNode,
          hintText: 'Buscar criptomoedas...',
          onChanged: _onSearchChanged,
        ),
      ),
      body: BlocConsumer<CryptoBloc, CryptoState>(
        bloc: _cryptoBloc,
        listener: (context, state) {
          if (state is CryptoLoaded && state.updateErrorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Atenção: ${state.updateErrorMessage!}'),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) => switch (state) {
          CryptoLoading() => LoadingWidget(),
          CryptoLoaded(:final assets) => CryptoListLoaded(assets: assets),
          CryptoError(:final message) => ErrorMessageWidget(
            message: message,
            onRetry: () => _cryptoBloc.add(const LoadCryptoAssets()),
          ),
          _ => const Center(
            child: Text('Aguardando carregamento de criptomoedas...'),
          ),
        },
      ),
    );
  }
}
