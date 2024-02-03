import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/data/repository/location_repo.dart';
import 'package:flutter_e_commerce_app_with_backend/models/address_model.dart';
import 'package:flutter_e_commerce_app_with_backend/models/response_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController implements GetxService {
  final LocationRepo locationRepo;
  LocationController({
    required this.locationRepo,
  });

  bool _isLoading = false;
  late Position _position;
  late Position _pickPosition;
  Placemark _placemark = Placemark();
  Placemark _pickPlacemark = Placemark();

  List<AddressModel> _addressList = [];
  // get
  List<AddressModel> get addressList => _addressList;
  Placemark get placemark => _placemark;
  Placemark get pickPlacemark => _pickPlacemark;

  late List<AddressModel> _allAddressList;

  final List<String> _addressTypeList = [
    "home",
    "office",
    "others",
  ];
  List<String> get addressTypeList => _addressTypeList;
  int _addressTypeIndex = 0;
  int get addressTypeIndex => _addressTypeIndex;

  late GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;
  bool _updateAddressData = true;
  bool _changeAddress = true;

  // for get
  bool get isLoading => _isLoading;
  Position get position => _position;
  Position get pickPosition => _pickPosition;

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  void updatePosition(CameraPosition position, bool fromAddress) async {
    if (_updateAddressData) {
      _isLoading = true;
      try {
        if (fromAddress) {
          _position = Position(
            longitude: position.target.longitude,
            latitude: position.target.latitude,
            timestamp: DateTime.now(),
            heading: 1,
            accuracy: 1,
            altitude: 1,
            speed: 1,
            speedAccuracy: 1,
            altitudeAccuracy: 1,
            headingAccuracy: 1,
          );
        } else {
          _pickPosition = Position(
            longitude: position.target.longitude,
            latitude: position.target.latitude,
            timestamp: DateTime.now(),
            heading: 1,
            accuracy: 1,
            altitude: 1,
            speed: 1,
            speedAccuracy: 1,
            altitudeAccuracy: 1,
            headingAccuracy: 1,
          );
        }

        // changeAddress talk to the server
        if (_changeAddress) {
          String _address = await getAddressFromGeocode(
            LatLng(
              position.target.latitude,
              position.target.longitude,
            ),
          );
          //fromAddress is true pass _address to it
          fromAddress
              ? _placemark = Placemark(
                  name: _address,
                )
              : _pickPlacemark = Placemark(name: _address);
          update();
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<String> getAddressFromGeocode(LatLng latLng) async {
    String _address = "Unknown Location Found";
    // Talk to the repository and the repository talks to the server API (map service)
    http.Response response = await locationRepo.getDetailLocation(latLng);

    // if success
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      //print("data: $data");

      // Check if the data contains the expected key
      if (data.containsKey('error')) {
        print('Error: ${data['error']}');
      } else {
        // Continue with your existing code for processing the response
        if (data.containsKey('display_name')) {
          // Extract the display name of the location with LatLng
          String displayName = data['display_name'];

          _address = displayName;
          print('Display Name: $displayName');
        } else {
          print('Error: Display name not found in response');
        }
      }
    } else {
      print("Error with the apiMap get the location!!");
    }
    update();
    return _address;
  }

  late Map<String, dynamic> _getAddress;
  Map get getAddress => _getAddress;

  AddressModel getUserAddress() {
    late AddressModel _addressModel;
    /*
      we need convert this string locationRepo.getUserAddress() to map by jsonDecode
    */
    _getAddress = jsonDecode(locationRepo.getUserAddress());
    try {
      _addressModel =
          AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()));
    } catch (e) {
      debugPrint(e.toString());
    }

    return _addressModel;
  }

  void setAddressTypeIndex(int index) {
    _addressTypeIndex = index;
    update();
  }

  //add address
  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _isLoading = true;
    update();
    Response response = await locationRepo.addAddress(addressModel);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      await getAddressList();
      String message = response.body["message"];
      responseModel = ResponseModel(true, message);
      // saveUserAddress to local storage s
      await saveUserAddress(addressModel);
    } else {
      debugPrint("couldn't save the address");
      responseModel = ResponseModel(false, response.statusText!);
    }
    update();
    return responseModel;
  }

  Future<void> getAddressList() async {
    Response response = await locationRepo.getAllAddress();

    if (response.statusCode == 200) {
      _addressList = [];
      _allAddressList = [];
      response.body.forEach((address) {
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    } else {
      _addressList = [];
      _allAddressList = [];
    }
    update();
  }

  // save shared Preferences
  Future<bool> saveUserAddress(AddressModel addressModel) async {
    String userAddress = jsonEncode(addressModel.toJson());

    return await locationRepo.saveUserAddress(userAddress);
  }

  void clearAddressList() {
    _addressList = [];
    _allAddressList = [];
    update();
  }
}
