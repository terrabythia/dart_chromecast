import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dart_chromecast/casting/cast_device.dart';
import 'package:dart_chromecast/casting/cast_media.dart';
import 'package:dart_chromecast/casting/cast_media_status.dart';
import 'package:dart_chromecast/casting/cast_session.dart';
import 'package:dart_chromecast/casting/connection_channel.dart';
import 'package:dart_chromecast/casting/heartbeat_channel.dart';
import 'package:dart_chromecast/casting/media_channel.dart';
import 'package:dart_chromecast/casting/receiver_channel.dart';
import 'package:dart_chromecast/proto/cast_channel.pb.dart';

typedef void VoidCallback();

class CastSender extends Object {
  final CastDevice device;

  SecureSocket _socket;

  ConnectionChannel _connectionChannel;
  HeartbeatChannel _heartbeatChannel;
  ReceiverChannel _receiverChannel;
  MediaChannel _mediaChannel;

  bool connectionDidClose;

  Timer _heartbeatTimer;
  Timer _mediaCurrentTimeTimer;

  CastSession _castSession;
  StreamController<CastSession> castSessionController;
  StreamController<CastMediaStatus> castMediaStatusController;
  List<CastMedia> _contentQueue;
  CastMedia _currentCastMedia;

  /// Callback when volume is changed. Can also be used as a general purpose callback. I really should rename this...
  VoidCallback _volumeChangedCallback;

  // Volume and sound info
  double _currentVolume;
  int _currentBassGain;
  int _currentTrebleGain;

  // Infos for what is currently playing and which app plays it
  String _whatIsPlaying;
  String _displayAppName;
  String _currentAppSessionID;

  /// The name of the app currently playing on the device
  /// (ex: Youtube, Spotify, etc.)
  ///
  /// If the app name is not available for some reason, it will say
  /// Currently playing
  String contentProvider =
      "Currently playing"; // public since it is used outside

  /// The network url of the icon for the app that is playing
  /// (ex: youtube icon, spotify icon, etc.)
  ///
  /// Will be null if there are no icons, so check before using
  String iconUrl;

  /// OVERRIDE FOR PRINT
  ///
  /// This is there so print() is disabled in release versions.
  void customPrint(dynamic theString){
    // Comment this remove all outputs
    // print(theString);
  }

  /// The callback you set is called everytime:
  ///
  /// * the volume (or bass/treble) is changed
  /// * media playback changes (new song, etc.)
  /// * A device is removed
  ///
  /// It is called even when these things are changed from somewhere else
  /// (ie: you change the volume on the device itself)
  void setVolumeChangedCallback(VoidCallback volumeChangedCallBack) {
    _volumeChangedCallback = volumeChangedCallBack;
  }

  CastSender(this.device) {
    // TODO: _airplay._tcp
    _contentQueue = [];
    castSessionController = StreamController.broadcast();
    castMediaStatusController = StreamController.broadcast();
  }

  // TODO: reconnect if there is already a current session?
  // > ask the chromecast for the current session..
  Future<bool> connect() async {
    connectionDidClose = false;

    if (null == _castSession) {
      _castSession = CastSession(
          sourceId: 'client-${Random().nextInt(99999)}',
          destinationId: 'receiver-0');
    }

    // connect to socket
    if (null == await _createSocket()) {
      return false;
    }

    _connectionChannel.sendMessage({'type': 'CONNECT'});

    // start heartbeat
    _heartbeatTick();

    return true;
  }

  Future<bool> reconnect({String sourceId, String destinationId}) async {
    _castSession =
        CastSession(sourceId: sourceId, destinationId: destinationId);
    bool connected = await connect();
    if (!connected) {
      return false;
    }

    _mediaChannel = MediaChannel.Create(
        socket: _socket, sourceId: sourceId, destinationId: destinationId);
    _mediaChannel.sendMessage({'type': 'GET_STATUS'});

    // now wait for the media to actually get a status?
    bool didReconnect = await _waitForMediaStatus();
    if (didReconnect) {
      customPrint('reconnecting successful!');
      castSessionController.add(_castSession);
      castMediaStatusController.add(_castSession.castMediaStatus);
    }
    return didReconnect;
  }

  Future<bool> disconnect() async {
    if (null != _connectionChannel && null != _castSession?.castMediaStatus) {
      _connectionChannel.sendMessage({
        'type': 'CLOSE',
        'sessionId': _castSession.castMediaStatus.sessionId,
      });
    }
    if (null != _socket) {
      await _socket.destroy();
    }
    _dispose();
    connectionDidClose = true;
    return true;
  }

  void launch([String appId]) {
    if (null != _receiverChannel) {
      _receiverChannel.sendMessage({
        'type': 'LAUNCH',
        'appId': appId ?? 'CC1AD845',
      });
    }
  }

  void load(CastMedia media, {forceNext = true}) {
    loadPlaylist([media], forceNext: forceNext);
  }

  void loadPlaylist(List<CastMedia> media, {append: false, forceNext = false}) {
    if (!append) {
      _contentQueue = media;
    } else {
      _contentQueue.addAll(media);
    }
    if (null != _mediaChannel) {
      _handleContentQueue(forceNext: forceNext || !append);
    }
  }

  void _castMediaAction(type, [params]) {
    if (null == params) params = {};
    if (null != _mediaChannel && null != _castSession?.castMediaStatus) {
      _mediaChannel.sendMessage(params
        ..addAll({
          'mediaSessionId': _castSession.castMediaStatus.sessionId,
          'type': type,
        }));
    }
  }

  void _castReceiverAction(type, [params]) {
    if (null == params) params = {};
    if (null != _receiverChannel) {
      _receiverChannel.sendMessage(params
        ..addAll({
          'type': type,
        }));
    }
  }

  /// Sends the PLAY message on the mediachannel. This is most useful as a
  /// resume playback function
  void play() {
    _castMediaAction('PLAY');
  }

  /// Sends the PAUSE message on the mediachannel. Pauses the playback but the
  /// app running on the cast device is NOT killed.
  void pause() {
    _castMediaAction('PAUSE');
  }

  /// PLAY/PAUSE feature, uses [play()] and [pause()]
  void togglePause() {
    customPrint(_castSession.toString());
    if (true == _castSession?.castMediaStatus?.isPlaying) {
      customPrint('PAUSE');
      pause();
    } else if (true == _castSession?.castMediaStatus?.isPaused) {
      customPrint('PLAY');
      play();
    }
  }

  /// Sends the STOP message over the mediachannel. If you hit PLAY after STOP,
  /// it will start from the beginning of your clip instead of resuming.
  void stop() {
    _castMediaAction('STOP');
  }

  void seek(double time) {
    Map<String, dynamic> map = {'currentTime': time};
    _castMediaAction('SEEK', map);
  }

  /// Sets the volume with the SET_VOLUME message over the RECEIVER channel.
  /// Does NOT use the mediachannel so it works all the time.
  void setVolume(double volume) {
    Map<String, dynamic> map = {
      'volume': {"level": min(volume, 1)}
    };
    _castReceiverAction('SET_VOLUME', map);
  }

  CastSession get castSession => _castSession;

  // private

  Future<SecureSocket> _createSocket() async {
    if (null == _socket) {
      try {
        customPrint('Connecting to ${device.host}:${device.port}');

        _socket = await SecureSocket.connect(device.host, device.port,
            onBadCertificate: (X509Certificate certificate) => true,
            timeout: Duration(seconds: 10));

        _connectionChannel = ConnectionChannel.create(_socket,
            sourceId: _castSession.sourceId,
            destinationId: _castSession.destinationId);
        _heartbeatChannel = HeartbeatChannel.create(_socket,
            sourceId: _castSession.sourceId,
            destinationId: _castSession.destinationId);
        _receiverChannel = ReceiverChannel.create(_socket,
            sourceId: _castSession.sourceId,
            destinationId: _castSession.destinationId);

        _socket.listen(_onSocketData, onDone: _dispose);
      } catch (e) {
        customPrint(e.toString());
        return null;
      }
    }
    return _socket;
  }

  void _onSocketData(List<int> event) {
    List<int> slice = event.getRange(4, event.length).toList();

    CastMessage message = CastMessage.fromBuffer(slice);
    if (null != message) {
      // handle the message
      if (null != message.payloadUtf8) {
        Map<String, dynamic> payloadMap = jsonDecode(message.payloadUtf8);
        customPrint(payloadMap['type']);
        if ('CLOSE' == payloadMap['type']) {
          _dispose();
          connectionDidClose = true;
          if (_volumeChangedCallback!=null) {
            _volumeChangedCallback();
          }
        }
        if ('RECEIVER_STATUS' == payloadMap['type']) {
          _handleReceiverStatus(payloadMap);
        } else if ('MEDIA_STATUS' == payloadMap['type']) {
          _handleMediaStatus(payloadMap);
        }
      }
    }
  }

  /// Sending the GET_STATUS message over the RECEIVER channel will get use much
  /// information including the current volume
  void getVolumeRequest() {
    if (null != _receiverChannel) {
      _receiverChannel.sendMessage({
        'type': 'GET_STATUS',
      });
    }
  }

  /// Sends the STOP message with the sessionID over the RECEIVER channel. This
  /// will kill the app (ie: Spotify, Youtube, etc.) currently playing. Resume
  /// will thus not work afterwards.
  void killAppRunning() {
    customPrint(
        "----------------------------------------------------------TRYING TO KILL:");
    customPrint(_currentAppSessionID);

    if (null != _receiverChannel && _currentAppSessionID != null) {
      _receiverChannel
          .sendMessage({"type": "STOP", "sessionId": _currentAppSessionID});
    }
  }

  /// This returns the current volume, but the volume value is constantly
  /// updated when that value changes on the device. The [_volumeChangedCallback]
  /// is called when that value changes.
  double getCurrentVolume() {
    return _currentVolume;
  }

  /// This returns the current bass value, but the volume value is constantly
  /// updated when that value changes on the device. The [_volumeChangedCallback]
  /// is called when that value changes.
  ///
  /// CAN BE NULL if device has no Bass control
  int getCurrentBass() {
    return _currentBassGain;
  }

  /// This returns the current Treble value, but the volume value is constantly
  /// updated when that value changes on the device. The [_volumeChangedCallback]
  /// is called when that value changes.
  ///
  /// CAN BE NULL if device has no treble control
  int getCurrentTrebl() {
    return _currentTrebleGain;
  }

  /// Returns the name of the song playing. Sometimes it is not the trackname,
  /// depending on the app
  ///
  /// NULL if nothing is playing
  String getCurrentPlaying() {
    if (null != _mediaChannel && null != _castSession?.castMediaStatus) {
    } else {
      _whatIsPlaying = null;
    }

    return _whatIsPlaying;
  }

  void _handleReceiverStatus(Map payload) {
    customPrint(payload.toString());

    bool refresh = false;

    try {
      int newTreble = payload["status"]["userEq"]["high_shelf"]["gain_db"];
      int newBass = payload["status"]["userEq"]["low_shelf"]["gain_db"];
      if (newBass != null && newTreble != null) {
        if (newBass != _currentBassGain) {
          _currentBassGain = newBass;
          refresh = true;
        }
        if (newTreble != _currentTrebleGain) {
          _currentTrebleGain = newTreble;
          refresh = true;
        }
      }
    } catch (e) {
      //customPrint(e);
    }

    try {
      double newVolume = payload["status"]["volume"]["level"];
      if (newVolume != _currentVolume) {
        _currentVolume = newVolume;
        refresh = true;
      }
    } catch (e) {
      //customPrint(e);
    }

    // Only update UI if new values
    if (refresh) {
      if (_volumeChangedCallback != null) {
        _volumeChangedCallback();
      }
    }

    try {
      _currentAppSessionID = payload["status"]["applications"][0]["sessionId"];
    } catch (e) {
      //customPrint(e);
    }

    try {
      iconUrl = payload["status"]["applications"][0]["iconUrl"];
    } catch (e) {
      //customPrint(e);
    }

    try {
      _displayAppName = payload["status"]["applications"][0]["displayName"];
      customPrint(_displayAppName);
    } catch (e) {
      //customPrint(e);
      _displayAppName = null;
    }

    if (null == _mediaChannel &&
        true == payload['status']?.containsKey('applications')) {
      // re-create the channel with the transportId the chromecast just sent us
      if (!_castSession.isConnected) {
        _castSession = _castSession
          ..mergeWithChromeCastSessionMap(payload['status']['applications'][0]);
        _connectionChannel = ConnectionChannel.create(_socket,
            sourceId: _castSession.sourceId,
            destinationId: _castSession.destinationId);
        _connectionChannel.sendMessage({'type': 'CONNECT'});
        _mediaChannel = MediaChannel.Create(
            socket: _socket,
            sourceId: _castSession.sourceId,
            destinationId: _castSession.destinationId);
        _mediaChannel.sendMessage({'type': 'GET_STATUS'});

        castSessionController.add(_castSession);
      }
    }
  }

  Future<bool> _waitForMediaStatus() async {
    while (false == _castSession.isConnected) {
      await Future.delayed(Duration(milliseconds: 100));
      if (connectionDidClose) return false;
    }
    return _castSession.isConnected;
  }

  Future<bool> _waitForDisconnection() async {
    int timeout = (10 * 1000); // 10 seconds
    while (!connectionDidClose) {
      await Future.delayed(Duration(milliseconds: 100));
      timeout -= 100;
      if (timeout <= 0) {
        break;
      }
    }
    await _socket.close();
    return true;
  }

  void _handleMediaStatus(Map payload) {
    // Todo: only start playing the first time we get a valid media status...

    customPrint('Handle media status: ' + payload.toString());

    if (null != payload['status']) {
      if (!_castSession.isConnected) {
        _castSession.isConnected = true;
        _handleContentQueue();
      }
      if (payload['status'].length > 0) {
        _castSession.castMediaStatus =
            CastMediaStatus.fromChromeCastMediaStatus(payload['status'][0]);
        customPrint('Media status ${_castSession.castMediaStatus.toString()}');
        if (_castSession.castMediaStatus.isFinished) {
          _handleContentQueue();
        }
        if (_castSession.castMediaStatus.isPlaying) {
          // Try to get name of song if spotify is playing
          customPrint(_castSession.castMediaStatus.sessionId);
          try {
            customPrint("xxxxxxx : " + _castSession.castMediaStatus.media.toString());

            // TODO check if Youtube can simply use displayAppName
            if (_displayAppName != null) {
              contentProvider = _displayAppName;
            } else {
              contentProvider = "Currently playing";
            }

            var newPlaying =
            _castSession.castMediaStatus.media['metadata']['title'];
            if (newPlaying != _whatIsPlaying) {
              _whatIsPlaying = newPlaying;
              _volumeChangedCallback();
            }

            customPrint(_whatIsPlaying);
          } catch (e) {
            customPrint("NO TRACK TITLE AVAILABLE");
          }
          _mediaCurrentTimeTimer =
              Timer(Duration(seconds: 1), _getMediaCurrentTime);
        } else if (_castSession.castMediaStatus.isPaused &&
            null != _mediaCurrentTimeTimer) {
          _mediaCurrentTimeTimer.cancel();
          _mediaCurrentTimeTimer = null;
        }

        castMediaStatusController.add(_castSession.castMediaStatus);
      } else {
        customPrint("Media status is empty");
        if (null == _currentCastMedia && _contentQueue.length > 0) {
          customPrint(
              "no media is currently being casted, try to cast first in queue");
          _handleContentQueue();
        }
      }
    }
  }

  _handleContentQueue({forceNext = false}) {
    if (null == _mediaChannel || _contentQueue.length == 0) {
      return;
    }
    if (null != _castSession.castMediaStatus &&
        !_castSession.castMediaStatus.isFinished &&
        !forceNext) {
      // don't handle the next in the content queue, because we only want
      // to play the 'next' content if it's not already playing.
      return;
    }
    _currentCastMedia = _contentQueue.elementAt(0);
    if (null != _currentCastMedia) {
      _contentQueue = _contentQueue.getRange(1, _contentQueue.length).toList();
      _mediaChannel.sendMessage(_currentCastMedia.toChromeCastMap());
    }
  }

  void _getMediaCurrentTime() {
    if (null != _mediaChannel &&
        true == _castSession?.castMediaStatus?.isPlaying) {
      _mediaChannel.sendMessage({
        'type': 'GET_STATUS',
      });
    }
  }

  void _heartbeatTick() {
    if (null != _heartbeatChannel) {
      _heartbeatChannel.sendMessage({'type': 'PING'});

      // Update volumes with hearthbeat
      getVolumeRequest();

      _heartbeatTimer = Timer(Duration(seconds: 5), _heartbeatTick);
    }
  }

  void _dispose() {
    _socket = null;
    _heartbeatChannel = null;
    _connectionChannel = null;
    _receiverChannel = null;
    _mediaChannel = null;
    _castSession = null;
    _contentQueue = [];
  }
}
