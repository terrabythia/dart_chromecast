import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:observable/observable.dart';

enum CastDeviceType {
  Unknown,
  ChromeCast,
  AppleTV,
}

enum CastModel {
  GoogleHome,
  GoogleMini,
  ChromeCastAudio,
  ChromeCast,
}

class CastDevice extends ChangeNotifier {
  final String name;
  final String type;
  final String host;
  final int port;

  String _friendlyName;

  CastModel castModel;

  CastDevice({
    this.name,
    this.type,
    this.host,
    this.port,
  }) {
    // fetch device info if possible
    if (CastDeviceType.ChromeCast == deviceType) {
      http.get('http://${host}:8008/ssdp/device-desc.xml').then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        xml.XmlDocument document = xml.parse(response.body);
        xml.XmlElement deviceElement = document.findElements('root').first.findElements('device').first;
        _friendlyName = deviceElement.findElements('friendlyName').first.text;

        notifyChange();
      }).catchError((error) {
        // Try the eureka method
        http.get('http://${host}:8008/setup/eureka_info').then((response) {
          if (response.statusCode == 200) {
            Map homeMap = json.decode(response.body);
            _friendlyName = homeMap['name'];
            notifyChange();
          }
        });
      });
    } else if (CastDeviceType.AppleTV == deviceType) {
      // todo
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

  String get friendlyName {
    if (null != _friendlyName) {
      return _friendlyName;
    }
    // We want null for when the friendlyname is not updated yet. We deal with null case outside of this.
    return null;
  }

  // Comparator
  int compareTo(CastDevice b) {
    switch (this.castModel) {
      case CastModel.GoogleHome:
      case CastModel.GoogleMini:
        // If b is not a Google home, return 1 because a is smaller (in list order) than b
        if (b.castModel == CastModel.ChromeCastAudio || b.castModel == CastModel.ChromeCast) {
          return -1;
        } else {
          return this.host.compareTo(b.host);
        }
        break;
      case CastModel.ChromeCast:
      case CastModel.ChromeCastAudio:
        // if a is chromecast and b is home, return -1 because a is bigger (in list order)
        if (b.castModel == CastModel.GoogleHome || b.castModel == CastModel.GoogleMini) {
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

    // Error
    return -1;
  }
}
