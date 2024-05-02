class PredictionModel {
  final int placeId;
  final String displayName;
  final String latitude;
  final String longitude;

  PredictionModel({
    required this.placeId,
    required this.displayName,
    required this.latitude,
    required this.longitude,
  });

// Convert JSON data to obj (PredictionModel object)
  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      placeId: json['place_id'] as int,
      displayName: json['display_name'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );
  }
}
