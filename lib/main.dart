import 'package:flutter/material.dart';
import 'pages/pageMap.dart';
import 'pages/pageRechercheitineraire.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CollapsingAppbarPage(),
    );
  }
}
