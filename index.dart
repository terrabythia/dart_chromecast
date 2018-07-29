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
    ..addOption('port', abbr: 'p', defaultsTo: '8009')
    ..addFlag('append', abbr: 'r', defaultsTo: false);

  argResults = parser.parse(arguments);

  startCasting();

}

void startCasting() async {

  print('startCasting...');

  // try to load previous state
  Map savedState;
  try {
    File savedStateFile = await File('saved_cast_state.json');
    if (null != savedStateFile) {
      savedState = jsonDecode(await savedStateFile.readAsString());
    }
  }
  catch(e) {
    // does not exist yet
    print('error fetching saved state' + e.toString());
  }

  CastDevice device = CastDevice(
    host: argResults['host'],
    port: int.parse(argResults['port']),
    type: '_googlecast._tcp',
  );

  castSender = CastSender(
    device
  );

  castSender.on(CastSessionUpdatedEvent).listen((e) async {
    // save ids to file?
    File savedStateFile = await File('saved_cast_state.json');
    await savedStateFile.writeAsString(
      jsonEncode(e.castSession.toMap())
    );
    print('Cast session was saved.');
  });

  castSender.on(CastMediaStatusUpdatedEvent).listen((e) {
    // TODO: do something?
    // show progress for example
  });

  bool connected = false;
  bool didReconnect = false;

  print(savedState.toString());
  if (null != savedState) {
    connected = await castSender.reconnect(sourceId: savedState['sourceId'], destinationId: savedState['destinationId']);
    if (connected) {
      didReconnect = true;
    }
  }

  print('connected? ${connected.toString()}');

  if (!connected) {
    connected = await castSender.connect();
  }

  if (!connected) {
    print('COUlD NOT CONNECT!');
    return;
  }

  if (!didReconnect) {

    // dont relaunch if we just reconnected, because that would reset the player state
    castSender.launch();

  }

  List<CastMedia> media = argResults.rest.map((String i) => CastMedia(contentId:  i)).toList();
  castSender.loadPlaylist(
    media,
    append: argResults['append']
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