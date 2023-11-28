import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rionegro_marca_ciudad/config/constants/environment.dart';
import 'package:rionegro_marca_ciudad/config/theme/app_theme.dart';
import 'package:rionegro_marca_ciudad/domain/entities/marker_entity.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/auth_repository_provider.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/google_map_provider.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/initial_loading_provider.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/marker_repository_provider.dart';
import 'package:rionegro_marca_ciudad/presentation/screens/screens.dart';
import 'package:rionegro_marca_ciudad/presentation/widgets/full_screen_loader.dart';
import 'package:rionegro_marca_ciudad/presentation/widgets/map/dialog_details.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends ConsumerStatefulWidget {
  static const String name = 'map-screen';
  final int category;
  const MapScreen({required this.category, super.key});

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
  String googleAPiKey = Environment.googleApiKey;
  String distance = '';

  // Draw Route GoTo Point
  late PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  final isAndroid = Platform.isAndroid;
  final isIOS = Platform.isIOS;

  late Routes selectedRoute;

  @override
  void initState() {
    setCustomMapPin();
    initialMapCenter = ref.read(initialCenterProvider);
    ref.read(userCurrentLocationProvider.notifier).getUserCurrentLocation();
    ref.read(markersListProvider.notifier).getMarkers();
    switch (widget.category) {
      case 1:
        selectedRoute = Routes(
            color: AppTheme.colorApp1,
            title: 'Ruta del Sabor',
            logo: Image.asset(
              'assets/rutas/logo_sabor.png',
              height: 80,
            ),
            minilogo: Image.asset(
              'assets/rutas/logo_sabor.png',
              height: 50,
            ));
        break;
      case 2:
        selectedRoute = Routes(
            color: AppTheme.colorApp2,
            title: 'Ruta de la Historia',
            logo: Image.asset(
              'assets/rutas/logo_historia.png',
              height: 80,
            ),
            minilogo: Image.asset(
              'assets/rutas/logo_historia.png',
              height: 50,
            ));
        break;
      case 3:
        selectedRoute = Routes(
            color: AppTheme.colorApp3,
            title: 'Ruta de la Sostenibilidad',
            logo: Image.asset(
              'assets/rutas/logo_sostenibilidad.png',
              height: 80,
            ),
            minilogo: Image.asset(
              'assets/rutas/logo_sostenibilidad.png',
              height: 50,
            ));
        break;
      case 4:
        selectedRoute = Routes(
            color: AppTheme.colorApp4,
            title: 'Ruta de las Flores',
            logo: Image.asset(
              'assets/rutas/logo_flores.png',
              height: 80,
            ),
            minilogo: Image.asset(
              'assets/rutas/logo_flores.png',
              height: 50,
            ));
        break;
      default:
    }
    super.initState();
  }

  void setCustomMapPin() async {
    if (isAndroid) {
      switch (widget.category) {
        case 1:
          pinLocationIcon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(5, 5)),
              'assets/rutas/logo_sabor_android.png');

          break;
        case 2:
          pinLocationIcon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(5, 5)),
              'assets/rutas/logo_historia_android.png');
          break;
        case 3:
          pinLocationIcon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(5, 5)),
              'assets/rutas/logo_sostenibilidad_android.png');
          break;
        case 4:
          pinLocationIcon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(5, 5)),
              'assets/rutas/logo_flores_android.png');
          break;
        default:
          pinLocationIcon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(5, 5)),
              'assets/rutas/logo_sabor_android.png');
      }
    } else if (isIOS) {
      switch (widget.category) {
        case 1:
          pinLocationIcon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(5, 5)),
              'assets/rutas/logo_sabor_ios.png');
        case 2:
          pinLocationIcon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(5, 5)),
              'assets/rutas/logo_historia_ios.png');
        case 3:
          pinLocationIcon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(5, 5)),
              'assets/rutas/logo_sostenibilidad_ios.png');
        case 4:
          pinLocationIcon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(5, 5)),
              'assets/rutas/logo_flores_ios.png');
        default:
          pinLocationIcon = await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(5, 5)),
              'assets/rutas/logo_sabor_ios.png');
      }
    }
    setState(() {});
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
    markers = ref
        .read(markersListProvider)
        .where((element) => element.category == widget.category)
        .toList();

    _markers.clear();
    for (final marker in markers) {
      _markers.add(Marker(
          markerId: MarkerId(marker.name),
          position: marker.position,
          infoWindow: InfoWindow(
            title: marker.name,
            onTap: () async {
              selectedMarker = await ref
                  .read(markerRepositoryProvider)
                  .getMarkerImage(marker);
              showCustomDialog(context, selectedMarker!, widget.category);
            },
          ),
          onTap: () async {
            selectedMarker =
                await ref.read(markerRepositoryProvider).getMarkerImage(marker);
            showCustomDialog(context, marker, widget.category);
          },
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
    setState(() {});
  }

  void showCustomDialog(BuildContext context, MarkerEntity marker, category) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.8),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, __, ___) {
        return Material(
            color: Colors.transparent,
            child: Center(
                child: DialogDetails(
              marker: marker,
              selectedRoute: selectedRoute,
              category: category,
              getPolyline: getPolyline,
              onInstagramSelected: _launchInstagram,
              onWhatsappSelected: _launchWhatsapp,
            )));
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  Future<void> getPolyline(MarkerEntity marker) async {
    PointLatLng destination =
        PointLatLng(marker.position.latitude, marker.position.longitude);
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey, myLocation, destination,
        travelMode:
            myLocationDistance < 5.0 ? TravelMode.walking : TravelMode.driving);
    clearPolylines();
    double minLat = 0;
    double minLong = 0;
    double maxLat = 0;
    double maxLong = 0;
    if (result.points.isNotEmpty) {
      minLat = result.points.first.latitude;
      minLong = result.points.first.longitude;
      maxLat = result.points.first.latitude;
      maxLong = result.points.first.longitude;
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLong) minLong = point.longitude;
        if (point.longitude > maxLong) maxLong = point.longitude;
      }
    }

    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    distance = totalDistance < 1
        ? '${(totalDistance * 1000).round()} mts.'
        : '${totalDistance.toStringAsFixed(2)} Kms.';

    LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(minLat, minLong), northeast: LatLng(maxLat, maxLong));
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      consumeTapEvents: true,
      onTap: () {
        mapController.animateCamera(cameraUpdate);
      },
      polylineId: id,
      color: selectedRoute.color,
      width: 7,
      endCap: Cap.roundCap,
      startCap: Cap.roundCap,
      points: polylineCoordinates,
    );
    polylines[id] = polyline;
    mapController.animateCamera(cameraUpdate);
    _markers.add(Marker(
        markerId: const MarkerId('Distance'),
        alpha: 0,
        position:
            polylineCoordinates[(polylineCoordinates.length / 2).floor()]));
    setState(() {});
    Timer(const Duration(milliseconds: 150),
        () => mapController.showMarkerInfoWindow(const MarkerId('Distance')));
    setState(() {});
  }

  void clearPolylines() {
    polylines.clear();
    polylineCoordinates.clear();
    _markers.removeWhere(
        (element) => element.markerId == const MarkerId('Distance'));
  }

  _launchURL() async {
    const url = 'https://ciudadrionegro.co/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchInstagram(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw Exception("can't open Instagram");
    }
  }

  _launchWhatsapp(String phone) async {
    var url = "https://wa.me/$phone?text=${Uri.parse('Hola, me interesa')}";
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw Exception("can't open Instagram");
      }
    } on Exception {
      throw ('WhatsApp is not installed.');
    }
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
          padding: const EdgeInsets.only(bottom: 160, top: 90),
          onMapCreated: onMapCreated,
          markers: _markers,
          mapToolbarEnabled: false,
          initialCameraPosition:
              CameraPosition(target: initialMapCenter, zoom: 13),
          polylines: Set.of(polylines.values),
        ),
        Positioned(
          child: Container(
            alignment: Alignment.bottomRight,
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(color: AppTheme.colorApp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      context.pushReplacementNamed(HomeScreen.name);
                    },
                    icon: const Icon(Icons.home_outlined, color: Colors.white)),
                IconButton(
                    onPressed: () async {
                      await ref.read(authRepositoryProvider).signOut();
                      context.goNamed(LoginScreen.name);
                    },
                    icon: const Icon(Icons.exit_to_app_rounded,
                        color: Colors.white))
              ],
            ),
          ),
        ),
        Positioned(
            top: 55,
            left: 20,
            child: InkWell(
                onTap: _launchURL,
                child: Image.asset('assets/logo.png', height: 90)))
      ]),
      bottomSheet: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: selectedRoute.color),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedRoute.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Divider(
                thickness: 2,
                color: Colors.white,
              ),
              const Text(
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class Routes {
  final String title;
  final Color color;
  final Image logo;
  final Image minilogo;

  Routes(
      {required this.title,
      required this.color,
      required this.logo,
      required this.minilogo});
}
