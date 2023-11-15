import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rionegro_marca_ciudad/config/theme/app_theme.dart';
import 'package:rionegro_marca_ciudad/presentation/screens/screens.dart';

class MapScreen extends StatefulWidget {
  static const String name = 'map-screen';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        Positioned(
          child: Container(
            alignment: Alignment.bottomRight,
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(color: AppTheme.colorApp),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.exit_to_app, color: Colors.white)),
          ),
        ),
        Positioned(
            top: 50,
            left: 20,
            child: Image.asset('assets/logo.png', height: 90))
      ]),
      bottomSheet: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: AppTheme.colorApp2),
        child: const Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
