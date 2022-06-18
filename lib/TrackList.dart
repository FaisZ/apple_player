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
  var selectedTrack;

  //to only filter artist from search string
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
    //get individual track in a list from the resultant json
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
      return getTracks(jsonDecode(response.body), searchString);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load music');
    }
  }

  searchTrackByArtist(val) {
    setState(() {
      futureTracks = fetchTracks(val);
    });
  }

  selectTrack(selectedIndex){
    setState(() {
      selectedTrack = selectedIndex;
    });
  }
  @override
  void initState() {
    super.initState();
    futureTracks = fetchTracks('');
    selectedTrack = -1;
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          searchTrackByArtist: searchTrackByArtist,
        ),
        FutureBuilder<List<Track>>(
          future: futureTracks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //transform snapshot data into list of tracks, or empty array
              List<Track> tracks = snapshot.data ?? [];
              if (tracks.length > 0)
                return ExpandedTrackListView(tracks, selectTrack);
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

  Expanded ExpandedTrackListView(List<Track> tracks, selectTrackFunction) {

    return Expanded(
      child: ListView.builder(
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            Track track = tracks[index];
            return new ListTile(
              leading: Container(
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(track.smallArtwork)),
                  shape: BoxShape.rectangle,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.trackName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                  Text(
                    track.artistName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                  Text(
                    track.collectionName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14
                    ),
                  ),
                ],
              ),
              trailing: (selectedTrack == index) ? const Icon(Icons.audiotrack) : null,
              onTap: () {
                openPlayer(track.trackName, track.trackURL, index, selectTrackFunction);
              },
            );
          }),
    );
  }

  //call player widget on a bottom modal
  openPlayer(trackName, url, trackIndex, selectTrackFunction) {
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
                      //hide selected playing song indicator when player closed
                      selectTrackFunction(-1);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Center(
                  //pass selectTrackFunction and trackIndex to enable playing song indicator based on play/pause state
                  child: AudioPlayerComponent(
                    trackName: trackName,
                    trackUrl: url,
                    trackIndex: trackIndex,
                    selectTrackFunction: selectTrackFunction,
                  ),
                ),
              ],
            )
        );
      },
    );
  }
}
