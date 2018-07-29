

class CastMedia {

  final String contentId;
  bool _autoPlay;
  double _position;
  String _contentType;


  CastMedia({ this.contentId, bool autoPlay = true, double position = 0.0, String contentType = 'video/mp4'}) {
    _autoPlay = autoPlay;
    _position = position;
    _contentType = contentType;
  }

  Map toChromeCastMap() {
    return {
      'type': 'LOAD',
      'autoPlay': _autoPlay,
      'currentTime': _position,
      'activeTracks': [],
      'media': {
        'contentId': contentId,
        'contentType': _contentType,
        'streamType': 'BUFFERED',
      }
    };
  }

}