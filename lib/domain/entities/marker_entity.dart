import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerEntity {
  final int id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final int category;
  final String? urlInstagram;
  Image? image;
  final Future<BitmapDescriptor>? iconMarker;
  final LatLng position;
  final int? celphone;

  MarkerEntity(
      {required this.latitude,
      required this.longitude,
      required this.id,
      this.iconMarker,
      required this.category,
      required this.urlInstagram,
      required this.name,
      required this.description,
      required this.position,
      this.image,
      required this.celphone});
}
