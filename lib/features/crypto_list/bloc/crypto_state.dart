import 'package:equatable/equatable.dart';
import 'package:brasil_cripto/models/crypto_asset_model.dart';

abstract class CryptoState extends Equatable {
  const CryptoState();

  @override
  List<Object> get props => [];
}

class CryptoInitial extends CryptoState {}

class CryptoLoading extends CryptoState {}

class CryptoLoaded extends CryptoState {
  final List<CryptoAssetModel> assets;
  final bool fromCache;
  final String? updateErrorMessage;

  const CryptoLoaded(
    this.assets, {
    this.fromCache = false,
    this.updateErrorMessage,
  });

  @override
  List<Object> get props => [assets, fromCache, updateErrorMessage ?? ''];
}

class CryptoError extends CryptoState {
  final String message;

  const CryptoError(this.message);

  @override
  List<Object> get props => [message];
}
