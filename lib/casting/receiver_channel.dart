import 'dart:io';

import 'package:dart_chromecast_cli/casting/cast_channel.dart';
import 'package:dart_chromecast_cli/proto/cast_channel.pb.dart';

class ReceiverChannel extends CastChannel {

  ReceiverChannel.CreateWithSocket(Socket socket, {String sourceId, String destinationId}) :
        super.CreateWithSocket(socket, sourceId: sourceId ?? 'sender-0', destinationId: destinationId ?? 'receiver-0', namespace: 'urn:x-cast:com.google.cast.receiver');

}