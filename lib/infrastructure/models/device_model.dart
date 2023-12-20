class DeviceData {
  final String name;
  final String uuid;
  final String macAddress;
  final int major;
  final int minor;
  final double distance;
  final String proximity;
  final String rssi;
  final String txPower;

  DeviceData(
      {required this.name,
      required this.uuid,
      required this.macAddress,
      required this.major,
      required this.minor,
      required this.distance,
      required this.proximity,
      required this.rssi,
      required this.txPower});

  factory DeviceData.fromJson(Map<String, dynamic> json) => DeviceData(
        name: json["name"],
        uuid: json["uuid"],
        macAddress: json["macAddress"],
        major: int.parse(json["major"]),
        minor: int.parse(json["minor"]),
        distance: double.parse(json["distance"]),
        proximity: json["proximity"],
        rssi: json["rssi"],
        txPower: json["txPower"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "uuid": uuid,
        "macAddress": macAddress,
        "major": major,
        "minor": minor,
        "distance": distance,
        "proximity": proximity,
        "rssi": rssi,
        "txPower": txPower,
      };
}
