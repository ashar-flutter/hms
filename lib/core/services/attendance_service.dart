import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class AttendanceService {
  final LatLng fixedPosition;
  final double allowedRadius;

  AttendanceService({required this.fixedPosition, this.allowedRadius = 100});

  Future<bool> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Stream<LatLng> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1,
      ),
    ).map((position) => LatLng(position.latitude, position.longitude));
  }

  bool isWithinAllowedArea(LatLng currentPosition) {
    double distance = Geolocator.distanceBetween(
      fixedPosition.latitude,
      fixedPosition.longitude,
      currentPosition.latitude,
      currentPosition.longitude,
    );
    return distance <= allowedRadius;
  }
}
