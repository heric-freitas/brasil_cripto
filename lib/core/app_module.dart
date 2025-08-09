import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:brasil_cripto/features/crypto_detail/view/crypto_detail_page.dart';
import 'package:brasil_cripto/features/main_navigation_shell/view/main_navigation_shell_page.dart';
import 'package:brasil_cripto/models/crypto_asset_model.dart';

class AppModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => '/';

  @override
  List<FlutterGetItModuleRouter> get pages => [
    FlutterGetItModuleRouter(
      name: '/main-shell',
      pages: [
        FlutterGetItPageRouter(
          name: '/',
          builder: (context) => const MainNavigationShellPage(),
        ),
      ],
    ),

    FlutterGetItModuleRouter(
      name: '/crypto-detail',
      pages: [
        FlutterGetItPageRouter(
          name: '/',
          builder: (context) {
            final args =
                ModalRoute.of(context)?.settings.arguments as CryptoAssetModel?;
            if (args == null) {
              return const Center(
                child: Text('Erro: Criptomoeda não encontrada.'),
              );
            }
            return CryptoDetailPage(asset: args);
          },
        ),
      ],
    ),
  ];
}
