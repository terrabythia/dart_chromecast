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
          destinationId: 'receiver-0'
      );
    }

    // connect to socket
    if (null == await _createSocket()) {
      return false;
    }

    _connectionChannel.sendMessage({
      'type': 'CONNECT'
    });

    // start heartbeat
    _heartbeatTick();

    return true;

  }

  Future<bool> reconnect({ String sourceId, String destinationId}) async {

    _castSession = CastSession(sourceId: sourceId, destinationId: destinationId);
    bool connected = await connect();
    if (!connected) {
      return false;
    }

    _mediaChannel = MediaChannel.Create(socket: _socket, sourceId: sourceId, destinationId: destinationId);
    _mediaChannel.sendMessage({
      'type': 'GET_STATUS'
    });

    // now wait for the media to actually get a status?
    bool didReconnect = await _waitForMediaStatus();
    if (didReconnect) {
      print('reconnecting successful!');
      castSessionController.add(
          _castSession
      );
      castMediaStatusController.add(
        _castSession.castMediaStatus
      );
    }
    return didReconnect;
  }

  Future<bool> disconnect() async {
    if (null != _connectionChannel && null != _castSession) {
      _connectionChannel.sendMessage({
        'type': 'STOP',
        'sessionId': _castSession.castMediaStatus.sessionId,
      });
      return await _waitForDisconnection();
    }
    return false;
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
    }
    else {
      _contentQueue.addAll(media);
    }
    if (null != _mediaChannel) {
      _handleContentQueue(forceNext: forceNext || !append);
    }
  }

  void _castMediaAction(type, [params]) {
    if (null == params) params = {};
    if (null != _mediaChannel && null != _castSession?.castMediaStatus) {
      _mediaChannel.sendMessage(params..addAll({
        'mediaSessionId': _castSession.castMediaStatus.sessionId,
        'type': type,
      }));
    }
  }

  void play() {
    _castMediaAction('PLAY');
  }

  void pause() {
    _castMediaAction('PAUSE');
  }

  void togglePause() {
    print(_castSession.toString());
    if (true == _castSession?.castMediaStatus?.isPlaying) {
      print('PAUSE');
      pause();
    }
    else if (true == _castSession?.castMediaStatus?.isPaused){
      print('PLAY');
      play();
    }
  }

  void stop() {
    _castMediaAction('STOP');
  }

  void seek(double time) {
    Map<String, dynamic> map = { 'currentTime': time };
    _castMediaAction('SEEK', map);
  }

  void setVolume(double volume) {
    Map<String, dynamic> map = { 'volume': min(volume, 1)};
    _castMediaAction('VOLUME', map);
  }

  CastSession get castSession => _castSession;

  // private

  Future<SecureSocket> _createSocket() async {
    if (null == _socket) {
      try {

        print('Connecting to ${device.host}:${device.port}');

        _socket = await SecureSocket.connect(
            device.host,
            device.port,
            onBadCertificate: (X509Certificate certificate) => true,
            timeout: Duration(seconds: 10));

        _connectionChannel = ConnectionChannel.create(_socket, sourceId: _castSession.sourceId, destinationId: _castSession.destinationId);
        _heartbeatChannel = HeartbeatChannel.create(_socket, sourceId: _castSession.sourceId, destinationId: _castSession.destinationId);
        _receiverChannel = ReceiverChannel.create(_socket, sourceId: _castSession.sourceId, destinationId: _castSession.destinationId);

        _socket.listen(
            _onSocketData,
            onDone: _dispose
        );

      }
      catch(e) {
        print(e.toString());
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
        print(payloadMap['type']);
        if ('CLOSE' == payloadMap['type']) {
          _dispose();
          connectionDidClose = true;
        }
        if ('RECEIVER_STATUS' == payloadMap['type']) {
          _handleReceiverStatus(payloadMap);
        }
        else if ('MEDIA_STATUS' == payloadMap['type']) {
          _handleMediaStatus(payloadMap);
        }
      }
    }
  }

  void _handleReceiverStatus(Map payload) {
    print(payload.toString());
    if (null == _mediaChannel && true == payload['status']?.containsKey('applications')) {
      // re-create the channel with the transportId the chromecast just sent us
      if (!_castSession.isConnected) {
        _castSession = _castSession..mergeWithChromeCastSessionMap(payload['status']['applications'][0]);
        _connectionChannel = ConnectionChannel.create(_socket, sourceId: _castSession.sourceId, destinationId: _castSession.destinationId);
        _connectionChannel.sendMessage({
          'type': 'CONNECT'
        });
        _mediaChannel = MediaChannel.Create(socket: _socket, sourceId: _castSession.sourceId, destinationId: _castSession.destinationId);
        _mediaChannel.sendMessage({
          'type': 'GET_STATUS'
        });

        castSessionController.add(
            _castSession
        );
      }
    }
  }

  Future<bool> _waitForMediaStatus() async {
    while(false == _castSession.isConnected) {
      await Future.delayed(Duration(milliseconds: 100));
      if (connectionDidClose) return false;
    }
    return _castSession.isConnected;
  }

  Future<bool> _waitForDisconnection() async {
    int timeout = (10 * 1000); // 10 seconds
    while(!connectionDidClose) {
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

    print('Handle media status: ' +  payload.toString());

    if (null != payload['status']) {
      if (!_castSession.isConnected) {
        _castSession.isConnected = true;
        _handleContentQueue();
      }
      if (payload['status'].length > 0) {
        _castSession.castMediaStatus = CastMediaStatus.fromChromeCastMediaStatus(
            payload['status'][0]
        );
        print('Media status ${_castSession.castMediaStatus.toString()}');
        if (_castSession.castMediaStatus.isFinished) {
          _handleContentQueue();
        }
        if (_castSession.castMediaStatus.isPlaying) {
          _mediaCurrentTimeTimer = Timer(Duration(seconds: 1), _getMediaCurrentTime);
        }
        else if (_castSession.castMediaStatus.isPaused && null != _mediaCurrentTimeTimer) {
          _mediaCurrentTimeTimer.cancel();
          _mediaCurrentTimeTimer = null;
        }

        castMediaStatusController.add(
            _castSession.castMediaStatus
        );

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
    CastMedia nextContentId = _contentQueue.elementAt(0);
    if (null != nextContentId) {
      _contentQueue = _contentQueue.getRange(1, _contentQueue.length).toList();
      _mediaChannel.sendMessage(
        nextContentId.toChromeCastMap()
      );
    }
  }

  void _getMediaCurrentTime() {

    if (null != _mediaChannel && true == _castSession?.castMediaStatus?.isPlaying) {
      _mediaChannel.sendMessage({
        'type': 'GET_STATUS',
      });
    }

  }

  void _heartbeatTick() {

    if (null != _heartbeatChannel) {
      _heartbeatChannel.sendMessage({
        'type': 'PING'
      });

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