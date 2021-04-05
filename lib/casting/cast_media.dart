class CastMedia {

  final String? contentId;
  String? title;
  bool autoPlay = true;
  double position;
  String contentType;
  List<String>? images;

  CastMedia({
    this.contentId,
    this.title,
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
        'images': images,
        'title': title,
        'streamType': 'BUFFERED',
      }
    };
  }

}