import 'package:rionegro_marca_ciudad/domain/datasources/marker_datasource.dart';
import 'package:rionegro_marca_ciudad/domain/entities/marker_entity.dart';
import 'package:rionegro_marca_ciudad/infrastructure/mappers/marker_mapper.dart';
import 'package:rionegro_marca_ciudad/infrastructure/models/marker_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MarkerDatasourceImpl extends MarkerDatasource {
  final SupabaseClient supabaseClient;
  MarkerDatasourceImpl({required this.supabaseClient});
  @override
  Future<List<MarkerEntity>> getMarkers() async {
    List<MarkerModel> markersModelList = [];

    final data = await supabaseClient.from('rutas').select('*');

    for (var element in data) {
      markersModelList.add(MarkerModel.fromJson(element));
    }

    return markersModelList
        .map((marker) => MarkerMapper.markerFirebaseToEntity(marker))
        .toList();
  }
}
