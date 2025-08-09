import 'package:equatable/equatable.dart';

abstract class CryptoDetailEvent extends Equatable {
  const CryptoDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadCryptoDetail extends CryptoDetailEvent {
  final String assetId;

  const LoadCryptoDetail({required this.assetId});

  @override
  List<Object> get props => [assetId];
}
