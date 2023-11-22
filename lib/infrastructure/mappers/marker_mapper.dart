import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rionegro_marca_ciudad/domain/entities/marker_entity.dart';
import 'package:rionegro_marca_ciudad/infrastructure/models/marker_model.dart';

class MarkerMapper {
  static MarkerEntity markerFirebaseToEntity(MarkerModel markersb) =>
      MarkerEntity(
          id: markersb.id,
          name: markersb.name,
          urlInstagram: markersb.urlInstagram,
          description: markersb.description,
          position: LatLng(markersb.latitude, markersb.longitude),
          latitude: markersb.latitude,
          category: markersb.category,
          longitude: markersb.longitude,
          image: null,
          celphone: markersb.celphone);
}
