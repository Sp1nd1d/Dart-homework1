import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article.dart';

class DetailScreen extends StatelessWidget {
  final Article article; // Статья, переданная с главного экрана

  const DetailScreen({super.key, required this.article});

  // Открывает ссылку на статью в браузере
  void _launchURL(BuildContext context) async {
    final uri = Uri.parse(article.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!context.mounted) return; // Проверка, что context всё ещё активен
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть ссылку')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Подготавливаем текст для отображения
    final String mainText =
        (() {
          if (article.content.isNotEmpty) {
            // Очищаем хвост вида "[+123 chars]" (ограничения запроса на получение полного текста статьи)
            final cleaned = article.content.replaceAll(
              RegExp(r'\s*\[\+\d+\schars\]'),
              '',
            );
            return cleaned.trimRight();
          }
          if (article.description.isNotEmpty) {
            return article.description;
          }
          return 'Статья доступна только по ссылке ниже.';
        })();

    return Scaffold(
      appBar: AppBar(title: Text(article.title, maxLines: 1)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage.isNotEmpty)
              SizedBox(
                height: 500,
                width: double.infinity,
                child: FadeInImage.assetNetwork(
                  placeholder:
                      'assets/placeholder.jpg', // заглушка до загрузки основного изображения
                  image: article.urlToImage, // загружаемое основное изображение
                  fit: BoxFit.cover,
                  imageErrorBuilder:
                      (context, error, stackTrace) => Image.asset(
                        'assets/placeholder.jpg', // если загрузка неудачна - показывается заглушка
                        fit: BoxFit.cover,
                      ),
                ),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  mainText, // Основной текст статьи
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed:
                  () => _launchURL(context), // Переход на статью в браузере
              child: const Text('Читать статью в браузере'),
            ),
          ],
        ),
      ),
    );
  }
}
