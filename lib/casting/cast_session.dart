

class CastSession {

  String sourceId;
  String destinationId;

  // create from map
  CastSession.fromSessionMap(Map map) {
    sourceId = map['sourceId'];
  }

}