import 'package:rionegro_marca_ciudad/domain/datasources/event_datasource.dart';
import 'package:rionegro_marca_ciudad/domain/entities/event_entity.dart';
import 'package:rionegro_marca_ciudad/infrastructure/mappers/event_mapper.dart';
import 'package:rionegro_marca_ciudad/infrastructure/models/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventDataSourceImpl extends EventDataSource {
  final SupabaseClient supabaseClient;
  EventDataSourceImpl(this.supabaseClient);

  @override
  Future<List<EventEntity>> getEvents() async {
    List<EventModel> eventsModelList = [];

    final data = await supabaseClient.from('events').select('*');

    for (var element in data) {
      eventsModelList.add(EventModel.fromJson(element));
    }

    return eventsModelList
        .map((event) => EventMapper.eventSupabaseToEntity(event))
        .toList();
  }

  @override
  String getUrlImage(String name) {
    try {
      final storageRef = supabaseClient.storage;
      final url = Uri.parse(storageRef.from('logos').getPublicUrl('$name.jpg'));
      if (url.toString().isNotEmpty) {
        return url.toString();
      }
      return '';
    } catch (e) {
      return '';
    }
  }
}
