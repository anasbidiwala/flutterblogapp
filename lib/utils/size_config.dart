import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double preciseScreenHeight;
  static late double preciseScreenWidth;
  static late double defaultSize;
  static late Orientation orientation;
  static late ThemeData themeData;

  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    themeData = Theme.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
    preciseScreenHeight = mediaQueryData.size.height - (mediaQueryData.padding.top + mediaQueryData.padding.bottom);
    preciseScreenWidth = mediaQueryData.size.width - (mediaQueryData.padding.left + mediaQueryData.padding.right);
    orientation = mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 683.42) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 411.42) * screenWidth;
}
