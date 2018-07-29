import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:observable/observable.dart';

enum CastDeviceType {
  Unknown,
  ChromeCast,
  AppleTV,
}

class CastDevice extends ChangeNotifier {

  final String name;
  final String type;
  final String host;
  final int port;

  String _friendlyName;

  CastDevice({
    this.name,
    this.type,
    this.host,
    this.port,
  }) {

    // fetch device info if possible
    if (CastDeviceType.ChromeCast == deviceType) {
      http.get('http://${host}:8008/ssdp/device-desc.xml')
          .then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        xml.XmlDocument document = xml.parse(response.body);
        xml.XmlElement deviceElement =
            document.findElements('root').first
            .findElements('device').first;
        _friendlyName = deviceElement.findElements('friendlyName').first.text;
        notifyChange();
      });
    }
    else if (CastDeviceType.AppleTV == deviceType) {
      // todo
    }

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

}