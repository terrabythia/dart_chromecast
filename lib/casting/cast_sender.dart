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

class CastSender {

  final CastDevice device;

  String sourceId;
  String destinationId;

  SecureSocket _socket;

  ConnectionChannel _connectionChannel;
  HeartbeatChannel _heartbeatChannel;
  ReceiverChannel _receiverChannel;
  MediaChannel _mediaChannel;

  Timer _heartbeatTimer;
  Timer _mediaCurrentTimeTimer;

  bool _mediaReady = false;
  CastSession _castSession;
  List<CastMedia> _contentQueue;

  CastSender(this.device) {
      // TODO: _airplay._tcp
    _contentQueue = [];
    sourceId = 'client-${Random().nextInt(99999)}';
  }

  Future<bool> connect() async {

    // connect to socket
    try {
      print('Connecting to ${device.host}:${device.port}');
      _socket = await SecureSocket.connect(
          device.host,
          device.port,
          onBadCertificate: (X509Certificate certificate) => true,
         timeout: Duration(seconds: 10));
    }
    catch(e) {
      print(e.toString());
      return false;
    }

    _connectionChannel = ConnectionChannel.CreateWithSocket(_socket, sourceId: sourceId);
    _heartbeatChannel = HeartbeatChannel.CreateWithSocket(_socket, sourceId: sourceId);
    _receiverChannel = ReceiverChannel.CreateWithSocket(_socket, sourceId: sourceId);

    _socket.listen(_onSocketData);

    _connectionChannel.sendMessage({
      'type': 'CONNECT'
    });

    // start heartbeat
    _heartbeatTick();

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

  void load(CastMedia media, [forceNext = true]) {
    loadPlaylist([media], forceNext);
  }

  void loadPlaylist(List<CastMedia> media, [forceNext = false]) {
    _contentQueue = media;
    if (null != _mediaChannel) {
      _handleContentQueue(forceNext);
    }
  }

  void _castMediaAction(type, [params]) {
    if (null == params) params = {};
    if (null != _mediaChannel && null != _castSession && null != _castSession.castMediaStatus) {
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
    if (null != _castSession && null != _castSession.castMediaStatus && !_castSession.castMediaStatus.isPaused) {
      pause();
    }
    else {
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
  void _onSocketData(List<int> event) {
    List<int> slice = event.getRange(4, event.length).toList();

    CastMessage message = CastMessage.fromBuffer(slice);
    if (null != message) {
      // handle the message
      if (null != message.payloadUtf8) {
        Map<String, dynamic> payloadMap = jsonDecode(message.payloadUtf8);
        print(payloadMap['type']);
        if ('CLOSE' == payloadMap['type']) {
          print(payloadMap.toString());
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
    if (null == _mediaChannel && null != payload['status'] && null != payload['status']['applications']) {
      if (null == destinationId) {
        destinationId = payload['status']['applications'][0]['transportId'] ?? payload['status']['applications'][0]['sessionId'];
        // re-create the channel with the transportId the chromecast just sent us
        _castSession = CastSession.fromChromeCastSessionMap(payload['status']['applications'][0]);
        _connectionChannel = ConnectionChannel.CreateWithSocket(_socket, sourceId: sourceId, destinationId: destinationId);
        _connectionChannel.sendMessage({
          'type': 'CONNECT'
        });
        _mediaChannel = MediaChannel.Create(socket: _socket, sourceId: sourceId, destinationId: destinationId);
        _mediaChannel.sendMessage({
          'type': 'GET_STATUS'
        });
      }
    }
  }

  void _handleMediaStatus(Map payload) {
    // Todo: only start playing the first time we get a valid media status...

    if (null != payload['status'] && payload['status'].length > 0) {
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
    }

    if (!_mediaReady) {
      // first media status; chromecast is ready.
      _handleContentQueue();
      _mediaReady = true;
    }

  }

  _handleContentQueue([forceNext = false]) {
    if (null == _mediaChannel || _contentQueue.length == 0) {
      return;
    }
    if (null != _castSession &&
        null != _castSession.castMediaStatus &&
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

    if (null != _mediaChannel && null != _castSession && null != _castSession.castMediaStatus &&  _castSession.castMediaStatus.isPlaying) {
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

}