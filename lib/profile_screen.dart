import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = "Użytkownik Ghibli";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? "Użytkownik Ghibli";
    });
  }

  Future<void> _saveUsername(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', newName);
    setState(() {
      _username = newName;
    });
  }

  void _showEditDialog() {
    _controller.text = _username;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Zmień nazwę"),
        content: TextField(controller: _controller),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Anuluj")),
          ElevatedButton(
            onPressed: () {
              _saveUsername(_controller.text);
              Navigator.pop(context);
            },
            child: const Text("Zapisz"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 20),
            Text(_username, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _showEditDialog, child: const Text("Edytuj nazwę")),
          ],
        ),
      ),
    );
  }
}