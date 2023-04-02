import 'package:dart_chromecast/casting/cast_channel.dart';
import 'package:universal_io/io.dart';

class HeartbeatChannel extends CastChannel {
  HeartbeatChannel.create(Socket? socket,
      {String? sourceId, String? destinationId})
      : super.CreateWithSocket(socket,
            sourceId: sourceId ?? 'sender-0',
            destinationId: destinationId ?? 'receiver-0',
            namespace: 'urn:x-cast:com.google.cast.tp.heartbeat');
}
