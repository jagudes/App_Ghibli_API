import 'package:flutter/material.dart';
import 'package:ghibli_app/film_model.dart';

class FavoritesScreen extends StatelessWidget {
  final Set<String> favoriteIds;
  final Function(String) onToggleFavorite;
  final List<FilmModel> allFilms;

  const FavoritesScreen({super.key, required this.favoriteIds, required this.onToggleFavorite, required this.allFilms});

  @override
  Widget build(BuildContext context) {
    final favorites = allFilms.where((f) => favoriteIds.contains(f.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Ulubione filmy")),
      body: favorites.isEmpty
          ? const Center(child: Text("Brak ulubionych"))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final film = favorites[index];
          return ListTile(
            title: Text(film.title),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () => onToggleFavorite(film.id),
            ),
          );
        },
      ),
    );
  }
}