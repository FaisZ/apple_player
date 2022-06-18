import 'package:apple_player/PlayerComponent/AudioPlayerComponent.dart';
import 'package:apple_player/TrackList.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apple Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Apple Music Player'),
        ),
        body: Center(
          // child: Text(word),
          child: TrackList(),
          // child: AudioPlayerComponent()
        ),
      ),
    );
  }
}