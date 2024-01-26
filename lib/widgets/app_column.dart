import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/small_text.dart';
import '../utils/app_colors.dart';
import '../utils/dimensions.dart';
import 'big_text.dart';
import 'icon_text_widget.dart';

class AppColumn extends StatelessWidget {
  final String text;
  const AppColumn({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigText(
          text: text,
          size: Dimensions.fontSize20,
        ),
        SizedBox(height: Dimensions.height5),
        Row(
          children: [
            Wrap(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  size: Dimensions.fontSize20, //size:20
                ),
              ),
            ),
            SizedBox(
              width: Dimensions.width10,
            ),
            //
            SmallText(
              text: "4.5",
              size: Dimensions.fontSize15,
            ),
            SizedBox(
              width: Dimensions.width10,
            ),
            SmallText(
              text: "1350",
              size: Dimensions.fontSize15,
            ),
            SizedBox(
              width: Dimensions.width10,
            ),
            SmallText(
              text: "Comments",
              size: Dimensions.fontSize15,
            ),
          ],
        ),
        SizedBox(height: Dimensions.height5),
        //
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconAndTextReusableWidget(
              icondata: Icons.circle_sharp,
              text: "Normal",
              iconSize: Dimensions.iconSize17,
              sizeText: Dimensions.fontSize15,
              colorIcons: Colors.orange,
            ),
            IconAndTextReusableWidget(
              icondata: Icons.location_on,
              iconSize: Dimensions.iconSize17,
              colorIcons: Colors.green,
              text: "1.7km",
              sizeText: Dimensions.fontSize15,
            ),
            IconAndTextReusableWidget(
              icondata: Icons.access_time_rounded,
              iconSize: Dimensions.iconSize17,
              colorIcons: AppColor.mainColor,
              text: "33min",
              sizeText: Dimensions.fontSize15,
            ),
          ],
        ),
        //
      ],
    );
  }
}
