import 'package:dart_chromecast/casting/cast_media_status.dart';

class CastSession {

  final String sourceId;
  final String destinationId;
  CastMediaStatus castMediaStatus;

  // create from map
  CastSession.fromChromeCastSessionMap(Map map) :
      sourceId = map['sourceId'],
      destinationId = map['transportId'] ?? map['sessionId'];



}