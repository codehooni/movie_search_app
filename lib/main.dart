import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_demo/screens/main_screen.dart';
import 'package:movie_demo/theme/dark_mode.dart';

late Size mq;

Future<void> main() async {
  // api key를 위한 env 받아오기
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return MaterialApp(title: 'Movie App', theme: darkMode, home: MainScreen());
  }
}
