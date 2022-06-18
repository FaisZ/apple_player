//The model class for tracks
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

  //function to translate apple's json return and only extract needed values
  factory Track.fromJson(Map<String, dynamic> json) {

    return Track(
      trackId: json['trackId'] ?? '',
      artistName: json['artistName'] ?? '',
      collectionName: (json['collectionName']) ?? '',
      trackName: json['trackName'] ?? '',
      smallArtwork: json['artworkUrl60'] ?? '',
      trackURL: json['previewUrl'] ?? '',
    );
  }
}