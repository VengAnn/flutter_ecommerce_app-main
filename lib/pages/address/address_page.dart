import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/auth_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/location_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/user_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/models/address_model.dart';
import 'package:flutter_e_commerce_app_with_backend/pages/address/pick_address_map.dart';
import 'package:flutter_e_commerce_app_with_backend/routes/route_helper.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/app_colors.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/dimensions.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/big_text.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/text_field_reusable_widget.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final TextEditingController _contactPersonName = TextEditingController();
  final TextEditingController _contactPersonNumber = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  late bool _isLogged;

  // initialized location you want with langlng()
  CameraPosition _cameraPosition = const CameraPosition(
      target: LatLng(21.56453682228907, 105.8214412871613), zoom: 17);
  late LatLng _initialPosition =
      const LatLng(21.56453682228907, 105.8214412871613);

  @override
  void initState() {
    super.initState();
    _isLogged = Get.find<AuthController>().userLoggedIn();
    // ignore: unnecessary_null_comparison
    // check if user already login but UserModel is null getUserInformation
    if (_isLogged && Get.find<UserController>().getUserModel == null) {
      // if user has login already
      Get.find<UserController>().getUserInfo();
    }

    if (Get.find<LocationController>().addressList.isNotEmpty) {
      /**
       bug fix if first device address it'll empty will need to get if local storage is empty 
       */
      if (Get.find<LocationController>().getUserAddressFromLocalStorage() ==
          "") {
        Get.find<LocationController>()
            .saveUserAddress(Get.find<LocationController>().addressList.last);
      }
      Get.find<LocationController>().getUserAddress();
      final double latitude;
      final double longitude;
      if (Get.find<LocationController>().position == null) {
        // if null get from local storage
        latitude =
            Get.find<LocationController>().getAddress['latitude'] is String
                ? double.parse(
                    Get.find<LocationController>().getAddress['latitude'],
                  )
                : Get.find<LocationController>().getAddress['latitude'];
        longitude =
            Get.find<LocationController>().getAddress['longitude'] is String
                ? double.parse(
                    Get.find<LocationController>().getAddress['longitude'],
                  )
                : Get.find<LocationController>().getAddress['longitude'];
      } else {
        latitude = Get.find<LocationController>().position!.latitude;
        longitude = Get.find<LocationController>().position!.longitude;
      }
      _cameraPosition = CameraPosition(
        target: LatLng(
          latitude,
          longitude,
        ),
      );

      _initialPosition = LatLng(
        latitude,
        longitude,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address Page"),
        backgroundColor: AppColor.mainColor,
      ),
      body: GetBuilder<UserController>(
        builder: (userController) {
          // check some condition to get info user from usercontroller
          if (userController.getUserModel != null &&
              _contactPersonName.text.isEmpty) {
            _contactPersonName.text = '${userController.getUserModel?.name}';
            _contactPersonNumber.text = '${userController.getUserModel?.phone}';
            if (Get.find<LocationController>().addressList.isNotEmpty) {
              // if the list address in locationController already has we pass the address to _addressController
              _addressController.text =
                  Get.find<LocationController>().getUserAddress().address;
            }
          }

          return GetBuilder<LocationController>(
            builder: (locationController) {
              _addressController.text =
                  // ignore: unnecessary_string_interpolations
                  "${locationController.placemark.name ?? ''}";
              '${locationController.placemark.locality ?? ''}'
                  '${locationController.placemark.country ?? ''}';
              log("address in my view is: ${_addressController.text}");
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: Dimensions.height20 * 6,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                        left: Dimensions.width5,
                        top: Dimensions.height5,
                        right: Dimensions.width5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.width10),
                        border: Border.all(
                          width: 2,
                          color: Colors.green,
                        ),
                      ),
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: _initialPosition, zoom: 17),
                            onTap: (latlng) {
                              Get.toNamed(
                                RouteHelper.getPickAddressPage(),
                                arguments: PickAddressMap(
                                  fromSignup: false,
                                  fromAddress: true,
                                  googleMapController:
                                      locationController.mapController,
                                ),
                              );
                            },
                            zoomControlsEnabled: false,
                            compassEnabled: false,
                            indoorViewEnabled: true,
                            mapToolbarEnabled: false,
                            myLocationEnabled:
                                true, //set initialized for the first time
                            onCameraIdle: () {
                              locationController.updatePosition(
                                  _cameraPosition, true);
                            },
                            onCameraMove: (position) {
                              // Print dynamic LatLng when the camera moves
                              debugPrint("Dynamic LatLng: ${position.target}");
                              _cameraPosition = position;
                            },
                            onMapCreated: (GoogleMapController controller) {
                              locationController.setMapController(controller);
                            },
                          ),
                        ],
                      ),
                    ),
                    //sizedBox a little bit
                    SizedBox(height: Dimensions.height20),

                    // sizedBox for listview
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.width20),
                      child: SizedBox(
                        height: Dimensions.height20 * 2.5,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: locationController.addressTypeList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                locationController.setAddressTypeIndex(index);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.width10,
                                  vertical: Dimensions.height10,
                                ),
                                margin:
                                    EdgeInsets.only(right: Dimensions.width10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius20 / 4),
                                  color: Colors.grey[200],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[200]!,
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  index == 0
                                      ? Icons.home
                                      : index == 1
                                          ? Icons.work
                                          : Icons.location_on,
                                  color: locationController.addressTypeIndex ==
                                          index
                                      ? Colors.grey[400]
                                      : Theme.of(context).disabledColor,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.width20),
                      child: const BigText(text: "Delivery Address"),
                    ),
                    SizedBox(height: Dimensions.height5),
                    // for address
                    TextFieldReusableWidget(
                      textEditingController: _addressController,
                      hintText: "Your address",
                      iconData: Icons.map,
                      hideText: false,
                    ),
                    SizedBox(height: Dimensions.height10),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.width20),
                      child: const BigText(text: "Your Name"),
                    ),
                    SizedBox(height: Dimensions.height5),
                    // for name user
                    TextFieldReusableWidget(
                      textEditingController: _contactPersonName,
                      hintText: "Your name",
                      iconData: Icons.person,
                      hideText: false,
                    ),
                    SizedBox(height: Dimensions.height10),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.width20),
                      child: const BigText(text: "Your Phone"),
                    ),
                    // for phone user
                    SizedBox(height: Dimensions.height20),
                    TextFieldReusableWidget(
                      textEditingController: _contactPersonNumber,
                      hintText: "Your phone",
                      iconData: Icons.phone,
                      hideText: false,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      // bottomNavigationBar
      bottomNavigationBar:
          GetBuilder<LocationController>(builder: (localtionController) {
        return SizedBox(
          height: Dimensions.height20 * 3,
          width: Dimensions.screenWidth,
          //color: Colors.amber,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  AddressModel _addressModel = AddressModel(
                    addressType: localtionController
                        .addressTypeList[localtionController.addressTypeIndex],
                    contactPersonName: _contactPersonName.text,
                    contactPersonNumber: _contactPersonNumber.text,
                    address: _addressController.text,
                    latitude: localtionController.position!.latitude,
                    longitude: localtionController.position!.longitude,
                  );
                  // save address to our server
                  localtionController
                      .addAddress(_addressModel)
                      .then((response) {
                    if (response.isSuccess) {
                      Get.toNamed(RouteHelper.getInitial());
                      Get.snackbar("Address", "Add Successfully");
                    } else {
                      Get.snackbar("Address", "Couldn't save address");
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: Dimensions.height10),
                  width: Dimensions.height20 * 8,
                  height: Dimensions.height20 * 3,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                  ),
                  child: Center(
                    child: BigText(
                      text: "Save Address",
                      size: Dimensions.fontSize20,
                      //color: Colors.,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
