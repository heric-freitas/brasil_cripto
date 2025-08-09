import 'package:equatable/equatable.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoritesLoaded extends FavoriteState {
  final List<String> favoriteAssetIds;

  const FavoritesLoaded(this.favoriteAssetIds);

  @override
  List<Object> get props => [favoriteAssetIds];
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object> get props => [message];
}

class FavoriteActionSuccess extends FavoriteState {
  final String assetId;
  final bool isFavorite;

  const FavoriteActionSuccess({
    required this.assetId,
    required this.isFavorite,
  });

  @override
  List<Object> get props => [assetId, isFavorite];
}
