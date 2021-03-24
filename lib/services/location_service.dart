import 'package:location/location.dart';

import '../models/location.dart' as L;

class LocationService {
  /// returns null is location services is not turned on or is denied.
  /// otherwise return Location
  static Future<L.Location> getCurrentLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
     return L.Location(longitude: _locationData.longitude, latitude: _locationData.latitude);
  }
}
