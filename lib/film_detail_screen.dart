import 'package:flutter/material.dart';
import 'package:ghibli_app/analytics_service.dart';
import 'package:ghibli_app/film_model.dart';

class FilmDetailScreen extends StatelessWidget {
  final FilmModel film;

  const FilmDetailScreen({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    AnalyticsService.logEvent('view_film_details', {'title': film.title});
    return Scaffold(
      appBar: AppBar(title: Text(film.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 350,
              width: double.infinity,
              child: Image.network(
                film.image,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress){
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.movie, size: 80),
                ),
              ),
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