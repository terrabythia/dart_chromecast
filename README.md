# dart_chromecast for Flutter (and dart?)
Flutter Package for Cast control but I think it is back to Dart only 🙂

Based on the Dart only version found at [https://github.com/terrabythia/dart_chromecast]

This version of the package handles Model names.
It has a callback so you can update the Flutter UI (or your dart app) if need be.

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


