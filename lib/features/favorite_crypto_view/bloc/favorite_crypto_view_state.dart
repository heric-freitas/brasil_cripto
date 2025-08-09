import 'package:equatable/equatable.dart';
import 'package:brasil_cripto/models/crypto_asset_model.dart';

abstract class FavoriteCryptoViewState extends Equatable {
  const FavoriteCryptoViewState();

  @override
  List<Object> get props => [];
}

class FavoriteCryptoViewInitial extends FavoriteCryptoViewState {}

class FavoriteCryptoViewLoading extends FavoriteCryptoViewState {}

class FavoriteCryptoViewLoaded extends FavoriteCryptoViewState {
  final List<CryptoAssetModel> favoriteAssets;
  final String? updateErrorMessage;

  const FavoriteCryptoViewLoaded(
    this.favoriteAssets, {
    this.updateErrorMessage,
  });

  @override
  List<Object> get props => [favoriteAssets, updateErrorMessage ?? ''];
}

class FavoriteCryptoViewError extends FavoriteCryptoViewState {
  final String message;

  const FavoriteCryptoViewError(this.message);

  @override
  List<Object> get props => [message];
}
