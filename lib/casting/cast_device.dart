import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8;
import 'dart:typed_data';

import 'package:observable/observable.dart';
import 'package:logging/logging.dart';

enum CastDeviceType {
  Unknown,
  ChromeCast,
  AppleTV,
}

enum GoogleCastModelType {
  GoogleHub,
  GoogleHome,
  GoogleMini,
  GoogleMax,
  ChromeCast,
  ChromeCastAudio,
  NonGoogle,
  CastGroup,
}


class CastDevice extends ChangeNotifier {

  final Logger log = new Logger('CastDevice');

  final String name;
  final String type;
  final String host;
  final int port;

  /// Contains the information about the device.
  /// You can decode with utf8 a bunch of information
  ///
  /// * md - Model Name (e.g. "Chromecast");
  /// * id - UUID without hyphens of the particular device (e.g. xx12x3x456xx789xx01xx234x56789x0);
  /// * fn - Friendly Name of the device (e.g. "Living Room");
  /// * rs - Unknown (recent share???) (e.g. "Youtube TV");
  /// * bs - Unknown (e.g. "XX1XXX2X3456");
  /// * st - Unknown (e.g. "1");
  /// * ca - Unknown (e.g. "1234");
  /// * ic - Icon path (e.g. "/setup/icon.png");
  /// * ve - Version (e.g. "04").
  final Map<String, Uint8List> attr;

  String _friendlyName;
  String _modelName;

  CastDevice({
    this.name,
    this.type,
    this.host,
    this.port,
    this.attr = null,
  }) {
    initDeviceInfo();
  }

  void initDeviceInfo() async {
    if (CastDeviceType.ChromeCast == deviceType) {
      if (null != attr && null != attr['fn']) {
        _friendlyName = utf8.decode(attr['fn']);
        if (null != attr['md']) {
          _modelName = utf8.decode(attr['md']);
        }
      }
      else {
        // Attributes are not guaranteed to be set, if not set fetch them via the eureka_info url
        // Possible parameters: version,audio,name,build_info,detail,device_info,net,wifi,setup,settings,opt_in,opencast,multizone,proxy,night_mode_params,user_eq,room_equalizer
        try {
          http.Response response = await http.get(
              'http://${host}:8008/setup/eureka_info?params=name,device_info');
          Map deviceInfo = jsonDecode(response.body);
          _friendlyName = deviceInfo['name'];
          if (null != deviceInfo['model_name']) {
            _modelName = deviceInfo['model_name'];
          }
        }
        catch(exception) {
          _friendlyName = 'Unknown';
        }
      }
    }
    notifyChange();
  }

  CastDeviceType get deviceType {
    if (type.startsWith('_googlecast._tcp')) {
      return CastDeviceType.ChromeCast;
    }
    else if (type.startsWith('_airplay._tcp')) {
      return CastDeviceType.AppleTV;
    }
    return CastDeviceType.Unknown;
  }

  String get friendlyName {
    if (null != _friendlyName) {
      return _friendlyName;
    }
    return name;
  }

  String get modelName => _modelName;

  GoogleCastModelType get googleModelType {
    switch (modelName) {
      case "Google Home":
        return GoogleCastModelType.GoogleHome;
      case "Google Home Hub":
        return GoogleCastModelType.GoogleHub;
        break;
      case "Google Home Mini":
        return GoogleCastModelType.GoogleMini;
      case "Google Home Max":
        return GoogleCastModelType.GoogleMax;
      case "Chromecast":
        return GoogleCastModelType.ChromeCast;
      case "Chromecast Audio":
        return GoogleCastModelType.ChromeCastAudio;
      case "Google Cast Group":
        return GoogleCastModelType.CastGroup;
      default:
        return GoogleCastModelType.NonGoogle;
    }
  }

}