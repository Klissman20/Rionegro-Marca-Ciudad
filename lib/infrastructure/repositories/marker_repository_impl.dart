import 'package:rionegro_marca_ciudad/domain/datasources/marker_datasource.dart';
import 'package:rionegro_marca_ciudad/domain/entities/marker_entity.dart';
import 'package:rionegro_marca_ciudad/domain/repositories/marker_repository.dart';

class MarkerRepositoryImpl extends MarkerRespository {
  final MarkerDatasource datasource;

  MarkerRepositoryImpl({required this.datasource});

  @override
  Future<List<MarkerEntity>> getMarkers() async {
    return datasource.getMarkers();
  }

  @override
  Future<MarkerEntity> getMarkerImage(MarkerEntity marker) {
    return datasource.getMarkerImage(marker);
  }
}
