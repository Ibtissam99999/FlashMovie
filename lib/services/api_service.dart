import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String _apiKey = '455dcc8e57383041bcf3275fe481769a';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  static Future<List<Movie>> fetchPopularMovies({String language = 'fr-FR'}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=$language&page=1'),
    );

    if (response.statusCode == 200) {
      final List results = jsonDecode(response.body)['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors du chargement des films populaires');
    }
  }

  static Future<List<Movie>> searchMovies(String query, {String language = 'fr-FR'}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search/movie?api_key=$_apiKey&language=$language&query=$query'),
    );

    if (response.statusCode == 200) {
      final List results = jsonDecode(response.body)['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors de la recherche de films');
    }
  }

  Future<List<dynamic>> fetchActors(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId/credits?api_key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['cast'];
    } else {
      throw Exception('Erreur lors du chargement des acteurs');
    }
  }
}
