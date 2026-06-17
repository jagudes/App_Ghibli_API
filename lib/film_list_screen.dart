import 'package:flutter/material.dart';
import 'package:ghibli_app/analytics_service.dart';
import 'ghibli_service.dart';
import 'package:ghibli_app/film_model.dart';
import 'film_detail_screen.dart';

class FilmListScreen extends StatefulWidget {
  final Function(String) onToggleFavorite;
  final Set<String> favorites;
  final List<FilmModel> films;

  const FilmListScreen({
    super.key,
    required this.onToggleFavorite,
    required this.favorites,
    required this.films,
  });

  @override
  State<FilmListScreen> createState() => _FilmListScreenState();
}

class _FilmListScreenState extends State<FilmListScreen> {
  final GhibliService _ghibliService = GhibliService();
  late Future<List<FilmModel>> _filmsFuture;

  @override
  void initState() {
    AnalyticsService.logEvent('view_film_list', {});
    super.initState();
    _filmsFuture = _ghibliService.fetchFilms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Filmy Studio Ghibli")),
      body: FutureBuilder<List<FilmModel>>(
        future: _filmsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Coś poszło nie tak",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Nie udało się załadować listy - sprawdż połączenie z internetem",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _filmsFuture = _ghibliService.fetchFilms();
                        });
                      },
                      child: const Text("Spróbuj ponownie"),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Brak filmów"));
          }

          final films = snapshot.data!;
          return RefreshIndicator(
              onRefresh: () async {
                print("DEBUG: OnRefresh wywołane!");
                AnalyticsService.logEvent('refresh_film_list', {});
                setState(() {
                  _filmsFuture = _ghibliService.fetchFilms();
                });
                await _filmsFuture;
              },

              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: films.length,
                itemBuilder: (context, index) {
                  final film = films[index];
                  return ListTile(
                    title: Text(film.title),
                    subtitle: Text("Reżyser: ${film.director}"),
                    leading: const Icon(Icons.movie),
                    trailing: IconButton(
                      icon: Icon(
                        widget.favorites.contains(film.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        widget.onToggleFavorite(film.id);
                        setState(() {});
                      },
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
        },
      ),
    );
  }
}
