# dart_chromecast
Dart package to play videos to a chromecast device. Pub.dev package: https://pub.dev/packages/dart_chromecast

**This package is currently under development and the API can change completely at some point. Use at your own risk.**

Simplified port of https://github.com/thibauts/node-castv2-client.

Update 0.2.0: added MDNS finder, you can now omit the --host parameter and it will ask you which chromecast to use

---

### Find the IP address of your chromecast on mac OS

This is the way I found the IP address of my ChromeCast on my Mac. This is not guaranteed to work for everyone, 
but if it helps anyone, here are the terminal commands:

`$ dns-sd -B _googlecast local`

Copy the instance name

`$ dns-sd -L <IntanceName> _googlecast._tcp. local.`

Copy the name (without the port) directly after the text '<IntanceName> can be reached at '...

`$ dns-sd -Gv4v6 <Paste>`

---

See https://github.com/terrabythia/flutter_chromecast_example for an example implementation in Flutter of both the flutter_mdns_plugin and this repository.

---

## usage

### options
**media** space separated list of one or more media source urls

**host** (optional) IP address of a ChromeCast device in the same network that you are on.

**port** (optional) port of the ChromeCast device. Defaults to `8009`.

### flags
**--append** (-a) whether to append the passed in media to the current playlist and not replace the current playlist (if reconnecting was successful). Defaults to `false`.  
**--debug** (-d) whether to show all info logs, defaults to `false`.

### usage
`dart example/main.dart <media> [--host <host> [--port <port> [--append [ --debug]]]]` 

### playback control
In this demo the following keys can be used to control the playback of the video:

`space` toggle paused state \
`s` stop playback \
`esc` disconnect device \
`left arrow key` seek -10 seconds \
`right arrow key` seek +10 seconds

### example
`dart example/main.dart http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4`

### reconnecting to active session
When you exit the command line without disconnecting the device, the video will keep playing. 
To reconnect without messing with the current playlist, just run the command without any media urls. Eg:

`dart example/main.dart --host=192.168.1.1`
