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
  GoogleHome,
  GoogleMini,
  GoogleMax,
  GoogleHub,
  ChromeCastAudio,
  ChromeCast,
  CastGroup,
  NonGoogle,
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
    }

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

  CastDeviceType get deviceType {
    if (type.startsWith('_googlecast._tcp')) {
      return CastDeviceType.ChromeCast;
    } else if (type.startsWith('_airplay._tcp')) {
      return CastDeviceType.AppleTV;
    }
    return CastDeviceType.Unknown;
  }

  /// Comparator
  /// In a List, the order will be:
  ///
  /// 1. Home,mini,max,hub
  /// 2. Chromecast and Audio
  /// 3. Cast Group and non google
  int compareTo(CastDevice b) {
    switch (this.castModel) {
      case CastModel.GoogleHome:
      case CastModel.GoogleMax:
      case CastModel.GoogleMini:
      case CastModel.GoogleHub:
        // If b is not a Google home, return -1 because a is smaller (in list order) than b
        if (b.castModel == CastModel.ChromeCastAudio ||
            b.castModel == CastModel.ChromeCast ||
            b.castModel == CastModel.CastGroup ||
            b.castModel == CastModel.NonGoogle) {
          return -1;
        } else {
          return this.host.compareTo(b.host);
        }
        break;
      case CastModel.ChromeCast:
      case CastModel.ChromeCastAudio:
        // if a is chromecast and b is home, a must go UNDER HOME
        if (b.castModel == CastModel.GoogleHome ||
            b.castModel == CastModel.GoogleMini ||
            b.castModel == CastModel.GoogleMax ||
            b.castModel == CastModel.GoogleHub) {
          return 1; // Go down under GoogleHome
        } else if (b.castModel == CastModel.CastGroup ||
            b.castModel == CastModel.NonGoogle) {
          return -1; // Before castGroup and NonGoogle in list
        } else {
          return this.host.compareTo(b.host);
        }
        break;
      case CastModel.NonGoogle:
      case CastModel.CastGroup:
        if (b.castModel != CastModel.CastGroup &&
            b.castModel != CastModel.NonGoogle) {
          return 1;
        } else {
          return this.host.compareTo(b.host);
        }
        break;
      default:
        // Otherwise, do a comparison of IPs
        return this.host.compareTo(b.host);
        break;
    }
  }
}
