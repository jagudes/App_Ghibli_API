import 'package:flutter/material.dart';
import 'package:ghibli_app/film_model.dart';
import 'film_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'favorites_screen.dart';
import 'ghibli_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Set<String> _favoriteIds = {};
  List<FilmModel> _allFilms = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _loadFilms();
  }

  Future<void> _loadFilms() async {
    final films = await GhibliService().fetchFilms();
    setState(() {
      _allFilms = films;
    });
  }
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedIds = prefs.getStringList('favorites');
    if (savedIds != null) {
      setState(() {
        _favoriteIds = savedIds.toSet();
      });
    }
  }

  Future<void> _toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      Set<String> newFavorites = Set.from(_favoriteIds);
      if (newFavorites.contains(id)) {
        newFavorites.remove(id);
      } else {
        newFavorites.add(id);
      }
      _favoriteIds = newFavorites;
    });
    await prefs.setStringList('favorites', _favoriteIds.toList());
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      FilmListScreen(
        onToggleFavorite: _toggleFavorite,
        favorites: _favoriteIds,
        films: _allFilms,
      ),
      FavoritesScreen(
        favoriteIds: _favoriteIds,
        onToggleFavorite: _toggleFavorite,
        allFilms: _allFilms,
      ),
    ];

    return Scaffold(
      body: _allFilms.isEmpty && _currentIndex == 0
          ? const Center(child: CircularProgressIndicator())
          : pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Filmy'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Ulubione'),
        ],
      ),
    );
  }
}