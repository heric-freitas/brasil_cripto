import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brasil_cripto/shared/favorites/bloc/favorite_bloc.dart';
import 'package:brasil_cripto/shared/favorites/bloc/favorite_event.dart';
import 'package:brasil_cripto/shared/favorites/bloc/favorite_state.dart';
import 'package:flutter_getit/flutter_getit.dart';

class FavoriteButton extends StatefulWidget {
  final String assetId;
  final Color? color;

  const FavoriteButton({super.key, required this.assetId, this.color});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late final FavoriteBloc _favoriteBloc;

  @override
  void initState() {
    super.initState();
    _favoriteBloc = Injector.get<FavoriteBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      bloc: _favoriteBloc,
      builder: (context, state) {
        bool isFavorite = _favoriteBloc.isAssetFavorite(widget.assetId);

        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: widget.color ?? (isFavorite ? Colors.red : Colors.grey),
          ),
          onPressed: () {
            _favoriteBloc.add(
              ToggleFavorite(assetId: widget.assetId, isFavorite: !isFavorite),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isFavorite
                      ? 'Removido dos favoritos.'
                      : 'Adicionado aos favoritos.',
                ),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        );
      },
    );
  }
}
