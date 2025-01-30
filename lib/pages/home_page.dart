import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _apiKey = dotenv.env["API_KEY"] ?? "";
  Future _getNews() async {
    try {
      var response = await http.get(Uri.https("newsapi.org", "/v2/everything", {
        "q": "bitcoin",
        "apiKey": _apiKey,
      }));
      print(response.body);
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
