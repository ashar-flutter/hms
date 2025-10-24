import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Custom_Map extends StatelessWidget {
  const Custom_Map({
    super.key,
    required LatLng fixedPosition,
  }) : _fixedPosition = fixedPosition;

  final LatLng _fixedPosition;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: _fixedPosition,
        initialZoom: 16.5,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate:
          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.ashar.attendance_app',
        ),
      ],
    );
  }
}
