class CastMedia {
  final String contentId;
  String title;
  bool autoPlay = true;
  double position;
  String contentType;
  String artist;
  String albumName;
  List<String> images;

  CastMedia({
    this.contentId,
    this.title,
    this.artist,
    this.albumName,
    this.autoPlay = true,
    this.position = 0.0,
    this.contentType = 'video/mp4',
    this.images,
  }) {
    if (null == images) {
      images = [];
    }
  }

  Map toChromeCastMap() {
    return {
      'type': 'LOAD',
      'autoPlay': autoPlay,
      'currentTime': position,
      'activeTracks': [],
      'media': {
        'contentId': contentId,
        'contentType': contentType,
        'streamType': 'BUFFERED',
        'metadata': {
          'type': 0,
          'metadataType': 3,
          'albumName': albumName ?? "",
          'artist': artist ?? "",
          'title': title,
          'images': images.map((e) => {'url': e}).toList()
        },
      }
    };
  }
}
