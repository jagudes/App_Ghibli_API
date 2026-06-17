import 'package:flutter/material.dart';
import 'film_list_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final Set<String> _favoriteIds = {};

  void _toggleFavorite(String id) {
    setState(() {
      _favoriteIds.contains(id) ? _favoriteIds.remove(id) : _favoriteIds.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      FilmListScreen(onToggleFavorite: _toggleFavorite, favorites: _favoriteIds),
      FavoritesScreen(favoriteIds: _favoriteIds),
    ];

    return Scaffold(
      body: pages[_currentIndex],
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