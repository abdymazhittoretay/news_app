import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await dotenv.load(fileName: ".env");
  }catch(e){
    print("Error with .env load: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
