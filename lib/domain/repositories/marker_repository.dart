import 'package:rionegro_marca_ciudad/domain/entities/marker_entity.dart';

abstract class MarkerRespository {
  Future<List<MarkerEntity>> getMarkers();
  Future<MarkerEntity> getMarkerImage(MarkerEntity marker);
}
