import 'dart:ui';

class EventEntity {
  final int id;
  final String name;
  final String date;
  final String place;
  final String? hour;
  Image? image;

  EventEntity({
    required this.id,
    required this.name,
    required this.date,
    required this.place,
    required this.hour,
    this.image,
  });
}
