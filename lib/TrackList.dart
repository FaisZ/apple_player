import 'dart:convert';
import 'package:apple_player/PlayerComponent/AudioPlayerComponent.dart';
import 'package:apple_player/PlayerComponent/Track.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TrackList extends StatefulWidget {
  const TrackList({Key? key}) : super(key: key);

  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {

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
                  // trailing: Text (track.artistName),
                  // title: Text(track.trackName),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(track.trackName, overflow: TextOverflow.ellipsis,),
                      Text(track.artistName, overflow: TextOverflow.ellipsis,),
                      Text(track.collectionName, overflow: TextOverflow.ellipsis,),
                    ],
                  ),
                  onTap: () {
                    openPlayer(track.trackName,track.trackURL);
                    // Navigator.push(context,
                    //     new MaterialPageRoute(builder: (context) => new Home()));
                  },
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

  openPlayer(trackName, url){
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Center(
            child:AudioPlayerComponent(trackName: trackName, trackUrl: url,)
          ),
        );
      },
    );
  }
}