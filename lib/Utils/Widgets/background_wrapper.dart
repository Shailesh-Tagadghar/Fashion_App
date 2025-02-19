import 'package:fashion/Utils/Constants/color_constant.dart';
import 'package:fashion/Utils/Constants/widget_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///
/// Custom backgroud wrapper widget
///
class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  final String title;
  final bool isBackArrow;
  final double padding;
  final Widget? actionItem;

  const BackgroundWrapper({
    super.key,
    required this.child,
    required this.title,
    this.padding = 13.0,
    this.isBackArrow = false,
    this.actionItem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.whiteColor,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: padding),
            child: child,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: isBackArrow
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                SizedBox(width: isBackArrow ? 18 : 0),
                isBackArrow
                    ? InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back,
                          color: ColorConstants.whiteColor,
                        ),
                      )
                    : const SizedBox(),
                SizedBox(width: isBackArrow ? 18 : 0),
                Expanded(
                  child: WidgetConstants.text(
                    title,
                    fontSize: 14.0,
                    color: ColorConstants.whiteColor,
                    fontWeight: FontWeight.bold,
                    textAlign: isBackArrow ? TextAlign.start : TextAlign.center,
                  ),
                ),
                if (actionItem != null)
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: actionItem,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
