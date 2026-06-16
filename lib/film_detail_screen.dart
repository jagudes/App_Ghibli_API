import 'package:flutter/material.dart';
import 'film_model.dart';

class FilmDetailScreen extends StatelessWidget {
  final FilmModel film;

  const FilmDetailScreen({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(film.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              film.image,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text("Reżyser: ${film.director}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Opis:", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(film.description),
          ],
        ),
      ),
    );
  }
}