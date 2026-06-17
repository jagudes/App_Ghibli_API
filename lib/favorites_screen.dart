import 'package:flutter/material.dart';
import 'ghibli_service.dart';
import 'film_model.dart';
import 'film_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final Set<String> favoriteIds;
  final Function(String) onToggleFavorite;

  const FavoritesScreen({super.key, required this.favoriteIds, required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ulubione filmy")),
      body: FutureBuilder<List<FilmModel>>(
        future: GhibliService().fetchFilms(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final favorites = snapshot.data!.where((f) => favoriteIds.contains(f.id)).toList();

          if (favorites.isEmpty) return const Center(child: Text("Brak ulubionych"));

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final film = favorites[index];
              return ListTile(
                title: Text(film.title),
                subtitle: Text("Reżyser: ${film.director}"),
                leading: const Icon(Icons.movie),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
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
          );
        },
      ),
    );
  }
}