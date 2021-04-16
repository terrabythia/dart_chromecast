import 'package:dart_chromecast/casting/cast_media_status.dart';

class CastSession {

  String? sourceId;
  String? destinationId;
  CastMediaStatus? castMediaStatus;

  bool isConnected;
  bool isReadyForMedia = false;

  CastSession({ this.sourceId, this.destinationId, this.isConnected = false });

  // create from chromecast map
  void mergeWithChromeCastSessionMap(Map map) {
    isConnected = true;
    sourceId = map['sourceId'] ?? sourceId;
    destinationId = map['transportId'] ?? map['sessionId'];
  }

  // TODO: from apple tv map

  Map<String, String?> toMap() {
    return {
      'sourceId': sourceId,
      'destinationId': destinationId,
    };
  }

}