import 'package:rionegro_marca_ciudad/domain/entities/event_entity.dart';

abstract class EventDataSource {
  Future<List<EventEntity>> getEvents();
  String getUrlImage(String name);
}
