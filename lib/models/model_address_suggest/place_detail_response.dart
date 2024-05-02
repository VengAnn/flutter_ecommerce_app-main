class PlaceDetailResponse {
  final int placeId;
  final int parentPlaceId;
  final String osmType;
  final int osmId;
  final String category;
  final String type;
  final int adminLevel;
  final String localName;
  final Map<String, dynamic> names;
  final List<String> addressTags;
  final String calculatedPostcode;
  final String countryCode;
  final DateTime indexedDate;
  final double importance;
  final double calculatedImportance;
  final Map<String, dynamic> extraTags;
  final String calculatedWikipedia;
  final int rankAddress;
  final int rankSearch;
  final bool isArea;
  final Map<String, dynamic> centroid;
  final Map<String, dynamic> geometry;
  final String icon;

  PlaceDetailResponse({
    required this.placeId,
    required this.parentPlaceId,
    required this.osmType,
    required this.osmId,
    required this.category,
    required this.type,
    required this.adminLevel,
    required this.localName,
    required this.names,
    required this.addressTags,
    required this.calculatedPostcode,
    required this.countryCode,
    required this.indexedDate,
    required this.importance,
    required this.calculatedImportance,
    required this.extraTags,
    required this.calculatedWikipedia,
    required this.rankAddress,
    required this.rankSearch,
    required this.isArea,
    required this.centroid,
    required this.geometry,
    required this.icon,
  });

  // Convert JSON data to obj (PlaceDetailResponse object)
  factory PlaceDetailResponse.fromJson(Map<String, dynamic> json) {
    return PlaceDetailResponse(
      placeId: json['place_id'],
      parentPlaceId: json['parent_place_id'],
      osmType: json['osm_type'],
      osmId: json['osm_id'],
      category: json['category'],
      type: json['type'],
      adminLevel: json['admin_level'],
      localName: json['localname'],
      names: Map<String, dynamic>.from(json['names']),
      addressTags: (json['addresstags'] != null && json['addresstags'] is List)
          ? List<String>.from(json['addresstags'])
          : [],
      calculatedPostcode: json['calculated_postcode'] ?? '',
      countryCode: json['country_code'] ?? '',
      indexedDate: DateTime.parse(json['indexed_date']),
      importance: json['importance'] ?? 0.0,
      calculatedImportance: json['calculated_importance'] ?? 0.0,
      extraTags: Map<String, dynamic>.from(json['extratags']),
      calculatedWikipedia: json['calculated_wikipedia'] ?? '',
      rankAddress: json['rank_address'] ?? 0,
      rankSearch: json['rank_search'] ?? 0,
      isArea: json['isarea'] ?? false,
      centroid: Map<String, dynamic>.from(json['centroid']),
      geometry: Map<String, dynamic>.from(json['geometry']),
      icon: json['icon'] ?? '',
    );
  }
}
