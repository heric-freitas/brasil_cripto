import 'package:equatable/equatable.dart';
import 'package:brasil_cripto/models/crypto_asset_model.dart';
import 'package:brasil_cripto/models/asset_history_model.dart';

abstract class CryptoDetailState extends Equatable {
  const CryptoDetailState();

  @override
  List<Object> get props => [];
}

class CryptoDetailInitial extends CryptoDetailState {}

class CryptoDetailLoading extends CryptoDetailState {}

class CryptoDetailLoaded extends CryptoDetailState {
  final CryptoAssetModel asset;
  final List<AssetHistoryModel> history;
  final String? updateErrorMessage;

  const CryptoDetailLoaded({
    required this.asset,
    required this.history,
    this.updateErrorMessage,
  });

  @override
  List<Object> get props => [asset, history, updateErrorMessage ?? ''];
}

class CryptoDetailError extends CryptoDetailState {
  final String message;

  const CryptoDetailError(this.message);

  @override
  List<Object> get props => [message];
}
