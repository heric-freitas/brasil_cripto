import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

import 'package:brasil_cripto/services/api_service.dart';
import 'package:brasil_cripto/models/crypto_asset_model.dart';
import 'package:brasil_cripto/models/asset_history_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late ApiService api;

  setUp(() {
    mockDio = MockDio();
    api = ApiService(mockDio);
  });

  group('ApiService.getAssets', () {
    test('retorna lista de CryptoAssetModel quando status 200', () async {
      final responseData = {
        'data': [
          {
            'id': 'bitcoin',
            'name': 'Bitcoin',
            'symbol': 'BTC',
            'priceUsd': '68000.123',
            'changePercent24Hr': '-0.45',
            'marketCapUsd': '1000000000000',
            'volumeUsd24Hr': '35000000000',
          },
          {
            'id': 'ethereum',
            'name': 'Ethereum',
            'symbol': 'ETH',
            'priceUsd': '3500.50',
            'changePercent24Hr': '1.23',
            'marketCapUsd': '450000000000',
            'volumeUsd24Hr': '15000000000',
          },
        ],
      };

      when(() => mockDio.get(
            '/assets',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/assets'),
          statusCode: 200,
          data: responseData,
        ),
      );

      final result = await api.getAssets();

      expect(result, isA<List<CryptoAssetModel>>());
      expect(result.length, 2);
      
      expect(result.first, isA<CryptoAssetModel>());
    });

    test('lança Exception com mensagem "Falha ao carregar ativos" quando status != 200', () async {
      when(() => mockDio.get(
            '/assets',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/assets'),
          statusCode: 500,
          data: {'error': 'internal'},
        ),
      );

      expect(
        () => api.getAssets(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Falha ao carregar ativos: 500'),
          ),
        ),
      );
    });

    test('lança Exception com mensagem da API quando DioException com response (ex.: 403)', () async {
      when(() => mockDio.get(
            '/assets',
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/assets'),
          response: Response(
            requestOptions: RequestOptions(path: '/assets'),
            statusCode: 403,
            statusMessage: 'Forbidden',
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => api.getAssets(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro da API: 403 - Forbidden'),
          ),
        ),
      );
    });

    test('lança Exception com mensagem de conexão quando DioException sem response', () async {
      when(() => mockDio.get(
            '/assets',
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/assets'),
          type: DioExceptionType.connectionError,
          error: 'SocketException: Failed host lookup',
        ),
      );

      expect(
        () => api.getAssets(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro de conexão:'),
          ),
        ),
      );
    });

    test('lança Exception genérica para erros desconhecidos', () async {
      when(() => mockDio.get(
            '/assets',
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(FormatException('JSON inválido'));

      expect(
        () => api.getAssets(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro desconhecido ao obter ativos:'),
          ),
        ),
      );
    });

    test('envia queryParameters com search quando informado', () async {
      when(() => mockDio.get(
            '/assets',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/assets'),
          statusCode: 200,
          data: {'data': []},
        ),
      );

      await api.getAssets(search: 'bit');

      verify(() => mockDio.get(
            '/assets',
            queryParameters: any(named: 'queryParameters'),
          )).called(1);
    });
  });

  group('ApiService.getAssetById', () {
    test('retorna CryptoAssetModel quando status 200', () async {
      final responseData = {
        'data': {
          'id': 'bitcoin',
          'name': 'Bitcoin',
          'symbol': 'BTC',
          'priceUsd': '68000.123',
          'changePercent24Hr': '-0.45',
        }
      };

      when(() => mockDio.get('/assets/bitcoin')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/assets/bitcoin'),
          statusCode: 200,
          data: responseData,
        ),
      );

      final result = await api.getAssetById('bitcoin');

      expect(result, isA<CryptoAssetModel>());
      
      
    });

    test('lança Exception com mensagem "Falha ao carregar ativo" quando status != 200', () async {
      when(() => mockDio.get('/assets/bitcoin')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/assets/bitcoin'),
          statusCode: 404,
          data: {'error': 'not found'},
        ),
      );

      expect(
        () => api.getAssetById('bitcoin'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Falha ao carregar ativo: 404'),
          ),
        ),
      );
    });

    test('lança Exception com mensagem da API quando DioException com response', () async {
      when(() => mockDio.get('/assets/bitcoin')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/assets/bitcoin'),
          response: Response(
            requestOptions: RequestOptions(path: '/assets/bitcoin'),
            statusCode: 429,
            statusMessage: 'Too Many Requests',
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => api.getAssetById('bitcoin'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro da API: 429 - Too Many Requests'),
          ),
        ),
      );
    });

    test('lança Exception com mensagem de conexão quando DioException sem response', () async {
      when(() => mockDio.get('/assets/bitcoin')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/assets/bitcoin'),
          type: DioExceptionType.connectionError,
          error: 'TimeoutException',
        ),
      );

      expect(
        () => api.getAssetById('bitcoin'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro de conexão:'),
          ),
        ),
      );
    });

    test('lança Exception genérica para erros desconhecidos', () async {
      when(() => mockDio.get('/assets/bitcoin')).thenThrow(StateError('Ops'));

      expect(
        () => api.getAssetById('bitcoin'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro desconhecido ao obter ativo:'),
          ),
        ),
      );
    });
  });

  group('ApiService.getAssetHistory', () {
    test('retorna lista de AssetHistoryModel quando status 200', () async {
      final responseData = {
        'data': [
          {
            'priceUsd': '68200.01',
            'time': 1715558400000,
            'date': '2024-05-12T00:00:00.000Z',
          },
          {
            'priceUsd': '68100.10',
            'time': 1715644800000,
            'date': '2024-05-13T00:00:00.000Z',
          },
        ],
      };

      when(() => mockDio.get(
            '/assets/bitcoin/history',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/assets/bitcoin/history'),
          statusCode: 200,
          data: responseData,
        ),
      );

      final result = await api.getAssetHistory('bitcoin');

      expect(result, isA<List<AssetHistoryModel>>());
      expect(result.length, 2);
      expect(result.first, isA<AssetHistoryModel>());
    });

    test('envia interval/start/end como queryParameters (quando fornecidos)', () async {
      final start = 1715558400000;
      final end = 1715644800000;

      when(() => mockDio.get(
            '/assets/bitcoin/history',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/assets/bitcoin/history'),
          statusCode: 200,
          data: {'data': []},
        ),
      );

      await api.getAssetHistory(
        'bitcoin',
        interval: 'h1',
        start: start,
        end: end,
      );

      verify(() => mockDio.get(
            '/assets/bitcoin/history',
            queryParameters: any(named: 'queryParameters'),
          )).called(1);
    });

    test('lança Exception com mensagem "Falha ao carregar histórico" quando status != 200', () async {
      when(() => mockDio.get(
            '/assets/bitcoin/history',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/assets/bitcoin/history'),
          statusCode: 502,
          data: {'error': 'bad gateway'},
        ),
      );

      expect(
        () => api.getAssetHistory('bitcoin'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Falha ao carregar histórico: 502'),
          ),
        ),
      );
    });

    test('lança Exception com mensagem da API quando DioException com response', () async {
      when(() => mockDio.get(
            '/assets/bitcoin/history',
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/assets/bitcoin/history'),
          response: Response(
            requestOptions: RequestOptions(path: '/assets/bitcoin/history'),
            statusCode: 403,
            statusMessage: 'Forbidden',
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => api.getAssetHistory('bitcoin'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro da API: 403 - Forbidden'),
          ),
        ),
      );
    });

    test('lança Exception com mensagem de conexão quando DioException sem response', () async {
      when(() => mockDio.get(
            '/assets/bitcoin/history',
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/assets/bitcoin/history'),
          type: DioExceptionType.connectionError,
          error: 'SocketException',
        ),
      );

      expect(
        () => api.getAssetHistory('bitcoin'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro de conexão:'),
          ),
        ),
      );
    });

    test('lança Exception genérica para erros desconhecidos', () async {
      when(() => mockDio.get(
            '/assets/bitcoin/history',
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(ArgumentError('Parâmetro inválido'));

      expect(
        () => api.getAssetHistory('bitcoin'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Erro desconhecido ao obter histórico:'),
          ),
        ),
      );
    });
  });
}