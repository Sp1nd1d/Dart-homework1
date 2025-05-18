import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import 'dart:developer';

class ApiService {
  final String _apiKey =
      '0f2038137ec9480bb06cbc5b468e11b9'; // Ключ доступа к API
  final String _baseUrl = 'https://newsapi.org/v2/top-headlines'; // URL запроса

  // Загружает список новостей с параметрами пагинации
  Future<List<Article>> fetchArticles({int page = 1, int pageSize = 20}) async {
    final uri = Uri.parse(
      '$_baseUrl?country=us&pageSize=$pageSize&page=$page&apiKey=$_apiKey',
    );

    final response = await http.get(uri); // Выполняем GET-запрос

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(
        response.body,
      ); // Если запрос успешно выполнен - расшифровка JSON

      log(
        'Total available results: ${data['totalResults']}',
      ); // Лог в консоль (для понимания и проверки количества полученных запросом статей)

      if (data['status'] == 'ok') {
        final List articlesJson = data['articles']; // Извлекаем список статей
        return articlesJson
            .map((json) => Article.fromJson(json))
            .toList(); // Преобразуем в список объектов Article
      } else {
        throw Exception(
          'Ошибка API: ${data['message']}',
        ); // При ошибке со стороны API
      }
    } else {
      throw Exception(
        'Ошибка HTTP: ${response.statusCode}',
      ); // При ошибке соединения
    }
  }
}
