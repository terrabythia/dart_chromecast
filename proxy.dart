import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:cli_util/cli_logging.dart';


class ServiceInfo{
  String name;
  String type;
  String host;
  int port;
  ServiceInfo(this.name, this.type, this.host, this.port);

  static ServiceInfo fromMap(Map fromChannel){
    String name = "";
    String type = "";
    String host = "";
    int port = 0;

    if ( fromChannel.containsKey("name") ) {
      name = fromChannel["name"];
    }

    if (fromChannel.containsKey("type")) {
      type = fromChannel["type"];
    }

    if (fromChannel.containsKey("host")) {
      host = fromChannel["host"];
    }

    if (fromChannel.containsKey("port")) {
      port = fromChannel["port"];
    }

    return new ServiceInfo(name, type, host, port);
  }

  @override
  String toString(){
    return "Name: $name, Type: $type, Host: $host, Port: $port";
  }
}
typedef void ServiceInfoCallback(ServiceInfo info);

typedef void IntCallback (int data);
typedef void VoidCallback();

class DiscoveryCallbacks{
  VoidCallback onDiscoveryStarted;
  VoidCallback onDiscoveryStopped;
  ServiceInfoCallback onDiscovered;
  ServiceInfoCallback onResolved;
  DiscoveryCallbacks({
    this.onDiscoveryStarted,
    this.onDiscoveryStopped,
    this.onDiscovered,
    this.onResolved,
  });
}

class MdnsPlugin {

  DiscoveryCallbacks discoveryCallbacks;

  MdnsPlugin({ this.discoveryCallbacks }){

    if ( discoveryCallbacks != null ) {
      //Configure all the discovery related callbacks and event channels

    }

  }

  parseOutput(serviceType, data) {
    RegExp regExp = RegExp(
      r".*._googlecast._tcp\s*([.*])",
      caseSensitive: false,
      multiLine: true,
    );
//    String input = stdin.readLineSync();
    print(regExp.stringMatch(data).toString());
  }

  startDiscovery(String serviceType) async {
   
    Process.start('dns-sd', ['-B', serviceType])
        .then((Process process) {
      process.stdout
          .transform(utf8.decoder)
          .listen((data) => parseOutput(serviceType, data));
    });

  }

  stopDiscovery(){

  }

}