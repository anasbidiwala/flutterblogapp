import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:the_blog_app/models/blogs_model.dart';
import 'package:the_blog_app/models/category_model.dart';
import 'package:the_blog_app/models/user_model.dart';
import 'package:the_blog_app/screens/splash_screen.dart';
import 'package:the_blog_app/service/push_notification_service.dart';
import 'package:the_blog_app/utils/misc_functions.dart';
import 'models/app_model.dart';
import 'service/api_service.dart';
import 'utils/constants.dart';
import 'utils/theme.dart';

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppModel appModel = AppModel();
  UserModel userModel = UserModel();
  BlogsModel blogsModel = BlogsModel();
  CategoryModel categoryModel = CategoryModel();


  @override
  void initState() {
    // userModel.userDetails = UserDetails.fromJson(showroomManagerUserDetail);
    // userModel.isLoggedIn = true;
    // userModel.currentUserBlocks = userModel.userBasedBlocks[userModel.userDetails!.userRoleMaster.userRoleCode]!;
    // appModel.changeAppMode(userModel.userDetails!.agencyMaster.agencyType);
    initPushNotification();
    super.initState();
  }

  initPushNotification()
  async {
    await PushNotificationService.instance.initialise();
  }


  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<AppModel>.value(
      value: appModel,
      child: Consumer<AppModel>(
        builder: (context, model, child) {

          //Setting Status Bar Color
          MiscFunctions().setStatusBar(model.primaryColor);
          //Initialize Api Wrapper Class Varaible
          ApiService.instance.init(context);

          return MultiProvider(
            providers: [
              ChangeNotifierProvider<UserModel>.value(value: userModel),
              ChangeNotifierProvider<BlogsModel>.value(value: blogsModel),
              ChangeNotifierProvider<CategoryModel>.value(value: categoryModel),
            ],
            child: OverlaySupport.global(
              child: GetMaterialApp(
                title: "Gas Stock",
                debugShowCheckedModeBanner: false,
                defaultTransition: Transition.cupertino,
                theme: theme(context),
                home: SplashScreen(),
                // home: NewDashboardScreen(),
              ),
            ),
          );
        },
      ),
    );
  }
}