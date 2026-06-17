import 'package:flutter/material.dart';
import 'package:ghibli_app/film_model.dart';
import 'film_detail_screen.dart';

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
            subtitle: Text("Reżyser: ${film.director}"),
            leading: const Icon(Icons.movie),
            trailing: IconButton(
              icon: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              onPressed: () => onToggleFavorite(film.id),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilmDetailScreen(film: film),
                ),
              );
            },
          );
        },
      ),
    );
  }
}