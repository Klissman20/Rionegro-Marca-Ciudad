class MarkerModel {
  final int id;
  final String name;
  final String description;
  final double latitude;
  final int category;
  final double longitude;
  final String? urlInstagram;
  final int? celphone;

  MarkerModel({
    required this.id,
    required this.latitude,
    required this.category,
    required this.longitude,
    required this.name,
    required this.urlInstagram,
    required this.description,
    required this.celphone,
  });

  factory MarkerModel.fromJson(Map<String, dynamic> json) => MarkerModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        urlInstagram: json['urlinstagram'] ?? '',
        description: json['description'] ?? '',
        latitude: json['latitude'] ?? 0,
        category: json['category'] ?? 0,
        longitude: json['longitude'] ?? 0,
        celphone: json['celphone'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "urlInstagram": urlInstagram,
        "description": description,
        "latitude": latitude,
        "category": category,
        "longitude": longitude,
        "celphone": celphone
      };
}
