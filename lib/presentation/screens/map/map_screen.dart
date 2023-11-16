import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rionegro_marca_ciudad/config/theme/app_theme.dart';
import 'package:rionegro_marca_ciudad/domain/entities/marker_entity.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/google_map_provider.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/initial_loading_provider.dart';
import 'package:rionegro_marca_ciudad/presentation/screens/screens.dart';
import 'package:rionegro_marca_ciudad/presentation/widgets/full_screen_loader.dart';

class MapScreen extends ConsumerStatefulWidget {
  static const String name = 'map-screen';
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  // Google Maps & Markers
  //late String mapStyle;
  late BitmapDescriptor pinLocationIcon;
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  List<MarkerEntity> markers = [];
  late LatLng initialMapCenter;
  MarkerEntity? selectedMarker;
  final GlobalKey<ScaffoldState> key = GlobalKey();
  double myLocationDistance = 0.0;
  late PointLatLng myLocation;

  // Draw Route GoTo Point
  late PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  final isAndroid = Platform.isAndroid;

  @override
  void initState() {
    setCustomMapPin();
    initialMapCenter = ref.read(initialCenterProvider);
    ref.read(userCurrentLocationProvider.notifier).getUserCurrentLocation();
    ref.read(markersListProvider.notifier).getMarkers();
    super.initState();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(5, 5)),
        'assets/rutas/logo_historia.png');
  }

// Create Map with markers
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    //controller.setMapStyle(mapStyle);
    setMarkers(0);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future setMarkers(int filter) async {
    markers = await ref.read(markersListProvider);
    _markers.clear();
    for (final marker in markers) {
      _markers.add(Marker(
          markerId: MarkerId(marker.name),
          position: marker.position,
          infoWindow: InfoWindow(
            title: marker.name,
            onTap: () {},
          ),
          onTap: () async {},
          icon: pinLocationIcon));
    }
    await ref
        .read(userCurrentLocationProvider.notifier)
        .getUserCurrentLocation();
    myLocation = ref.read(userCurrentLocationProvider);
    myLocationDistance = calculateDistance(
        myLocation.latitude,
        myLocation.longitude,
        initialMapCenter.latitude,
        initialMapCenter.longitude);
    setState(() {});
    double minLat = _markers.first.position.latitude;
    double minLong = _markers.first.position.longitude;
    double maxLat = _markers.first.position.latitude;
    double maxLong = _markers.first.position.longitude;
    for (final m in _markers) {
      if (m.position.latitude < minLat) minLat = m.position.latitude;
      if (m.position.latitude > maxLat) maxLat = m.position.latitude;
      if (m.position.longitude < minLong) minLong = m.position.longitude;
      if (m.position.longitude > maxLong) maxLong = m.position.longitude;
    }
    LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(minLat, minLong), northeast: LatLng(maxLat, maxLong));
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    Timer(const Duration(milliseconds: 800),
        () => mapController.animateCamera(cameraUpdate));
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);

    if (initialLoading) return const FullScreenLoader();

    final currentPosition = ref.watch(positionProvider);

    currentPosition.when(
      skipError: true,
      data: (data) {
        if (data != null) {
          myLocation = PointLatLng(data.latitude, data.longitude);
        }
        setState(() {});
      },
      error: (error, stackTrace) {
        debugPrint("$error");
        return;
      },
      loading: () => const FullScreenLoader(),
    );

    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          padding: isAndroid
              ? const EdgeInsets.only(bottom: 160, top: 150)
              : const EdgeInsets.only(bottom: 150, top: 100),
          onMapCreated: onMapCreated,
          markers: _markers,
          mapToolbarEnabled: false,
          initialCameraPosition:
              CameraPosition(target: initialMapCenter, zoom: 13),
        ),
        Positioned(
          child: Container(
            alignment: Alignment.bottomRight,
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(color: AppTheme.colorApp),
            child: IconButton(
                onPressed: () {
                  context.goNamed(LoginScreen.name);
                },
                icon: const Icon(Icons.exit_to_app, color: Colors.white)),
          ),
        ),
        Positioned(
            top: 55,
            left: 20,
            child: Image.asset('assets/logo.png', height: 90))
      ]),
      bottomSheet: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: AppTheme.colorApp2),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Ruta de la historia",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Divider(
                thickness: 2,
                color: Colors.white,
              ),
              Text(
                "Estas cuatro rutas te permitirán experimentar la diversidad de esta ciudad que conserva las tradiciones antioqueñas y mira hacia el futuro.",
                textAlign: TextAlign.center,
                maxLines: 5,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.0,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
