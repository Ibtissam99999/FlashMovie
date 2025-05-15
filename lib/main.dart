import 'package:flashmovie/page/home_page.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(const flashmovie());

}



class flashmovie extends StatelessWidget {
  const flashmovie({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const HomeScreen(),
    );

  }
}