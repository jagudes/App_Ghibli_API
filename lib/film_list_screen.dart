import 'package:flutter/material.dart';
import 'ghibli_service.dart';
import 'film_model.dart';
import 'film_detail_screen.dart';

class FilmListScreen extends StatefulWidget {
  const FilmListScreen({super.key});

  @override
  State<FilmListScreen> createState() => _FilmListScreenState();
}

class _FilmListScreenState extends State<FilmListScreen> {
  final GhibliService _ghibliService = GhibliService();
  late Future<List<FilmModel>> _filmsFuture;

  @override
  void initState() {
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
            return Center(child: Text("Błąd: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Brak filmów"));
          }

          final films = snapshot.data!;
          return ListView.builder(
            itemCount: films.length,
            itemBuilder: (context, index) {
              final film = films[index];
              return ListTile(
                title: Text(film.title),
                subtitle: Text("Reżyser: ${film.director}"),
                leading: const Icon(Icons.movie),
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