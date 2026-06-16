import 'dart:convert';
import 'package:http/http.dart' as http;
import 'film_model.dart';

class GhibliService {
  final String _baseUrl = 'https://ghibliapi.vercel.app/films';

  Future<List<FilmModel>> fetchFilms() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => FilmModel.fromJson(item)).toList();
    } else {
      throw Exception('Nie udało się pobrać filmów');
    }
  }
}