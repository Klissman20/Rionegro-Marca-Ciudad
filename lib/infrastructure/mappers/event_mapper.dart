import 'package:rionegro_marca_ciudad/domain/entities/event_entity.dart';
import 'package:rionegro_marca_ciudad/infrastructure/models/event_model.dart';

class EventMapper {
  static EventEntity eventSupabaseToEntity(EventModel eventsb) => EventEntity(
      id: eventsb.id,
      name: eventsb.name,
      date: eventsb.date,
      place: eventsb.place,
      image: null,
      hour: eventsb.hour);
}
