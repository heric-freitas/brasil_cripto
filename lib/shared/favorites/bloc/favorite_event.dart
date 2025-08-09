import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoriteEvent {}

class ToggleFavorite extends FavoriteEvent {
  final String assetId;
  final bool isFavorite;

  const ToggleFavorite({required this.assetId, required this.isFavorite});

  @override
  List<Object> get props => [assetId, isFavorite];
}
