import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import './../writer.dart';
import '../proto/cast_channel.pb.dart';

abstract class CastChannel {
  static int _requestId = 1;

  final Socket? _socket;
  String? _sourceId;
  String? _destinationId;
  String? _namespace;

  CastChannel(
      this._socket, this._sourceId, this._destinationId, this._namespace);

  CastChannel.CreateWithSocket(Socket? socket,
      {String? sourceId, String? destinationId, String? namespace})
      : _socket = socket,
        _sourceId = sourceId,
        _destinationId = destinationId,
        _namespace = namespace;

  void sendMessage(Map payload) async {
    payload['requestId'] = _requestId;

    CastMessage castMessage = CastMessage();
    castMessage.protocolVersion = CastMessage_ProtocolVersion.CASTV2_1_0;
    castMessage.sourceId = _sourceId!;
    castMessage.destinationId = _destinationId!;
    castMessage.namespace = _namespace!;
    castMessage.payloadType = CastMessage_PayloadType.STRING;
    castMessage.payloadUtf8 = jsonEncode(payload);

    Uint8List bytes = castMessage.writeToBuffer();
    Uint32List headers = Uint32List.fromList(writeUInt32BE(
        List<int>.filled(4, 0, growable: false), bytes.lengthInBytes));
    Uint32List fullData =
        Uint32List.fromList(headers.toList()..addAll(bytes.toList()));

    if ('PING' != payload['type']) {
      // print('Send: ${castMessage.toDebugString()}');
      // print('List: ${fullData.toList().toString()}');

    } else {
      print('PING');
    }

    _socket!.add(fullData);

    _requestId++;
  }
}
