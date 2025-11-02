import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_demo/screens/home_screen.dart';
import 'package:movie_demo/theme/dark_mode.dart';

Future<void> main() async {
  // api key를 위한 env 받아오기
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Movie App', theme: darkMode, home: HomeScreen());
  }
}
