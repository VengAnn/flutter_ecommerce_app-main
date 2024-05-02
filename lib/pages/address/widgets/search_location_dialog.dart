import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/controller/location_controller.dart';
import 'package:flutter_e_commerce_app_with_backend/models/model_address_suggest/prediction_model.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/dimensions.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchLocationDialog extends StatelessWidget {
  final GoogleMapController mapController;

  const SearchLocationDialog({
    super.key,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(Dimensions.width20),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius20 / 2),
        ),
        child: SizedBox(
          width: Dimensions.screenWidth,
          // TypeAheadField auto sugest or recommand
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: _controller,
              textInputAction: TextInputAction.search,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                hintText: "search location",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    style: BorderStyle.none,
                    width: 0,
                  ),
                ),
                // ignore: deprecated_member_use
                hintStyle: Theme.of(context).textTheme.headline2?.copyWith(
                      color: Theme.of(context).disabledColor,
                      fontSize: Dimensions.fontSize21,
                    ),
              ),
            ),
            onSuggestionSelected: (PredictionModel suggestion) {
              Get.find<LocationController>().setLocation(
                suggestion.placeId.toString(),
                suggestion.displayName,
                mapController,
              );
              // when select suggest close it
              Get.back();
            },
            /**
             * as we type, it gives us suggestion
             */
            suggestionsCallback: (search) async {
              return await Get.find<LocationController>()
                  .searchLocation(context, search);
            },
            itemBuilder: (context, PredictionModel suggestion) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width10,
                  vertical: Dimensions.width10 / 2,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on),
                    Expanded(
                      child: Text(
                        suggestion.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        // ignore: deprecated_member_use
                        style: Theme.of(context).textTheme.headline2?.copyWith(
                              color:
                                  // ignore: deprecated_member_use
                                  Theme.of(context).textTheme.bodyText1?.color,
                              fontSize: Dimensions.fontSize15,
                            ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
