# dart_chromecast for Flutter
Flutter Package for Cast control

Based on the Dart only version found at [https://github.com/terrabythia/dart_chromecast]

This version of the package only works in Flutter and handles Model names.
It has a callback so you can update the Flutter UI if need be.

### Model names
The supported model names (enum of type `CastModel`) are:
* GoogleMini
* GoogleHome
* GoogleMax
* GoogleHub
* ChromeCastAudio
* ChromeCast
* CastGroup
* NonGoogle

### Comparator

`CastDevice` also has a comparator now, so you can sort a list of `CastDevice`. The order list is:

```
Home, mini, max, hub < Chromecast and Chromecast Audio < Cast Groups and Non Google devices (ie: Sonos, etc.)
```


