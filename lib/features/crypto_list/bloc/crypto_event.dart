import 'package:equatable/equatable.dart';

abstract class CryptoEvent extends Equatable {
  const CryptoEvent();

  @override
  List<Object> get props => [];
}

class LoadCryptoAssets extends CryptoEvent {
  final String? searchTerm;

  const LoadCryptoAssets({this.searchTerm});

  @override
  List<Object> get props => [searchTerm ?? ''];
}
