import 'package:rionegro_marca_ciudad/domain/datasources/event_datasource.dart';
import 'package:rionegro_marca_ciudad/domain/entities/event_entity.dart';
import 'package:rionegro_marca_ciudad/domain/repositories/event_repository.dart';

class EventRepositoryImpl extends EventRepository {
  final EventDataSource datasource;

  EventRepositoryImpl({required this.datasource});

  @override
  Future<List<EventEntity>> getEvents() {
    return datasource.getEvents();
  }

  @override
  String getUrlImage(String name) {
    return datasource.getUrlImage(name);
  }
}
