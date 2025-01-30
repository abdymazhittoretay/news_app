import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/news_model.dart';
import 'package:url_launcher/url_launcher.dart';

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
      setState(() {});
    } catch (e) {
      print("Error with getting the news: $e");
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
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.deepPurple,
        title: Text("NewsWave"),
      ),
      body: _news.isNotEmpty
          ? ListView.builder(
              itemCount: _news.length,
              itemBuilder: (context, index) {
                final NewsModel newsItem = _news[index];
                return GestureDetector(
                  onTap: () async {
                    final _url = Uri.parse(newsItem.url);
                    if (await canLaunchUrl(_url)) {
                      await launchUrl(_url);
                    }
                  },
                  child: ListTile(
                    leading: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(newsItem.urlToImage),
                              fit: BoxFit.cover)),
                    ),
                    title: Text(newsItem.title),
                    subtitle: Text(newsItem.publishedAt.substring(0, 10)),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            ),
    );
  }
}
