import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/news_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _apiKey = dotenv.env["API_KEY"] ?? "";
  final List<NewsModel> _news = [];
  Future _getNews() async {
    try {
      var response = await http.get(Uri.https("newsapi.org", "/v2/everything", {
        "q": "bitcoin",
        "apiKey": _apiKey,
      }));
      var data = jsonDecode(response.body);
      for (var i in data["articles"]) {
        _news.add(NewsModel(
            title: i["title"] ?? "",
            url: i["url"] ?? "",
            urlToImage: i["urlToImage"] ?? "",
            publishedAt: i["publishedAt"] ?? ""));
      }
      print(_news.length);
    } catch (e) {
      print("Error with getting the news $e");
    }
  }

  @override
  void initState() {
    _getNews();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
    );
  }
}
