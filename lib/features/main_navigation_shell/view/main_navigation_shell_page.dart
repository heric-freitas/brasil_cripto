import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:brasil_cripto/features/crypto_list/view/crypto_list_page.dart';
import 'package:brasil_cripto/features/favorite_crypto_view/view/favorite_crypto_list_page.dart';
import 'package:brasil_cripto/shared/favorites/bloc/favorite_bloc.dart';
import 'package:brasil_cripto/shared/favorites/bloc/favorite_event.dart';

class MainNavigationShellPage extends StatefulWidget {
  const MainNavigationShellPage({super.key});

  @override
  State<MainNavigationShellPage> createState() =>
      _MainNavigationShellPageState();
}

class _MainNavigationShellPageState extends State<MainNavigationShellPage> {
  final _internalNavKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;
  final List<String> _tabRoutes = ['/list', '/favorites'];

  @override
  void initState() {
    super.initState();
    Injector.get<FavoriteBloc>().add(LoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterGetIt.navigator(
        name: 'mainTabNav',
        pagesRouter: [
          FlutterGetItPageRouter(
            name: '/list',
            builder: (context) => const CryptoListPage(),
          ),
          FlutterGetItPageRouter(
            name: '/favorites',
            builder: (context) => const FavoriteCryptoListPage(),
          ),
        ],
        builder: (context, routes, isReady) => Navigator(
          key: _internalNavKey,
          initialRoute: _tabRoutes[_currentIndex],
          observers: const [],
          onGenerateRoute: (settings) {
            final routeBuilder = routes[settings.name];
            if (routeBuilder != null) {
              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) =>
                    routeBuilder(context),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
              );
            }
            return MaterialPageRoute(
              builder: (context) =>
                  const Center(child: Text('Erro: Rota não encontrada!')),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _internalNavKey.currentState?.pushNamedAndRemoveUntil(
            _tabRoutes[index],
            (route) => false,
          );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Todas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritas',
          ),
        ],
      ),
    );
  }
}
