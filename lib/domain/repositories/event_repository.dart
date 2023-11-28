import 'package:rionegro_marca_ciudad/domain/entities/event_entity.dart';

abstract class EventRepository {
  Future<List<EventEntity>> getEvents();
  String getUrlImage(String name);
}
