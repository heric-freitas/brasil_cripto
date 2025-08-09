import 'package:dio/dio.dart';
import 'package:brasil_cripto/models/crypto_asset_model.dart';
import 'package:brasil_cripto/models/asset_history_model.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<List<CryptoAssetModel>> getAssets({String? search}) async {
    try {
      final response = await _dio.get(
        '/assets',
        queryParameters: {
          'search': search,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => CryptoAssetModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar ativos: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String errorMessage = 'Erro de conexão: ${e.message}';
      if (e.response != null) {
        errorMessage =
            'Erro da API: ${e.response?.statusCode} - ${e.response?.statusMessage}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Erro desconhecido ao obter ativos: $e');
    }
  }

  Future<CryptoAssetModel> getAssetById(String assetId) async {
    try {
      final response = await _dio.get('/assets/$assetId');
      if (response.statusCode == 200) {
        return CryptoAssetModel.fromJson(response.data['data']);
      } else {
        throw Exception('Falha ao carregar ativo: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String errorMessage = 'Erro de conexão: ${e.message}';
      if (e.response != null) {
        errorMessage =
            'Erro da API: ${e.response?.statusCode} - ${e.response?.statusMessage}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Erro desconhecido ao obter ativo: $e');
    }
  }

  Future<List<AssetHistoryModel>> getAssetHistory(
    String assetId, {
    String interval = 'd1',
    int? start,
    int? end,
  }) async {
    try {
      final response = await _dio.get(
        '/assets/$assetId/history',
        queryParameters: {'interval': interval, 'start': start, 'end': end},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => AssetHistoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar histórico: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String errorMessage = 'Erro de conexão: ${e.message}';
      if (e.response != null) {
        errorMessage =
            'Erro da API: ${e.response?.statusCode} - ${e.response?.statusMessage}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Erro desconhecido ao obter histórico: $e');
    }
  }
}
