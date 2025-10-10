import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_demo/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PDF',
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
