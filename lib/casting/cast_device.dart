import 'dart:convert';
import 'dart:convert' show utf8;
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:observable/observable.dart';

/// Only Chromecast Type is supported
enum CastDeviceType {
  Unknown,
  ChromeCast,
  AppleTV,
}

enum CastModel {
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

  /// Name given to your device when you set it up
  /// ex: Kitchen Speaker
  String friendlyName;

  /// Model name given by manufacturer
  /// It is the device (Google Home), NOT the codename (ie: Pepperoni)
  String modelName;

  /// Model of device
  /// Used for sorting, enum of type [CastModel]
  CastModel castModel;

  CastDevice({this.name, this.type, this.host, this.port, this.attr}) {
    if (attr != null) {
      modelName = utf8.decode(attr['md']);
      friendlyName = utf8.decode(attr['fn']);

      defineModelName();
      notifyChange();
    } else {
      fetchEurekaInfo();
    }
  }

  void defineModelName() {
    switch (modelName) {
      case "Google Home":
        castModel = CastModel.GoogleHome;
        break;
      case "Google Home Hub":
        castModel = CastModel.GoogleHub;
        break;
      case "Google Home Mini":
        castModel = CastModel.GoogleMini;
        break;
      case "Google Home Max":
        castModel = CastModel.GoogleMax;
        break;
      case "Chromecast":
        castModel = CastModel.ChromeCast;
        break;
      case "Chromecast Audio":
        castModel = CastModel.ChromeCastAudio;
        break;
      case "Google Cast Group":
        castModel = CastModel.CastGroup;
        break;
      default:
        castModel = CastModel.NonGoogle;
        break;
    }
  }

  void fetchEurekaInfo() async {
    // Attributes are not guaranteed to be set, if not set fetch them via the eureka_info url
    // Possible parameters: version,audio,name,build_info,detail,device_info,net,wifi,setup,settings,opt_in,opencast,multizone,proxy,night_mode_params,user_eq,room_equalizer
    try {
      http.Response response = await http
          .get('http://${host}:8008/setup/eureka_info?params=name,device_info');
      Map deviceInfo = jsonDecode(response.body);
      friendlyName = deviceInfo['name'];
    } catch (exception) {
      friendlyName = 'Unknown';
    }
  }

  CastDeviceType get deviceType {
    if (type.startsWith('_googlecast._tcp')) {
      return CastDeviceType.ChromeCast;
    } else if (type.startsWith('_airplay._tcp')) {
      return CastDeviceType.AppleTV;
    }
    return CastDeviceType.Unknown;
  }

  /// Comparator
  /// For the order, look at how the enum [CastModel] is instanciated
  int compareTo(CastDevice b) {
    if (this.castModel == b.castModel) {
      return this.host.compareTo(b.host);
    } else {
      return this.castModel.index.compareTo(b.castModel.index);
    }
  }
}
