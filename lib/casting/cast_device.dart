import 'package:http/http.dart' as http;
import 'dart:convert';
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
      // for now we only request name, because we only use it to get the 'friendly name'
      // Possible parameters: version,audio,name,build_info,detail,device_info,net,wifi,setup,settings,opt_in,opencast,multizone,proxy,night_mode_params,user_eq,room_equalizer
      // see: https://rithvikvibhu.github.io/GHLocalApi/#device-info
      http.get('http://${host}:8008/setup/eureka_info?params=name')
          .then((response) {
        print("EUREKA: Response status: ${response.statusCode}");
        print("EUREKA: Response body: ${response.body}");
        Map deviceInfo = jsonDecode(response.body);
        _friendlyName = deviceInfo['name'];
        notifyChange();
      });
      // old way: xml from device-desc.xml
//      http.get('http://${host}:8008/ssdp/device-desc.xml')
//          .then((response) {
//        print("Response status: ${response.statusCode}");
//        print("Response body: ${response.body}");
//        xml.XmlDocument document = xml.parse(response.body);
//        xml.XmlElement deviceElement =
//            document.findElements('root').first
//            .findElements('device').first;
//        _friendlyName = deviceElement.findElements('friendlyName').first.text;
//        notifyChange();
//      });
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