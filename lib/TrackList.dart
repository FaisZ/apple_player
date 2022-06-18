import 'dart:convert';
import 'package:apple_player/PlayerComponent/AudioPlayerComponent.dart';
import 'package:apple_player/PlayerComponent/Track.dart';
import 'package:apple_player/SearchBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TrackList extends StatefulWidget {
  const TrackList({Key? key}) : super(key: key);

  @override
  _TrackListState createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  late Future<List<Track>> futureTracks;

  isArtistMatchFilter(trackArtistName, searchedArtistName) {
    trackArtistName.toString().toLowerCase();
    searchedArtistName.toString().toLowerCase();
    print(trackArtistName);
    print(searchedArtistName);
    if (trackArtistName.toString().toLowerCase().contains(searchedArtistName.toString().toLowerCase()))
      return true;
    else
      return false;
  }

  getTracks(Map<String, dynamic> json, searchString) {
    List<Track> tracks = [];
    for (var i = 0; i < json['resultCount']; i++) {
      if (isArtistMatchFilter(json['results'][i]['artistName'], searchString)) tracks.add(Track.fromJson(json['results'][i]));
    }
    return tracks;
  }

  Future<List<Track>> fetchTracks(searchString) async {
    //replace spaces with '+' to enable multi word searches
    var filteredSearchString = searchString.replaceAll(RegExp(' '), '+');
    final response = await http.get(Uri.parse('https://itunes.apple.com/search?term=' + filteredSearchString + '&entity=musicVideo'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // return Album.fromJson(jsonDecode(response.body));
      return getTracks(jsonDecode(response.body), searchString);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load music');
    }
  }

  testFunction(val) {
    print(val);
    setState(() {
      futureTracks = fetchTracks(val);
    });
  }

  @override
  void initState() {
    super.initState();
    futureTracks = fetchTracks('');
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          searchTrackByArtist: testFunction,
        ),
        FutureBuilder<List<Track>>(
          future: futureTracks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //transform snapshot data into list of tracks, or empty array
              List<Track> tracks = snapshot.data ?? [];
              if (tracks.length > 0)
                return ExpandedTrackListView(tracks);
              //if no tracks found
              else
                return Text('Artist not found');
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else
              return const CircularProgressIndicator();
          },
        ),
      ],
    );
  }

  Expanded ExpandedTrackListView(List<Track> tracks) {
    return Expanded(
      child: ListView.builder(
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            Track track = tracks[index];
            return new ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(track.smallArtwork),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.trackName,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    track.artistName,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    track.collectionName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              onTap: () {
                openPlayer(track.trackName, track.trackURL);
              },
            );
          }),
    );
  }

  //call player widget on a bottom modal
  openPlayer(trackName, url) {
    showBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 160,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    iconSize: 20.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Center(
                  child: AudioPlayerComponent(
                    trackName: trackName,
                    trackUrl: url,
                  ),
                ),
              ],
            )
        );
      },
    );
  }
}
