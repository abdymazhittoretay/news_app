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
  String _q = "bitcoin";

  Future _getTopHeadlines() async {
    try {
      var response =
          await http.get(Uri.https("newsapi.org", "/v2/top-headlines", {
        "country": "us",
        "apiKey": _apiKey,
      }));
      var data = jsonDecode(response.body);
      for (var i in data["articles"]) {
        _news.add(NewsModel(
            title: i["title"] ?? "",
            url: i["url"] ?? "",
            urlToImage: i["urlToImage"] ??
                "https://static.vecteezy.com/system/resources/previews/003/793/796/non_2x/error-analysis-digital-free-vector.jpg",
            publishedAt: i["publishedAt"] ?? ""));
      }
      setState(() {});
    } catch (e) {
      print("Error with getting the news: $e");
    }
  }

  Future _getNews() async {
    try {
      var response = await http.get(Uri.https("newsapi.org", "/v2/everything", {
        "q": _q,
        "apiKey": _apiKey,
      }));
      var data = jsonDecode(response.body);
      for (var i in data["articles"]) {
        _news.add(NewsModel(
            title: i["title"] ?? "",
            url: i["url"] ?? "",
            urlToImage: i["urlToImage"] ??
                "https://static.vecteezy.com/system/resources/previews/003/793/796/non_2x/error-analysis-digital-free-vector.jpg",
            publishedAt: i["publishedAt"] ?? ""));
      }
      setState(() {});
    } catch (e) {
      print("Error with getting the news: $e");
    }
  }

  @override
  void initState() {
    _getTopHeadlines();

    super.initState();
  }

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.deepPurple,
        title: Text("NewsWave"),
        actions: [
          IconButton(
              onPressed: () {
                openDialog();
              },
              icon: Icon(Icons.search))
        ],
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

  void openDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: LinearBorder(),
        title: Text("Search for a news:"),
        content: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(hintText: "Type here"),
        ),
        actions: [
          TextButton(
              onPressed: () {
                _controller.clear();
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.deepPurple),
              )),
          TextButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _q = _controller.text;
                  _news.clear();
                  _controller.clear();
                  _getNews();
                }
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text(
                "Search",
                style: TextStyle(color: Colors.deepPurple),
              ))
        ],
      ),
    );
  }
}
