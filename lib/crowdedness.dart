class Crowdedness {
  String stationId;
  String status;
  DateTime timestamp;
  String statusValidity;

  Crowdedness(
      {required this.stationId,
      required this.status,
      required this.timestamp,
      required this.statusValidity});

  Map<String, dynamic> toJson() => {
        'stationId': stationId,
        'status': status,
        'timestamp': timestamp,
        'statusValidity': statusValidity
      };
}
