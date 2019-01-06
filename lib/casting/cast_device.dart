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
  final Map<String, Uint8List> attr;

  String friendlyName;
  String modelName;

  /// Model of device
  /// Used for sorting
  CastModel castModel;

  CastDevice({this.name, this.type, this.host, this.port, this.attr}) {
    modelName = utf8.decode(attr['md']);
    friendlyName = utf8.decode(attr['fn']);

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
  /// Home,mini,max,hub < Chromecast and Audio < Cast Group and non google
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
        } else if (b.castModel == CastModel.CastGroup || b.castModel == CastModel.NonGoogle) {
          return -1; // Before castGroup and NonGoogle in list
        } else {
          return this.host.compareTo(b.host);
        }
        break;
      case CastModel.NonGoogle:
      case CastModel.CastGroup:
        if (b.castModel != CastModel.CastGroup && b.castModel != CastModel.NonGoogle) {
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
