# dart_chromecast
Dart package to play videos to a chromecast device

**This package is currently under development and not ready for real use! The API will most likely change completely. Also no guarantees of this project working at all until it has its first stable release.**

Simplified port of https://github.com/thibauts/node-castv2-client.

Originally designed to work in Flutter with the flutter_mdns_plugin https://github.com/terrabythia/flutter_mdns_plugin,
so this cli project does not include a mdns browser, you should find out what the local ip address and port of your
ChromeCast is yourself.

### usage
`dart index.dart <media> --host <host> --port <port>` 

