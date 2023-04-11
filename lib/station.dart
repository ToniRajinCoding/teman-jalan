import 'package:google_maps_flutter/google_maps_flutter.dart';

class Station {
  String stationId;
  String stationName;
  LatLng latlng;
  String status;
  String line;

  Station(
      {required this.stationId,
      required this.stationName,
      required this.status,
      required this.line,
      required this.latlng});

  Map<String, dynamic> toJson() => {
        'stationId': stationId,
        'status': status,
        'stationName': stationName,
        'line': line,
        'latlng': latlng
      };
}
