import 'dart:convert';
import 'dart:math';

import 'package:apple_player/AudioPlayerSample.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
          // child: HttpReq(),
          child: AudioPlayerSample()
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

class HttpReq extends StatefulWidget {
  const HttpReq({Key? key}) : super(key: key);

  @override
  _HttpReqState createState() => _HttpReqState();
}

class _HttpReqState extends State<HttpReq> {

  late Future<List<Track>> futureTracks;

  getTracks(Map<String, dynamic> json) {
    List<Track> tracks = [];
    for(var i=0; i<json['resultCount']; i++){
      tracks.add(Track.fromJson(json['results'][i]));
      print(i);
      print(json['resultCount']);
      print(tracks[i].trackName);
    }
    return tracks;
  }

  Future<List<Track>> fetchTracks() async {
    final response = await http
        .get(Uri.parse('https://itunes.apple.com/search?term=jack+johnson&entity=musicVideo'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // return Album.fromJson(jsonDecode(response.body));
      return getTracks(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load music');
    }
  }

  @override
  void initState(){
    super.initState();
    futureTracks = fetchTracks();
  }
  Widget build(BuildContext context) {
    return FutureBuilder<List<Track>>(
      future: futureTracks,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Track> tracks = snapshot.data ?? [];
          // return Text(tereks[0].artistName);
          return ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                Track track = tracks[index];
                return new ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(track.smallArtwork),
                  ),
                  // trailing: track.artistName,
                  title: new Text(track.trackName),
                  // onTap: () {
                  //   Navigator.push(context,
                  //       new MaterialPageRoute(builder: (context) => new Home()));
                  // },
                );
              });
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}



class Track {
  final int trackId;
  final String artistName;
  // final String collectionName;
  final String trackName;
  final String smallArtwork;
  final String trackURL;

  const Track({
    required this.trackId,
    required this.artistName,
    // required this.collectionName,
    required this.trackName,
    required this.smallArtwork,
    required this.trackURL,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      trackId: json['trackId'],
      artistName: json['artistName'],
      // collectionName: (json['collectionName']==null) ? json['collectionName']:'None',
      trackName: json['trackName'],
      smallArtwork: json['artworkUrl30'],
      trackURL: json['trackViewUrl'],
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