import 'package:rionegro_marca_ciudad/domain/entities/marker_entity.dart';

abstract class MarkerDatasource {
  Future<List<MarkerEntity>> getMarkers();
}
