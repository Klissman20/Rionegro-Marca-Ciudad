import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:rionegro_marca_ciudad/domain/entities/marker_entity.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/marker_repository_provider.dart';

final initialCenterProvider = Provider((ref) {
  const LatLng initialMapCenter = LatLng(6.14624537, -75.37489496);
  return initialMapCenter;
});

final userCurrentLocationProvider =
    StateNotifierProvider<UserLocationNotifier, PointLatLng>((ref) {
  return UserLocationNotifier(ref);
});

class UserLocationNotifier extends StateNotifier<PointLatLng> {
  Ref ref;
  UserLocationNotifier(this.ref) : super(const PointLatLng(0, 0));

  Future<void> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    await Geolocator.getCurrentPosition().then((position) {
      final newState = PointLatLng(position.latitude, position.longitude);

      state = newState;
    });
  }
}

// final markersListProvider = StateProvider((ref) async {
//   var markers = await ref.watch(markerRepositoryProvider).getMarkersList();
//   return markers;
// });

final markersListProvider =
    StateNotifierProvider<MarkersNotifier, List<MarkerEntity>>((ref) {
  return MarkersNotifier(ref);
});

class MarkersNotifier extends StateNotifier<List<MarkerEntity>> {
  Ref ref;
  MarkersNotifier(this.ref) : super([]);

  Future<void> getMarkers() async {
    var markers = await ref.read(markerRepositoryProvider).getMarkers();
    state = markers;
  }
}

final positionProvider = StreamProvider.autoDispose<Position?>((ref) {
  final streamController = StreamController<Position?>();

  _determinePosition(streamController);

  return streamController.stream;
});

void _determinePosition(StreamController<Position?> streamController) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    streamController.addError('Location services are disabled.');
    return;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      streamController.addError('Location permissions are denied');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    streamController.addError(
        'Location permissions are permanently denied, we cannot request permissions.');
    return;
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    //distanceFilter: 100,
  );

  Geolocator.getPositionStream(locationSettings: locationSettings)
      .listen((Position position) {
    streamController.add(position);
  });

  Position initialPosition = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  streamController.add(initialPosition);
}
