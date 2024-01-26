import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/utils/app_colors.dart';
import 'package:flutter_e_commerce_app_with_backend/widgets/small_text.dart';

import '../utils/dimensions.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  const ExpandableTextWidget({super.key, required this.text});

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;

  double textHieght = Dimensions.screenHeight / 5.05;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > textHieght) {
      firstHalf = widget.text.substring(0, textHieght.toInt());
      secondHalf =
          widget.text.substring(textHieght.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? SmallText(text: firstHalf)
          : Column(
              children: [
                SmallText(
                  color: AppColor.primaryColor,
                  size: Dimensions.height20 * 0.8,
                  text: hiddenText
                      ? ("$firstHalf ...")
                      : (firstHalf + secondHalf),
                ),
                InkWell(
                  onTap: () {
                    hiddenText = !hiddenText;
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      hiddenText
                          ? SmallText(
                              text: "Show All",
                              size: Dimensions.height20,
                            )
                          : SmallText(
                              size: Dimensions.height20,
                              text: "Show less",
                            ),
                      Icon(
                        hiddenText
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up,
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
