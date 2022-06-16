import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String word = 'Haii';
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Flutter'),
        ),
        body: Center(
          // child: Text(word),
          child: RandomWords(),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text('Search Here'),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = [];
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    final integer = new Random();
    final word = 'Final' + integer.nextInt(100).toString();
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return const Divider();
        /*2*/

        final index = i ~/ 2; /*3*/
        // if (index >= _suggestions.length) {
          _suggestions.add('Final' + integer.nextInt(100).toString());
        // }
        return ListTile(
          title: Text(
            _suggestions[index],
            style: _biggerFont,
          ),
        );
      },
    );
  }
}