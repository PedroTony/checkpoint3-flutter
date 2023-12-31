import 'package:flutter/material.dart';
import 'package:github_api_demo/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(primary: Colors.amber.shade800),
      ),
      home: const HomePage(),
    );
  }
}
