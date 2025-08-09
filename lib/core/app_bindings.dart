// lib/core/app_bindings.dart
import 'package:dio/dio.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:brasil_cripto/services/api_service.dart';
import 'package:brasil_cripto/services/local_storage_service.dart';
import 'package:brasil_cripto/features/crypto_list/bloc/crypto_bloc.dart';
import 'package:brasil_cripto/features/crypto_detail/bloc/crypto_detail_bloc.dart';
import 'package:brasil_cripto/shared/favorites/bloc/favorite_bloc.dart';
import 'package:brasil_cripto/features/favorite_crypto_view/bloc/favorite_crypto_view_bloc.dart';

class MyApplicationBindings extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
    Bind.lazySingleton<Dio>(
      (i) => Dio(
        BaseOptions(
          baseUrl: 'https://rest.coincap.io/v3',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization':
                'Bearer 85b3aa3b140797d90056c9857c461d970089f118832df830fc17269dca29d6c1',
          },
        ),
      ),
    ),
    Bind.lazySingleton<ApiService>((i) => ApiService(i<Dio>())),
    Bind.lazySingleton<LocalStorageService>((i) => LocalStorageService()),

   
    Bind.lazySingleton<CryptoBloc>(
      (i) => CryptoBloc(i<ApiService>(), i<LocalStorageService>()),
    ),
    Bind.lazySingleton<CryptoDetailBloc>(
      (i) => CryptoDetailBloc(i<ApiService>(), i<LocalStorageService>()),
    ),
    Bind.lazySingleton<FavoriteBloc>(
      (i) => FavoriteBloc(i<LocalStorageService>()),
    ),

    Bind.lazySingleton<FavoriteCryptoViewBloc>(
      (i) => FavoriteCryptoViewBloc(i<FavoriteBloc>(), i<ApiService>()),
    ),
  ];
}
