import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.sidl-corporation.fr/v5/app/ios';

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Headers génériques
  Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Méthode pour mettre à jour les headers (par exemple pour ajouter un token)
  void updateHeaders(Map<String, String> newHeaders) {
    _headers.addAll(newHeaders);
  }

  // GET générique
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
    );

    return _processResponse(response);
  }

  // POST générique
  Future<dynamic> post(String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
      body: json.encode(data),
    );

    return _processResponse(response);
  }

  // PUT générique
  Future<dynamic> put(String endpoint, dynamic data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
      body: json.encode(data),
    );

    return _processResponse(response);
  }

  // DELETE générique
  Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
    );

    return _processResponse(response);
  }

  // Traitement de la réponse
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      }
      return {};
    } else {
      throw Exception('Erreur: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }

  // Récupérer les actualités
  Future<List<dynamic>> getNews() async {
    final data = await get('news.php');
    return data['data'] as List<dynamic>;
  }
}