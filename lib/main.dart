import 'package:deeplayer/page/main_page.dart';
import 'package:deeplayer/page/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:deeplayer/page/request_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'deeplayer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
