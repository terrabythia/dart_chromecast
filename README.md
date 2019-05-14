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
**--append** (-a) whether to append the passed in media to the current playlist and not replace the current playlist (if reconnecting was successful). Defaults to `false`.  
**--debug** (-d) whether to show all info logs, defaults to `false`

### usage
`dart index.dart <media> --host <host> --port <port> [--append]` 

### playback control
In this demo the following keys can be used to control the playback of the video:

`space` toggle paused state \
`s` stop playback \
`esc` disconnect device \
`left arrow key` seek -10 seconds \
`right arrow key` seek +10 seconds

### example
`dart index.dart http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4 http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4 --host=192.168.1.1`

### reconnecting to active session
When you exit the command line without disconnecting the device, the video will keep playing. 
To reconnect without messing with the current playlist, just run the command without any media urls. Eg:

`dart index.dart --host=192.168.1.1 `
