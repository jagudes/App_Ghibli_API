import 'package:flutter/material.dart';
import 'ghibli_service.dart';
import 'film_model.dart';

class FavoritesScreen extends StatelessWidget {
  final Set<String> favoriteIds;

  const FavoritesScreen({super.key, required this.favoriteIds});

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
            itemBuilder: (context, index) => ListTile(title: Text(favorites[index].title)),
          );
        },
      ),
    );
  }
}