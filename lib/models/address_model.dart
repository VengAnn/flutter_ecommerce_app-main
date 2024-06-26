class AddressModel {
  late int? _id;
  late String _addressType;
  late String _contactPersonName;
  late String _contactPersonNumber;
  late String _address;
  late dynamic _latitude;
  late dynamic _longitude;

  AddressModel({
    int? id,
    required String addressType,
    String? contactPersonName,
    String? contactPersonNumber,
    required String address,
    dynamic latitude,
    dynamic longitude,
  }) {
    _id = id;
    _addressType = addressType;
    _contactPersonName = contactPersonName ?? '';
    _contactPersonNumber = contactPersonNumber ?? '';
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
  }

  String get address => _address;
  String get addressType => _addressType;
  String get contactPersonName => _contactPersonName;
  String get contactPersonNumber => _contactPersonNumber;
  dynamic get latitude => _latitude; // Getter for latitude
  dynamic get longitude => _longitude; // Getter for longitude

  // from json to obj
  AddressModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _addressType = json["address_type"] ?? "";
    _contactPersonNumber = json["contact_person_number"] ?? "";
    _contactPersonName = json["contact_person_name"] ?? "";
    _address = json['address'] ?? '';
    _latitude = json['latitude'];
    _longitude = json['longitude'];
  }

  // convert obj to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = _id; // mean this._id
    data['address_type'] = addressType;
    data['contact_person_name'] = _contactPersonName;
    data['contact_person_number'] = _contactPersonNumber;
    data['latitude'] = _latitude;
    data['longitude'] = _longitude;
    data['address'] = _address;

    return data;
  }
}
