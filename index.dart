import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:logging/logging.dart';

import 'package:args/args.dart';
import 'package:dart_chromecast/casting/cast.dart';

final Logger log = new Logger('Chromecast CLI');

void main(List<String> arguments) {

  // Create an argument parser so we can read the cli's arguments and options
  final parser = new ArgParser()
    ..addOption('host', abbr: 'h', defaultsTo: '192.168.1.214')
    ..addOption('port', abbr: 'p', defaultsTo: '8009')
    ..addFlag('append', abbr: 'a', defaultsTo: false)
    ..addFlag('debug', abbr: 'd', defaultsTo: false);

  final ArgResults argResults = parser.parse(arguments);

  if (true == argResults['debug'] ) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.message}');
    });
  }
  else {
    Logger.root.level = Level.OFF;
  }

  // turn each rest argument string into a CastMedia instance
  final List<CastMedia> media = argResults.rest.map((String i) => CastMedia(contentId:  i)).toList();

  startCasting(media, argResults['host'], int.parse(argResults['port']), argResults['append']);

}

void startCasting(List<CastMedia> media, String host, int port, bool append) async {

  log.fine('Start Casting');

  Function logCallback = (Object error, String logMessage) {
    if (null != error) {
      log.info(logMessage);
    }
    else {
      log.warning(logMessage, error);
    }
  };

  // try to load previous state saved as json in saved_cast_state.json
  Map savedState;
  try {
    File savedStateFile = await File("./saved_cast_state.json");
    if (null != savedStateFile) {
      savedState = jsonDecode(await savedStateFile.readAsString());
    }
  }
  catch(e) {
    // does not exist yet
    log.warning('error fetching saved state' + e.toString());
  }

  // create the chromecast device with the passed in host and port
  final CastDevice device = CastDevice(
    host: host,
    port: port,
    type: '_googlecast._tcp',
  );

  // instantiate the chromecast sender class
  final CastSender castSender = CastSender(
    device,
  );

  if (Level.OFF != Logger.root.level) {
//    castSender.setLogCallback(logCallback);
  }

  // listen for cast session updates and save the state when
  // the device is connected
  castSender.castSessionController.stream.listen((CastSession castSession) async {
    if (castSession.isConnected) {
      File savedStateFile = await File('./saved_cast_state.json');
      Map map = {
        'time': DateTime.now().millisecondsSinceEpoch,
      }..addAll(
          castSession.toMap()
      );
      await savedStateFile.writeAsString(
          jsonEncode(map)
      );
      log.fine('Cast session was saved to saved_cat_state.json.');
    }
  });

  CastMediaStatus prevMediaStatus;
  // Listen for media status updates, such as pausing, playing, seeking, playback etc.
  castSender.castMediaStatusController.stream.listen((CastMediaStatus mediaStatus) {
    // show progress for example
    if (null != prevMediaStatus && mediaStatus.volume != prevMediaStatus.volume) {
      // volume just updated
      log.info('Volume just updated to ${mediaStatus.volume}');
    }
    if (null == prevMediaStatus || mediaStatus?.position != prevMediaStatus?.position) {
      // update the current progress
      log.info('Media Position is ${mediaStatus?.position}');
    }
    prevMediaStatus = mediaStatus;

  });

  bool connected = false;
  bool didReconnect = false;

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

  log.fine('connected? ${connected.toString()}');

  // if reconnection failed or we never had a saved state to begin with
  // connect to a fresh session.
  if (!connected) {
    connected = await castSender.connect();
  }

  if (!connected) {
    log.warning('COUlD NOT CONNECT!');
    return;
  }

  if (!didReconnect) {
    // dont relaunch if we just reconnected, because that would reset the player state
    castSender.launch();
  }

  // load CastMedia playlist and send it to the chromecast
  castSender.loadPlaylist(
      media,
      append: append
  );

  // Initiate key press handler
  // space = toggle pause
  // s = stop playing
  // left arrow = seek current playback - 10s
  // right arrow = seek current playback + 10s
  stdin.echoMode = false;
  stdin.lineMode = false;

  stdin.asBroadcastStream().listen((List<int> data) {
      _handleUserInput(castSender, data);
  });
//  stdin.asBroadcastStream().listen(_handleUserInput);

}

void _handleUserInput(CastSender castSender, List<int> data) {

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
  else if (27 == keyCode) {
    // escape = disconnect
    castSender.disconnect();
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
