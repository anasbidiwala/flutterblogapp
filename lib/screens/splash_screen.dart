import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_blog_app/models/user_model.dart';
import 'package:the_blog_app/screens/Home/home_screen.dart';
import 'package:the_blog_app/screens/LoginRegister/login_screen.dart';
import 'package:the_blog_app/service/cache_manager_service.dart';
import 'package:the_blog_app/utils/model_object_helper.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with ModelObjectHelper,TickerProviderStateMixin {

  late AnimationController _scaleController;
  late Animation scaleAnimation;

  @override
  void initState() {
    // TODO: implement initState
    initModel(context);
    _scaleController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 100.0,
    ).animate(_scaleController);




    scaleAnimation.addStatusListener((status) {
      var isLoggedIn = CacheService.instance.readCache(key: "isLoggedIn");
      var userDetails = CacheService.instance.readCache(key: "userDetails");
      if(userDetails!=null)
      {
        if(status == AnimationStatus.completed) {
          userModel.userDetails = UserDetails.fromJson(json.decode(userDetails));
          userModel.isLoggedIn = true;

          userModel.fetchMyPushNotificationStatus(context: context,userId: userModel.userDetails!.userId);
          categoryModel.fetchAllCategory(context: context);
          blogsModel.addBlogsUpdateListener(context);


          // userModel.currentUserBlocks =
          // userModel.userBasedBlocks[userModel.userDetails!.userRoleMaster
          //     .userRoleCode]!;
          // appModel.changeAppMode(
          //     userModel.userDetails!.agencyMaster.agencyType);
          // productModel.fetchProduct(context: context,
          //     agencyId: userModel.userDetails!.agencyMaster.agencyId);
          // productModel.subscribeToListener();
          //
          // productModel.fetchArticles(context: context,
          //     agencyId: userModel.userDetails!.agencyMaster.agencyId);
          //
          // // productModel.fetchArticles(context: context, agencyId: userModel.userDetails!.agencyMaster.agencyId);
          //
          // userModel.fetchAllUserRole(context: context,
          //     agencyId: userModel.userDetails!.agencyMaster.agencyId);
          //
          //
          // if (userModel.userDetails!.userRoleMaster.userRoleCode ==
          //     UserType.DEM ||
          //     userModel.userDetails!.userRoleMaster.userRoleCode ==
          //         UserType.CS) {
          //   Map<String, dynamic> params = {};
          //   params["userid"] = userModel.userDetails!.userId;
          //   params["userrole"] =
          //       userModel.userDetails!.userRoleMaster.userRoleName;
          //   inventoryModel.fetchTotalRequestAndAmount(
          //       context: context, params: params);
          // } else {
          //   Map<String, dynamic> params = {};
          //   params["agencyid"] = userModel.userDetails!.agencyId;
          //   params["userrole"] =
          //       userModel.userDetails!.userRoleMaster.userRoleName;
          //   inventoryModel.fetchTotalRequestAndAmount(
          //       context: context, params: params);
          // }
        }

      }
      if(status == AnimationStatus.completed)
      {

        if(isLoggedIn == null)
        {
          Get.offAll(() => LoginScreen(),transition: Transition.fade);
        }else{
          Get.offAll(() => HomeScreen(),transition: Transition.fade);
        }
      }
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) => {
      Future.delayed(Duration(seconds: 1),(){
        _scaleController.forward();
      })
    });








    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appModel.primaryColor,
        body: Container(
          child: Column(
            children: [
              Expanded(child: Container()),
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _scaleController,
                    builder: (context, child) => Transform.scale(scale: scaleAnimation.value,child: AutoSizeText(
                      "THE BLOG APP",
                      maxLines: 1,
                      style: GoogleFonts.anton(fontSize: 35, letterSpacing: 2,color: appModel.whiteColor),
                    ),),
                  ),
                ),
              ),
              Expanded(child: Container(
                child: Center(
                  child: SpinKitFadingCube(
                    color: appModel.whiteColor,
                    size: 50.0,
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
