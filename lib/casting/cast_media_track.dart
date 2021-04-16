/**
 * @see https://github.com/thibauts/node-castv2-client/wiki/How-to-use-subtitles-with-the-DefaultMediaReceiver-app
 */
class CastMediaTrack {

  /**
   * This is an unique ID, used to reference the track
   */
  int trackId;

  /**
   * Default Media Receiver currently only supports TEXT
   */
  String type;

  /**
   * The URL of the VTT
   */
  String trackContentId;

  /**
   * Currently only VTT is supported
   */
  String trackContentType;

  /**
   *  A Name for humans
   */
  String name;

  /**
   * The language
   */
  String language;

  /**
   * Should be SUBTITLES
   */
  String subtype;

  CastMediaTrack({
    this.trackId,
    this.type = 'TEXT',
    this.trackContentId,
    this.trackContentType = 'text/vtt',
    this.name,
    this.language,
    this.subtype = 'SUBTITLES',
  }) {

  }

  Map toChromeCastMap() {
    return {
      'trackId': trackId,
      'type': type,
      'trackContentId': trackContentId,
      'trackContentType': trackContentType,
      'name': name,
      'language': language,
      'subtype': subtype,
    };
  }

  static List<Map> listToChromeCastMap(List<CastMediaTrack> listTrackMedia) {
    return listTrackMedia.map((trackMediaItem) => trackMediaItem.toChromeCastMap()).toList();
  }
}