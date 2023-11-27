class EventModel {
  final int id;
  final String name;
  final String date;
  final String place;
  final String hour;

  EventModel({
    required this.id,
    required this.name,
    required this.date,
    required this.place,
    required this.hour,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        date: json['date'] ?? '',
        place: json['place'] ?? '',
        hour: json['hour'] ?? '',
      );

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "date": date, "place": place, "hour": hour};
}
