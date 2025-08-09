import 'package:equatable/equatable.dart';

abstract class FavoriteCryptoViewEvent extends Equatable {
  const FavoriteCryptoViewEvent();

  @override
  List<Object> get props => [];
}

class LoadFavoriteCryptoAssets extends FavoriteCryptoViewEvent {}
