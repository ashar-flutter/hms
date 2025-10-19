import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapService {
  static Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return const LatLng(0, 0);

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return const LatLng(0, 0);
    }
    if (permission == LocationPermission.deniedForever) return const LatLng(0, 0);

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    return LatLng(position.latitude, position.longitude);
  }

  static Marker buildMarker(LatLng position) {
    return Marker(
      point: position,
      width: 50,
      height: 50,
      child: const Icon(
        Icons.location_on,
        color: Colors.red,
        size: 40,
      ),
    );
  }
}
