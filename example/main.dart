import 'dart:convert';
import 'dart:math';

import 'package:args/args.dart';
import 'package:dart_chromecast/casting/cast.dart';
import 'package:dart_chromecast/utils/mdns_find_chromecast.dart'
    as find_chromecast;
import 'package:logging/logging.dart';
import 'package:universal_io/io.dart';

final Logger log = new Logger('Chromecast CLI');

void main(List<String> arguments) async {
  // Create an argument parser so we can read the cli's arguments and options
  final parser = new ArgParser()
    ..addOption('host', abbr: 'h', defaultsTo: '')
    ..addOption('port', abbr: 'p', defaultsTo: '8009')
    ..addOption('title', abbr: 't', defaultsTo: null)
    ..addOption('subtitle', abbr: 's', defaultsTo: null)
    ..addOption('image', abbr: 'i', defaultsTo: '')
    ..addFlag('append', abbr: 'a', defaultsTo: false)
    ..addFlag('debug', abbr: 'd', defaultsTo: false);

  final ArgResults argResults = parser.parse(arguments);

  if (true == argResults['debug']) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.message}');
    });
  } else {
    Logger.root.level = Level.OFF;
  }

  String imageUrl = argResults['image'];
  final List<String> images = imageUrl != '' ? [imageUrl] : [];

  // turn each rest argument string into a CastMedia instance
  final List<CastMedia> media = argResults.rest
      .map((String i) => CastMedia(
          contentId: i,
          images: images,
          title: argResults['title'],
          subtitle: argResults['subtitle']))
      .toList();

  String host = argResults['host'];
  int? port = int.parse(argResults['port']);
  if ('' == host.trim()) {
    // search!
    print('Looking for ChromeCast devices...');

    List<find_chromecast.CastDevice> devices =
        await find_chromecast.find_chromecasts();
    if (devices.length == 0) {
      print('No devices found!');
      return;
    }

    print("Found ${devices.length} devices:");
    for (int i = 0; i < devices.length; i++) {
      int index = i + 1;
      find_chromecast.CastDevice device = devices[i];
      print("$index: ${device.name}");
    }

    print("Pick a device (1-${devices.length}):");

    int? choice;

    while (choice == null || choice < 0 || choice > devices.length) {
      choice = int.parse(stdin.readLineSync()!);
      print(
          "Please pick a number (1-${devices.length}) or press return to search again");
    }

    find_chromecast.CastDevice pickedDevice = devices[choice - 1];

    host = pickedDevice.ip!;
    port = pickedDevice.port;

    print("Connecting to device: $host:$port");

    log.fine("Picked: $pickedDevice");
  }

  startCasting(media, host, port, argResults['append']);
}

void startCasting(
    List<CastMedia> media, String host, int? port, bool? append) async {
  log.fine('Start Casting');

  // try to load previous state saved as json in saved_cast_state.json
  Map? savedState;
  try {
    File savedStateFile = File("./saved_cast_state.json");
    savedState = jsonDecode(await savedStateFile.readAsString());
  } catch (e) {
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

  // listen for cast session updates and save the state when
  // the device is connected
  castSender.castSessionController.stream
      .listen((CastSession? castSession) async {
    if (castSession!.isConnected) {
      File savedStateFile = File('./saved_cast_state.json');
      Map map = {
        'time': DateTime.now().millisecondsSinceEpoch,
      }..addAll(castSession.toMap());
      await savedStateFile.writeAsString(jsonEncode(map));
      log.fine('Cast session was saved to saved_cast_state.json.');
    }
  });

  CastMediaStatus? prevMediaStatus;
  // Listen for media status updates, such as pausing, playing, seeking, playback etc.
  castSender.castMediaStatusController.stream
      .listen((CastMediaStatus? mediaStatus) {
    // show progress for example
    if (mediaStatus == null) {
      return;
    }
    if (null != prevMediaStatus &&
        mediaStatus.volume != prevMediaStatus!.volume) {
      // volume just updated
      log.info('Volume just updated to ${mediaStatus.volume}');
    }
    if (null == prevMediaStatus ||
        mediaStatus.position != prevMediaStatus?.position) {
      // update the current progress
      log.info('Media Position is ${mediaStatus.position}');
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

  // if reconnection failed or we never had a saved state to begin with
  // connect to a fresh session.
  if (!connected) {
    connected = await castSender.connect();
  }

  if (!connected) {
    log.warning('COULD NOT CONNECT!');
    return;
  }
  log.info("Connected with device");

  if (!didReconnect) {
    // dont relaunch if we just reconnected, because that would reset the player state
    castSender.launch();
  }

  // load CastMedia playlist and send it to the chromecast
  castSender.loadPlaylist(media, append: append);

  // Initiate key press handler
  // space = toggle pause
  // s = stop playing
  // left arrow = seek current playback - 10s
  // right arrow = seek current playback + 10s
  // up arrow = volume up 5%
  // down arrow = volume down 5%
  stdin.echoMode = false;
  stdin.lineMode = false;

  stdin.asBroadcastStream().listen((List<int> data) {
    _handleUserInput(castSender, data);
  });
}

void _handleUserInput(CastSender castSender, List<int> data) {
  if (data.length == 0) return;

  int keyCode = data.last;

  log.info("pressed key with key code: ${keyCode}");

  if (32 == keyCode) {
    // space = toggle pause
    castSender.togglePause();
  } else if (115 == keyCode) {
    // s == stop
    castSender.stop();
  } else if (27 == keyCode) {
    // escape = disconnect
    castSender.disconnect();
  } else if (65 == keyCode) {
    // up
    double? volume = castSender.castSession?.castMediaStatus?.volume;
    if (volume != null) {
      castSender.setVolume(min(1, volume + 0.1));
    }
  } else if (66 == keyCode) {
    // down
    double? volume = castSender.castSession?.castMediaStatus?.volume;
    if (volume != null) {
      castSender.setVolume(max(0, volume - 0.1));
    }
  } else if (67 == keyCode || 68 == keyCode) {
    // left or right = seek 10s back or forth
    double seekBy = 67 == keyCode ? 10.0 : -10.0;
    if (null != castSender.castSession &&
        null != castSender.castSession!.castMediaStatus) {
      castSender.seek(
        max(0.0, castSender.castSession!.castMediaStatus!.position! + seekBy),
      );
    }
  }
}
