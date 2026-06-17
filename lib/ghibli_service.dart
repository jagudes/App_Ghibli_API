import 'dart:convert';
import 'package:ghibli_app/analytics_service.dart';
import 'package:http/http.dart' as http;
import 'film_model.dart';
import 'database_helper.dart';

class GhibliService {
  final String _baseUrl = 'https://ghibliapi.vercel.app/films';

  Future<List<FilmModel>> fetchFilms() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<FilmModel> films = body
            .map((dynamic item) => FilmModel.fromJson(item))
            .toList();
        await DatabaseHelper.instance.saveFilms(films);
        return films;
      } else {
        throw Exception('Serwer zwraca błąd');
      }
    } catch (e) {
      AnalyticsService.logEvent('error_api_fetch', {'error': e.toString()});
      print("Błąd pobierania z sieci - dane ładowane offline: $e");
      return await DatabaseHelper.instance.getFilms();
    }
  }
}
