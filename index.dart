import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:args/args.dart';
import 'package:dart_chromecast/casting/cast.dart';

ArgResults argResults;
CastSender castSender;

void main(List<String> arguments) {

  // Create an argument parser so we can read the cli's arguments and options
  final parser = new ArgParser()
    ..addOption('host', abbr: 'h', defaultsTo: '192.168.1.214')
    ..addOption('port', abbr: 'p', defaultsTo: '8009')
    ..addFlag('append', abbr: 'r', defaultsTo: false);

  argResults = parser.parse(arguments);

  startCasting();

}

void startCasting() async {

  print('startCasting...');

  // try to load previous state saved as json in saved_cast_state.json
  Map savedState;
  try {
    File savedStateFile = await File('./saved_cast_state.json');
    if (null != savedStateFile) {
      savedState = jsonDecode(await savedStateFile.readAsString());
    }
  }
  catch(e) {
    // does not exist yet
    print('error fetching saved state' + e.toString());
  }

  // create the chromecast device with the passed in host and port
  CastDevice device = CastDevice(
    host: argResults['host'],
    port: int.parse(argResults['port']),
    type: '_googlecast._tcp',
  );

  // instantiate the chromecast sender class
  castSender = CastSender(
    device
  );

  // listen for cast session updates and save the state when
  // the device is connected
  castSender.on(CastSessionUpdatedEvent).listen((e) async {
    if (e.castSession.isConnected) {
      File savedStateFile = await File('saved_cast_state.json');
      Map map = {
        'time': DateTime.now().millisecondsSinceEpoch,
      }..addAll(
          e.castSession.toMap()
      );
      await savedStateFile.writeAsString(
          jsonEncode(map)
      );
      print('Cast session was saved.');
    }
  });

  // Listen for media status updates, such as pausing, playing, seeking, playback etc.
  castSender.on(CastMediaStatusUpdatedEvent).listen((e) {
    // TODO: do something?
    // show progress for example
  });

  bool connected = false;
  bool didReconnect = false;

  print(savedState.toString());
  if (null != savedState) {
    // If we have a saved state,
    // try to reconnect
    connected = await castSender.reconnect(
        sourceId: savedState['sourceId'],
        destinationId: savedState['destinationId'],
    );
    if (connected) {
      didReconnect = true;
    }
  }

  print('connected? ${connected.toString()}');

  // if reconnection failed or we never had a saved state to begin with
  // connect to a fresh session.
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

  // turn each rest argument string into a CastMedia instance
  List<CastMedia> media = argResults.rest.map((String i) => CastMedia(contentId:  i)).toList();

  // load CastMedia playlist and send it to the chromecast
  castSender.loadPlaylist(
    media,
    append: argResults['append']
  );

  // Initiate key press handler 
  // space = toggle pause
  // s = stop playing
  // left arrow = seek current playback - 10s
  // right arrow = seek current playback + 10s
  stdin.lineMode = false;
  stdin.listen(_handleUserInput);

}

void _handleUserInput(List<int> data) {

  if (null == castSender || data.length == 0) return;

  int keyCode = data.last;

  if (32 == keyCode) {
    // space = toggle pause
    castSender.togglePause();
  }
  else if (115 == keyCode) {
    // s == stop
    castSender.stop();
  }
  else if (67 == keyCode || 68 == keyCode) {
    // left or right = seek 10s back or forth
    double seekBy = 67 == keyCode ? 10.0 : -10.0;
    if (null != castSender.castSession && null != castSender.castSession.castMediaStatus) {
      castSender.seek(
          max(0.0, castSender.castSession.castMediaStatus.position + seekBy),
      );
    }

  }

}