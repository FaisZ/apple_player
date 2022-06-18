import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {

  Function searchTrackByArtist;

  SearchBar({required this.searchTrackByArtist});
  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('My Personal Journal');
  TextEditingController searchController = TextEditingController();
  String text = '';
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
                /* Clear the search field */
                searchController.clear();
              },
            ),
          hintText: 'Search...',
          border: InputBorder.none
        ),
        onChanged: (val){
          val = val.replaceAll(RegExp(' '), '+');
          widget.searchTrackByArtist(val);
        },
      ),
    );
  }
}