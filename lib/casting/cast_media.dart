import 'cast.dart';

class CastMedia {

  final String contentId;
  String title;
  bool autoPlay = true;
  double position;
  double playbackRate;
  String contentType;
  List<String> images;
  List<int> activeTrackIds;
  List<CastMediaTrack> tracks;
  CastMediaTextTrackStyle textTrackStyle;

  CastMedia({
    this.contentId,
    this.title,
    this.autoPlay = true,
    this.position = 0.0,
    this.playbackRate = 1.0,
    this.contentType = 'video/mp4',
    this.images,
    this.activeTrackIds,
    this.tracks,
    this.textTrackStyle,
  }) {
    if (null == images) {
      images = [];
    }

    if (null == activeTrackIds) {
      activeTrackIds = [];
    }

    if (null == tracks) {
      tracks = [];
    }

    if (null == textTrackStyle) {
      textTrackStyle = CastMediaTextTrackStyle();
    }
  }

  Map toChromeCastMap() {
    return {
      'type': 'LOAD',
      'autoPlay': autoPlay,
      'currentTime': position,
      'playbackRate': playbackRate,
      'activeTrackIds': activeTrackIds,
      'media': {
        'contentId': contentId,
        'contentType': contentType,
        'images': images,
        'title': title,
        'streamType': 'BUFFERED',
        'tracks': CastMediaTrack.listToChromeCastMap(tracks),
        "textTrackStyle": textTrackStyle.toChromeCastMap()
      }
    };
  }

}