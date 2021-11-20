import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_blog_app/utils/constants.dart';

class AppModel with ChangeNotifier{

  late Map<String,dynamic> appConfig;
  late ThemeData currentTheme;
  late Map<AppTheme,Map<String,String>> appColors;
  late Color primaryColor;
  late Color primaryColorLight;
  late Color primaryColorDark;
  late Color scaffoldBackgroundColor;
  late Color textColor;
  late Color whiteColor;

  AppTheme appThemeMode = AppTheme.LIGHT;

  AppModel(){

    appColors = {
      AppTheme.LIGHT : {
        "primaryColor" : "#264473",
        "primaryColorLight" : "#4071bf",
        "primaryColorDark" : "#192d4d",
        "scaffoldBackgroundColor" : "#d9e3f2",
        "textColor" : "#000000",
        "whiteColor" : "#FFFFFF"
      },
      AppTheme.DARK : {
        "primaryColor" : "#DC143C",
        "primaryColorLight" : "#ec365b",
        "primaryColorDark" : "#ad102f",
        "scaffoldBackgroundColor" : "#DCDCDC",
        "textColor" : "#2f040d",
        "whiteColor" : "#FFFFFF"
      },
    };
    primaryColor = HexColor(appColors[appThemeMode]!["primaryColor"]!);
    primaryColorLight = HexColor(appColors[appThemeMode]!["primaryColorLight"]!);
    primaryColorDark = HexColor(appColors[appThemeMode]!["primaryColorDark"]!);
    scaffoldBackgroundColor = HexColor(appColors[appThemeMode]!["scaffoldBackgroundColor"]!);
    textColor = HexColor(appColors[appThemeMode]!["textColor"]!);
    whiteColor = HexColor(appColors[appThemeMode]!["whiteColor"]!);
  }

  void changeAppMode(AppTheme appTheme)
  {
    appThemeMode = appTheme;
    notifyListeners();
  }


}