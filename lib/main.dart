import 'package:flutter/material.dart';
import 'package:to_do_rest_api/page/home.dart';
import 'package:to_do_rest_api/page/tambah_todo.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}
