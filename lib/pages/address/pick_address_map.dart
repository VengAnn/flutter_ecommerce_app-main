import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/base/custom_button.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/location_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/pages/address/widgets/search_location_dialog.dart';
import 'package:flutter_e_commerce_app_with_backend/routes/route_helper.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/app_colors.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickAddressMap extends StatefulWidget {
  final bool fromSignup;
  final bool fromAddress;
  final GoogleMapController? googleMapController;

  const PickAddressMap({
    super.key,
    required this.fromSignup,
    required this.fromAddress,
    this.googleMapController,
  });

  @override
  State<PickAddressMap> createState() => _PickAddressMapState();
}

class _PickAddressMapState extends State<PickAddressMap> {
  late LatLng _initialPosition;
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    super.initState();

    if (Get.find<LocationController>().addressList.isEmpty) {
      _initialPosition = const LatLng(21.56453682228907, 105.8214412871613);
      _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
    } else {
      if (Get.find<LocationController>().addressList.isNotEmpty) {
        final dynamic latitude =
            Get.find<LocationController>().getAddress!['latitude'];
        final dynamic longitude =
            Get.find<LocationController>().getAddress!['longitude'];
        _initialPosition = LatLng(
          latitude is String ? double.parse(latitude) : latitude,
          longitude is String ? double.parse(longitude) : longitude,
        );
        _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationController) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: SizedBox(
              width: double.maxFinite,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: _initialPosition, zoom: 17),
                    zoomControlsEnabled: false,
                    onCameraMove: (CameraPosition cameraPosition) {
                      _cameraPosition = cameraPosition;
                    },
                    onCameraIdle: () {
                      Get.find<LocationController>()
                          .updatePosition(_cameraPosition, false);
                    },
                    onMapCreated: (GoogleMapController mapController) {
                      _mapController = mapController;
                      if (!widget.fromAddress) {}
                    },
                  ),
                  //picker on map
                  Center(
                    child: !locationController.isLoading
                        ? Image.asset(
                            "assets/images/virtual/pin.png",
                            height: 50,
                            width: 50,
                          )
                        : const CircularProgressIndicator(),
                  ),
                  // showing and selecting address
                  Positioned(
                    top: Dimensions.height20 * 4,
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    child: InkWell(
                      onTap: () {
                        // showing dialog suggestion on map
                        Get.dialog(
                          SearchLocationDialog(mapController: _mapController),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.width10),
                        height: Dimensions.height20 * 2.5,
                        decoration: BoxDecoration(
                          color: AppColor.mainColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.height20 / 2),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: Dimensions.iconSize17,
                              color: Colors.amber,
                            ),
                            //
                            Expanded(
                              child: Text(
                                // ignore: unnecessary_string_interpolations
                                "${locationController.pickPlacemark.name ?? ''}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Dimensions.fontSize15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ), //
                            ),
                            // icon search
                            const Icon(
                              Icons.search,
                              color: Colors.amber,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //
                  Positioned(
                    bottom: 200,
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    child: locationController.isLoadingSv
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : CustomButton(
                            buttonText: locationController.inZOne
                                ? widget.fromAddress
                                    ? 'Pick Adress'
                                    : 'Pick Loaction'
                                : 'Service is not available in your Area',
                            onPressed: (locationController.buttonDisabled ||
                                    locationController.isLoading)
                                ? null
                                : () {
                                    if (locationController
                                                .pickPosition!.latitude !=
                                            0 &&
                                        locationController.pickPlacemark.name !=
                                            null) {
                                      if (widget.fromAddress) {
                                        if (widget.googleMapController !=
                                            null) {
                                          log('pressed pick address');
                                          widget.googleMapController!
                                              .moveCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                    target: LatLng(
                                                        locationController
                                                            .pickPosition!
                                                            .latitude,
                                                        locationController
                                                            .pickPosition!
                                                            .longitude))),
                                          );
                                          locationController.setAddressData();
                                        }
                                        //Get.back(); create update problem
                                        //list, value
                                        Get.toNamed(
                                            RouteHelper.getAddAddressPage());
                                      }
                                    }
                                  },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
