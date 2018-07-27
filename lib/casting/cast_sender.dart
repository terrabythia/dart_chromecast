import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dart_chromecast_cli/casting/cast_device.dart';
import 'package:dart_chromecast_cli/casting/connection_channel.dart';
import 'package:dart_chromecast_cli/casting/heartbeat_channel.dart';
import 'package:dart_chromecast_cli/casting/media_channel.dart';
import 'package:dart_chromecast_cli/casting/receiver_channel.dart';
import 'package:dart_chromecast_cli/proto/cast_channel.pb.dart';

class CastSender {

  final CastDevice device;

  String sourceId;
  String destinationId;

  SecureSocket _socket;

  ConnectionChannel _connectionChannel;
  HeartbeatChannel _heartbeatChannel;
  ReceiverChannel _receiverChannel;
  MediaChannel _mediaChannel;

  bool _mediaReady = false;
  Map _mediaStatus;
  List<String> _contentQueue;

  CastSender(this.device) {
      // _airplay._tcp > todo?
    _contentQueue = [];
    sourceId = 'client-${Random().nextInt(99999)}';
  }

  Future<bool> connect() async {

    // connect to socket
    try {
      _socket = await SecureSocket.connect(device.host, device.port, onBadCertificate: (X509Certificate certificate) => true);
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

  void load(String contentId, [forceNext = true]) {
    loadPlaylist([contentId], forceNext);
  }

  void loadPlaylist(List<String> contentIds, [forceNext = false]) {
    _contentQueue = contentIds;
    if (null != _mediaChannel) {
      _handleContentQueue(forceNext);
    }
  }

  void play() {
    if (null != _mediaChannel && null != _mediaStatus && null != _mediaStatus['mediaSessionId']) {
      _mediaChannel.sendMessage({
        'mediaSessionId': _mediaStatus['mediaSessionId'],
        'type': 'PLAY',
      });
    }
  }

  void pause() {
    if (null != _mediaChannel && null != _mediaStatus && null != _mediaStatus['mediaSessionId']) {
      _mediaChannel.sendMessage({
        'mediaSessionId': _mediaStatus['mediaSessionId'],
        'type': 'PAUSE',
      });
    }
  }

  void togglePause() {
    if (null != _mediaChannel && null != _mediaStatus && null != _mediaStatus['mediaSessionId']) {
      if ('PLAYING' == _mediaStatus['playerState']) {
        pause();
      }
      else if ('PAUSED' == _mediaStatus['playerState']) {
        play();
      }
    }
  }

  void stop() {
    if (null != _mediaChannel && null != _mediaStatus && null != _mediaStatus['mediaSessionId']) {
      _mediaChannel.sendMessage({
        'mediaSessionId': _mediaStatus['mediaSessionId'],
        'type': 'STOP',
      });
    }
  }

  void seek(double time) {
    if (null != _mediaChannel && null != _mediaStatus && null != _mediaStatus['mediaSessionId']) {
      _mediaChannel.sendMessage({
        'mediaSessionId': _mediaStatus['mediaSessionId'],
        'type': 'SEEK',
        'currentTime': time
      });
    }
  }

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
    if (!_mediaReady) {
      // first media status; chromecast is ready.
      _handleContentQueue();
      _mediaReady = true;
    }

    if (null != payload['status'] && payload['status'].length > 0) {
      _mediaStatus = payload['status'][0];
      if ('IDLE' == _mediaStatus['playerState'] && 'FINISHED' == _mediaStatus['idleReason']) {
        _handleContentQueue();
      }
    }
  }

  _handleContentQueue([forceNext = false]) {
    if (null == _mediaChannel || _contentQueue.length == 0) {
      return;
    }
    String nextContentId = _contentQueue.elementAt(0);
    if (null != nextContentId) {
      _contentQueue = _contentQueue.getRange(1, _contentQueue.length).toList();
      _mediaChannel.sendMessage({
        'type': 'LOAD',
        'autoPlay': true,
        'currentTime': 0,
        'activeTracks': [],
        'media': {
          'contentId': nextContentId,
          'contentType': 'video/mp4',
          'streamType': 'BUFFERED',
        },
      });
    }
  }

  void _heartbeatTick() {

    _heartbeatChannel.sendMessage({
      'type': 'PING'
    });

    Timer(Duration(seconds: 5), _heartbeatTick);

  }


}