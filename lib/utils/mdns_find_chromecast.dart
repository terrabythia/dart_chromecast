import 'package:multicast_dns/multicast_dns.dart';

class CastDevice {
  final String? name;
  final String? ip;
  final int? port;

  CastDevice({this.name, this.ip, this.port});

  String toString() => "CastDevice: $name -> $ip:$port";
}

Future<List<CastDevice>> find_chromecasts() async {
  const String name = '_googlecast._tcp.local';
  final MDnsClient client = MDnsClient();

  final Map<String, CastDevice> map = {};
  // Start the client with default options.
  await client.start();

  // Get the PTR recod for the service.
  await for (PtrResourceRecord ptr in client
      .lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(name))) {
    // Use the domainName from the PTR record to get the SRV record,
    // which will have the port and local hostname.
    // Note that duplicate messages may come through, especially if any
    // other mDNS queries are running elsewhere on the machine.
    await for (SrvResourceRecord srv in client.lookup<SrvResourceRecord>(
        ResourceRecordQuery.service(ptr.domainName))) {
      await for (IPAddressResourceRecord ip
          in client.lookup<IPAddressResourceRecord>(
              ResourceRecordQuery.addressIPv4(srv.target))) {
        map[srv.name] =
            CastDevice(name: srv.name, ip: ip.address.address, port: srv.port);
      }
    }
  }
  client.stop();

  return map.values.toList();
}
