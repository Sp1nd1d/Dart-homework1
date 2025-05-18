import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import 'dart:developer';

class ApiService {
  final String _apiKey = '0f2038137ec9480bb06cbc5b468e11b9';
  final String _baseUrl = 'https://newsapi.org/v2/top-headlines';

  /// Загружает список новостей с параметрами пагинации
  Future<List<Article>> fetchArticles({int page = 1, int pageSize = 20}) async {
    final uri = Uri.parse(
      '$_baseUrl?country=us&pageSize=$pageSize&page=$page&apiKey=$_apiKey',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      log('Total available results: ${data['totalResults']}');

      if (data['status'] == 'ok') {
        final List articlesJson = data['articles'];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка API: ${data['message']}');
      }
    } else {
      throw Exception('Ошибка HTTP: ${response.statusCode}');
    }
  }
}
