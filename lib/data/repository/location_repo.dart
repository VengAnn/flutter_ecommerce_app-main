import 'package:flutter_e_commerce_app_with_backend/data/api/api_client.dart';
import 'package:flutter_e_commerce_app_with_backend/models/address_model.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/app_constant.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LocationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LocationRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  //this using Response build in getx or you can use http or Dio package
  Future<http.Response> getDetailLocation(LatLng value) async {
    try {
      String apiUrl =
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${value.latitude}&lon=${value.longitude}';

      final response = await http.get(Uri.parse(apiUrl));

      // if success
      if (response.statusCode == 200) {
        return response;
      } else {
        return http.Response(
          'Error: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      return http.Response('Error: ${e.toString()}', 500);
    }
  }

  String getUserAddress() {
    return sharedPreferences.getString(AppConstants.USER_ADDRESS) ?? "";
  }

  // add address
  Future<Response> addAddress(AddressModel addressModel) async {
    return await apiClient.postData(
        AppConstants.ADD_USER_ADDRESS, addressModel.toJson());
  }

  Future<Response> getAllAddress() async {
    return await apiClient.getData(AppConstants.ADDRESS_LIST_URI);
  }

  Future<bool> saveUserAddress(String address) async {
    apiClient.updateHeader(sharedPreferences.getString(AppConstants.TOKEN)!);
    return await sharedPreferences.setString(
        AppConstants.USER_ADDRESS, address);
  }

  Future<Response> getZone(String lat, String lng) async {
    return await apiClient
        .getData('${AppConstants.ZONE_URI}?lat=$lat&lng=$lng');
  }

  Future<Response> searchLocation(String text) async {
    return await apiClient
        .getData('${AppConstants.SEARCH_LOCATION_URL}?search_text=$text');
  }

  Future<Response> setLoaction(String placeID) async {
    return await apiClient
        .getData('${AppConstants.PLACE_DETAILS_URI}?placeid=$placeID');
  }
}
