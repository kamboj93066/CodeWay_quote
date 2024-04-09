import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quote_of_the_day/screens/homepage.dart';

void main() async {
  await Hive.initFlutter();

  var box = await Hive.openBox('mybox');
  runApp(const RandomQuoteApp());
}

class RandomQuoteApp extends StatelessWidget {
  const RandomQuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Quote Generator',
      home: RandomQuoteScreen(),
    );
  }
}
