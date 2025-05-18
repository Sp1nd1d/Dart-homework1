import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../services/api_service.dart';
import '../providers/theme_provider.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService(); // Сервис для загрузки новостей
  final ScrollController _scrollController =
      ScrollController(); // Контроллер прокрутки
  final List<Article> _articles = []; // Список статей

  int _currentPage = 1; // Текущая страница пагинации
  bool _isLoading = false; // Флаг загрузки
  bool _hasMore = true; // Флаг наличия следующих страниц

  @override
  void initState() {
    super.initState();
    _fetchArticles(); // Загрузка первой партии статей
    _scrollController.addListener(
      _onScroll,
    ); // Подключаем скролл (слежка за прокруткой списка)
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Освобождаем контроллер
    super.dispose();
  }

  // Обработка скролла: если близко к концу и можно загрузить — загружаем
  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_isLoading &&
        _hasMore) {
      _fetchArticles();
    }
  }

  // Загрузка новых статей с API
  void _fetchArticles() async {
    setState(() => _isLoading = true);
    try {
      final newArticles = await _apiService.fetchArticles(
        page: _currentPage,
        pageSize: 20,
      );
      if (newArticles.isEmpty) {
        _hasMore = false; // Больше страниц нет
      } else {
        _articles.addAll(newArticles); // Добавляем в список
        _currentPage++; // Переходим на следующую страницу
      }
    } catch (e) {
      debugPrint('Ошибка загрузки: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(
      context,
    ); // Получаем текущую тему

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новости'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(), // Переключение темы
          ),
        ],
      ),
      body:
          _articles.isEmpty && _isLoading
              ? const Center(
                child: CircularProgressIndicator(),
              ) // Индикатор при первой загрузке
              : ListView.builder(
                controller: _scrollController,
                itemCount:
                    _articles.length +
                    (_hasMore ? 1 : 0), // +1 если есть ещё страница
                itemBuilder: (context, index) {
                  if (index == _articles.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ), // Индикатор внизу
                    );
                  }

                  final article = _articles[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: SizedBox(
                        width: 100,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.jpg',
                          image: article.urlToImage,
                          fit: BoxFit.cover,
                          imageErrorBuilder:
                              (context, error, stackTrace) => Image.asset(
                                'assets/placeholder.jpg',
                                fit: BoxFit.cover,
                              ),
                        ),
                      ),
                      title: Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        article.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DetailScreen(
                                  article: article,
                                ), // Переход к подробностям
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
