# dart_chromecast
Dart package to play videos to a chromecast device

**This package is currently under development and not ready for real use! The API will most likely change completely. Also no guarantees of this project working at all until it has its first stable release.**

Simplified port of https://github.com/thibauts/node-castv2-client.

Originally designed to work in Flutter with the flutter_mdns_plugin https://github.com/terrabythia/flutter_mdns_plugin,
so this cli project does not include a mdns browser, you should find out what the local ip address and port of your ChromeCast is yourself.

### options
**media** space separated list of one or more media source urls

**host** IP address of a ChromeCast device in the same network that you are on.

**port** (optional) port of the ChromeCast device. Defaults to `8009`.

### flags
**--append** whether to append the passed in media to the current playlist and not replace the current playlist (if reconnecting was successful). Defaults to `false`.  

### usage
`dart index.dart <media> --host <host> --port <port> [--append]` 

### example
`dart index.dart http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4 http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4 --host=192.168.1.1`
