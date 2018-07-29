import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:args/args.dart';
import 'package:dart_chromecast/casting/cast.dart';

ArgResults argResults;
CastSender castSender;

void main(List<String> arguments) {

  final parser = new ArgParser()
    ..addOption('host', abbr: 'h', defaultsTo: '192.168.1.214')
    ..addOption('port', abbr: 'p', defaultsTo: '8009');

  argResults = parser.parse(arguments);

  startCasting();

}

void startCasting() async {

  CastDevice device = CastDevice(
    host: argResults['host'],
    port: int.parse(argResults['port']),
    type: '_googlecast._tcp',
  );

  castSender = CastSender(
    device
  );
  bool connected = await castSender.connect();

  if (!connected) {
    print('COUlD NOT CONNECT!');
    return;
  }

  castSender.launch();

  List<CastMedia> media = argResults.rest.map((String i) => CastMedia(contentId:  i)).toList();
  castSender.loadPlaylist(
      media
  );

  stdin.lineMode = false;
  stdin.listen(_handleUserInput);

}

void _handleUserInput(List<int> data) {

  if (null == castSender || data.length == 0) return;

  int keyCode = data.last;

  if (32 == keyCode) {
    // space
    castSender.togglePause();
  }
  else if (101 == keyCode) {
    // e == end
    castSender.stop();
  }
  else if (115 == keyCode) {
    // s

  }
  else if (67 == keyCode || 68 == keyCode) {
    // right or left
    double seekBy = 67 == keyCode ? 10.0 : -10.0;
    if (null != castSender.castSession && null != castSender.castSession.castMediaStatus) {

      castSender.seek(
          max(0.0, castSender.castSession.castMediaStatus.position + seekBy),
      );
    }

  }

}