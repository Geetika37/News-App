import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_app/constant.dart/const.dart';
import 'package:news_app/model/news_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsHomePage extends StatefulWidget {
  const NewsHomePage({super.key});

  @override
  State<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  final Dio dio = Dio();
  List<Article> articles = [];

  @override
  void initState() {
    getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return ListTile(
            onTap: () {
              _launchUrl(Uri.parse(article.url ?? ''));
            },
            leading: Image.network(
              article.urlToImage ?? PLACEHOLDER_IMAGE_LINK,
              height: 250,
              width: 100,
            ),
            title: Text(article.title ?? ''),
            subtitle: Text(article.publishedAt ?? ''),
          );
        });
  }

  Future<void> getNews() async {
    final response = await dio.get(
      'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=${NEWS_API_KEY}',
    );
    final articlesJson = response.data['articles'] as List;
    setState(
      () {
        List<Article> newsArticles =
            articlesJson.map((a) => Article.fromJson(a)).toList();
        newsArticles =
            newsArticles.where((a) => a.title != "[Removed]").toList();
        articles = newsArticles;
      },
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
