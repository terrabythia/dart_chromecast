class CastMedia {
  final String? contentId;
  String? title;
  String? subtitle;
  bool autoPlay = true;
  double position;
  double playbackRate;
  String contentType;
  List<String>? images;

  CastMedia({
    this.contentId,
    this.title,
    this.subtitle,
    this.autoPlay = true,
    this.position = 0.0,
    this.playbackRate = 1.0,
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
      'playbackRate': playbackRate,
      'activeTracks': [],
      'media': {
        'contentId': contentId,
        'contentType': contentType,
        'streamType': 'BUFFERED',
        'metadata': {
          'metadataType': 0,
          'images': images?.map((image) => {'url': image}).toList(),
          'title': title,
          'subtitle': subtitle,
        },
      }
    };
  }
}
