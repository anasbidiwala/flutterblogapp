import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:the_blog_app/models/app_model.dart';
import 'constants.dart';

ThemeData theme(BuildContext context) {

  AppModel appModel = Provider.of<AppModel>(context);

  if(appModel.appColors == null)
  {
    ThemeData theme = ThemeData(
      primarySwatch: Colors.orange,
      dialogBackgroundColor: HexColor("#f0ece6"),
      primaryColor: HexColor("#FFB52E"),
      splashColor: HexColor("#FFB52E"),
      // brightness: Brightness.dark,
      textTheme: const TextTheme(
        headline6: TextStyle(color: Colors.black),
        headline4: TextStyle(color: Colors.black),

      ),
      scaffoldBackgroundColor: Colors.white,
      indicatorColor: Colors.black26,
      secondaryHeaderColor: Colors.white,
    );
    Get.changeTheme(theme);
    appModel.currentTheme = theme;
    return theme;
  }


  // Color primaryColor = HexColor(appModel.appConfig["setting"]["primaryColor"]);
  // Color secondaryColor = HexColor(appModel.appConfig["setting"]["secondaryColor"]);
  // Color scaffoldBackgroundColor = HexColor(appModel.appConfig["setting"]["scaffoldBackgroundColor"]);

  appModel.primaryColor = HexColor(appModel.appColors[appModel.appThemeMode]!["primaryColor"]!);
  appModel.primaryColorLight = HexColor(appModel.appColors[appModel.appThemeMode]!["primaryColorLight"]!);
  appModel.primaryColorDark = HexColor(appModel.appColors[appModel.appThemeMode]!["primaryColorDark"]!);
  appModel.scaffoldBackgroundColor = HexColor(appModel.appColors[appModel.appThemeMode]!["scaffoldBackgroundColor"]!);
  appModel.textColor = HexColor(appModel.appColors[appModel.appThemeMode]!["textColor"]!);
  appModel.whiteColor = HexColor(appModel.appColors[appModel.appThemeMode]!["whiteColor"]!);


  ThemeData theme = ThemeData(
    // brightness: Brightness.dark,
    textTheme: TextTheme(
      headline1: GoogleFonts.roboto(color: appModel.textColor),
      headline2: GoogleFonts.roboto(color: appModel.textColor),
      headline3: GoogleFonts.roboto(color: appModel.textColor),
      headline4: GoogleFonts.roboto(color: appModel.textColor),
      headline5: GoogleFonts.roboto(color: appModel.textColor),
      headline6: GoogleFonts.roboto(color: appModel.textColor),
      bodyText1: GoogleFonts.roboto(color: appModel.textColor),
      bodyText2: GoogleFonts.roboto(color: appModel.textColor),
      subtitle1: GoogleFonts.roboto(color: appModel.textColor),
      subtitle2: GoogleFonts.roboto(color: appModel.textColor),
      button: GoogleFonts.roboto(color: appModel.textColor),
      caption: GoogleFonts.roboto(color: appModel.textColor),
      overline: GoogleFonts.roboto(color: appModel.textColor)
    ),
    inputDecorationTheme: inputDecorationTheme(appModel.primaryColorLight),
    primaryColor: appModel.primaryColor,
    primaryColorLight: appModel.primaryColorLight,
    primaryColorDark: appModel.primaryColorDark,
    scaffoldBackgroundColor: appModel.scaffoldBackgroundColor,
    appBarTheme: AppBarTheme(
      color: appModel.primaryColor,
      textTheme: TextTheme(
          headline6: GoogleFonts.roboto(color: appModel.whiteColor, fontWeight: FontWeight.bold)
      ),
      iconTheme: IconThemeData(color:appModel.whiteColor),
    ),
    iconTheme: IconThemeData(
      color: appModel.primaryColor,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: appModel.whiteColor,
      textTheme: ButtonTextTheme.primary,

    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        onPrimary: appModel.primaryColor,
        primary: appModel.whiteColor,
      ),
    )
  );
  Get.changeTheme(theme);
  appModel.currentTheme = theme;

  return theme;



}

// InputDecorationTheme inputDecorationTheme() {
//   OutlineInputBorder outlineInputBorder = OutlineInputBorder(
//     borderRadius: BorderRadius.circular(12),
//     borderSide: BorderSide(color: kTextColor),
//     gapPadding: 10,
//   );
//   return InputDecorationTheme(
//     // If  you are using latest version of flutter then lable text and hint text shown like this
//     // if you r using flutter less then 1.20.* then maybe this is not working properly
//     // if we are define our floatingLabelBehavior in our theme then it's not applayed
//     // floatingLabelBehavior: FloatingLabelBehavior.always,
//     contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 10),
//     enabledBorder: outlineInputBorder,
//     focusedBorder: outlineInputBorder,
//     border: outlineInputBorder,
//   );
// }

InputDecorationTheme inputDecorationTheme(Color color){
  return InputDecorationTheme(
      filled: true,
      fillColor: color,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder:OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6)
  );
}

// TextTheme textTheme() {
//   return const TextTheme(
//     bodyText1: TextStyle(color: kTextColor),
//     bodyText2: TextStyle(color: kTextColor),
//   );
// }
//
// AppBarTheme appBarTheme() {
//   return AppBarTheme(
//     color: kPrimaryColor,
//     elevation: 0,
//     brightness: Brightness.light,
//     iconTheme: IconThemeData(color: Colors.white),
//     textTheme: TextTheme(
//       headline6: TextStyle(color:Colors.white, fontSize: 18),
//      // headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
//     ),
//   );
// }
