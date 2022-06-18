import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {

  //link to parent widget function to search tracks
  final Function searchTrackByArtist;

  SearchBar({required this.searchTrackByArtist});
  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
                //also reset search string
                widget.searchTrackByArtist('');
              },
            ),
          hintText: 'Search...',
          border: InputBorder.none
        ),
        onChanged: (val){
          widget.searchTrackByArtist(val);
        },
      ),
    );
  }
}