import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_chromecast/casting/cast.dart';

ArgResults argResults;
CastSender castSender;

void main(List<String> arguments) {

  final parser = new ArgParser()
    ..addOption('host', abbr: 'h', defaultsTo: '192.168.1.210')
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
  castSender.loadPlaylist(argResults.rest);

  stdin.lineMode = false;
  stdin.listen(_handleUserInput);

}

void _handleUserInput(List<int> data) {

  if (null == castSender) return;

  String input = utf8.decode(data);
  print('input! ' + input);
  if (input.length > 0) {
    String key = input.split('').first.toLowerCase();
    if (' ' == key) {
      castSender.togglePause();
    }
    else if ('e' == key) {
      castSender.stop();
    }
    else if ('s' == key) {
      castSender.seek(10.0);
    }
  }

}