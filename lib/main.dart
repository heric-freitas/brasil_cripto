import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:brasil_cripto/core/app_bindings.dart';
import 'package:brasil_cripto/core/app_module.dart';
import 'package:brasil_cripto/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalStorageService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      bindings: MyApplicationBindings(),
      modules: [AppModule()],
      builder: (context, routes, isReady) {
        return MaterialApp(
          title: 'BrasilCripto',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              elevation: 4,
            ),
            cardTheme: CardThemeData(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          initialRoute: '/main-shell/',
          routes: routes,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
