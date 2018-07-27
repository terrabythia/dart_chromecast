class CastMediaStatus {

  bool isPaused;
  bool isMuted ;
  bool isLoading;
  bool isBuffering;
  double volume;
  double position;

  CastMediaStatus.fromMap(Map map)
      : isPaused = map['is_paused'],
        isMuted = map['is_muted'],
        isLoading = map['is_loading'],
        isBuffering = map['is_buffering'],
        volume = map['volume'],
        position = map['position'];


}