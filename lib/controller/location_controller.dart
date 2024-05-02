import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/data/api/api_checker.dart';
import 'package:flutter_e_commerce_app_with_backend/data/repository/location_repo.dart';
import 'package:flutter_e_commerce_app_with_backend/models/address_model.dart';
import 'package:flutter_e_commerce_app_with_backend/models/model_address_suggest/place_detail_response.dart';
import 'package:flutter_e_commerce_app_with_backend/models/model_address_suggest/prediction_model.dart';
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
  Position? _position;
  Position? _pickPosition;
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
  Position? get position => _position;
  Position? get pickPosition => _pickPosition;

  /*
    for service
   */
  // ignore: prefer_final_fields
  bool _isLoadingService = false;
  bool get isLoadingSv => _isLoadingService;
  /*
    whether the user is in service zone or not
   */
  bool _inZone = true;
  bool get inZOne => _inZone;
  /*
    showing and hiding the button as the map loads
  */
  bool _buttonDisabled = false;
  bool get buttonDisabled => _buttonDisabled;

  /*
   * save the google map suggestions for address name respone
   */
  List<PredictionModel> _predictionList = [];

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  void updatePosition(CameraPosition position, bool fromAddress) async {
    log("Dynamic con: ${position.target}");
    _isLoading = true;
    update();

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

      ResponseModel _responseModel = await getZone(
        position.target.latitude.toString(),
        position.target.longitude.toString(),
        false,
      );

      _buttonDisabled = !_responseModel.isSuccess;

      if (_changeAddress) {
        String _address = await getAddressFromGeocode(
          LatLng(
            position.target.latitude,
            position.target.longitude,
          ),
        );

        fromAddress
            ? _placemark = Placemark(name: _address)
            : _pickPlacemark = Placemark(name: _address);
      } else {
        _changeAddress = true;
      }
    } catch (e) {
      log(e.toString());
    }

    _isLoading = false;
    _updateAddressData = true; // Set it to true here
    update();
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
          debugPrint('Display Name: $displayName');
        } else {
          debugPrint('Error: Display name not found in response');
        }
      }
    } else {
      debugPrint("Error with the apiMap get the location!!");
    }
    update();
    return _address;
  }

  late Map<String, dynamic> _getAddress;
  Map<String, dynamic> get getAddress => _getAddress;

  AddressModel getUserAddress() {
    AddressModel? _addressModel;
    String userAddressJson = locationRepo.getUserAddress();
    if (userAddressJson.isNotEmpty) {
      try {
        _getAddress = jsonDecode(userAddressJson);
        _addressModel = AddressModel.fromJson(_getAddress);
      } catch (e) {
        log(e.toString());
      }
    } else {
      log('User address JSON is empty');
    }

    return _addressModel!;
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
      // saveUserAddress to local storage
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
      debugPrint("get AddressList success");
      _addressList = [];
      _allAddressList = [];
      response.body.forEach((address) {
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    } else {
      debugPrint("couldn't get AddressList");
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

  String getUserAddressFromLocalStorage() {
    return locationRepo.getUserAddress();
  }

  void setAddressData() {
    _position = _pickPosition;
    _placemark = _pickPlacemark;
    _updateAddressData = false;
    update();
  }

  Future<ResponseModel> getZone(String lat, String lng, bool markerLoad) async {
    late ResponseModel _responseModel;
    if (markerLoad) {
      _isLoading = true;
    } else {
      _isLoadingService = true;
    }
    update();
    // await Future.delayed(const Duration(seconds: 2), () {
    //   _responseModel = ResponseModel(true, "success");
    //   if (markerLoad) {
    //     _isLoading = false;
    //   } else {
    //     _isLoadingSv = false;
    //   }
    //   _inZone = true;
    // });

    Response response = await locationRepo.getZone(lat, lng);
    if (response.statusCode == 200) {
      _inZone = true;
      _responseModel = ResponseModel(true, response.body["zone_id"].toString());
    } else {
      _inZone = false;
      _responseModel = ResponseModel(true, response.statusText!);
    }
    // for debugging
    log("zone response code is: ${response.statusCode.toString()}"); // 200 //404 // 500 // 403

    if (markerLoad) {
      _isLoading = false;
    } else {
      _isLoadingService = false;
    }
    update();

    return _responseModel;
  }

  Future<List<PredictionModel>> searchLocation(
      BuildContext context, String? text) async {
    if (text!.isNotEmpty) {
      Response response = await locationRepo.searchLocation(text);
      if (response.statusCode == 200) {
        _predictionList = [];
        response.body['predictions'].forEach((prediction) {
          // convert json to obj then pass it to list
          _predictionList.add(PredictionModel.fromJson(prediction));
        });
      } else {
        ApiChecker.checkApi(response);
      }
    }
    return _predictionList;
  }

  // setLocation(
  //     String placeID, String address, GoogleMapController mapController) async {
  //   _isLoading = true;
  //   update();
  //   PlaceDetailResponse detail;
  //   Response response = await locationRepo.setLoaction(placeID);
  //   detail = PlaceDetailResponse.fromJson(response.body['placeDetails']);

  //   // Extract latitude and longitude from the "coordinates" array
  //   double latitude = detail.geometry['coordinates'][1];
  //   double longitude = detail.geometry['coordinates'][0];
  //   _pickPosition = Position(
  //     latitude: latitude,
  //     longitude: longitude,
  //     timestamp: DateTime.now(),
  //     accuracy: 1,
  //     altitude: 1,
  //     heading: 1,
  //     speed: 1,
  //     speedAccuracy: 1,
  //     altitudeAccuracy: 1,
  //     headingAccuracy: 1,
  //   );
  //   _pickPlacemark = Placemark(name: address);
  //   _changeAddress = false;
  //   // ignore: deprecated_member_use
  //   // if (!mapController.isNull) {
  //   //   mapController.animateCamera(CameraUpdate.newCameraPosition(
  //   //     CameraPosition(
  //   //       target: LatLng(latitude, longitude),
  //   //       zoom: 18.0,
  //   //     ),
  //   //   ));
  //   // }
  //   _isLoading = false;
  //   update();
  // }
}
