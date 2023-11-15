import 'dart:async';
import 'dart:io';

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
  final isAndroid = Platform.isAndroid;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kRionegro = CameraPosition(
      target: LatLng(6.14624537, -75.37489496), zoom: 14.0, tilt: 60.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          padding: isAndroid
              ? const EdgeInsets.only(bottom: 160, top: 150)
              : const EdgeInsets.only(top: 100),
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: _kRionegro,
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
