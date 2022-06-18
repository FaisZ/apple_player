class Track {
  final int trackId;
  final String artistName;
  final String collectionName;
  final String trackName;
  final String smallArtwork;
  final String trackURL;

  const Track({
    required this.trackId,
    required this.artistName,
    required this.collectionName,
    required this.trackName,
    required this.smallArtwork,
    required this.trackURL,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    // String album = json['collectionName'];
    //   album='unknown';

    return Track(
      trackId: json['trackId'],
      artistName: json['artistName'],
      collectionName: (json['collectionName']) ?? '',
      // collectionName: album,
      trackName: json['trackName'],
      smallArtwork: json['artworkUrl30'],
      trackURL: json['previewUrl'],
    );
  }
}