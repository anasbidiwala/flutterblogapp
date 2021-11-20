import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:the_blog_app/screens/UserProfile/user_profile_screen.dart';
import 'package:the_blog_app/service/push_notification_service.dart';
import 'package:the_blog_app/utils/model_object_helper.dart';
import 'package:the_blog_app/utils/size_config.dart';

class SideDrawerWidget extends StatefulWidget {

  const SideDrawerWidget({Key? key, required this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _SideDrawerWidgetState createState() => _SideDrawerWidgetState();
}

class _SideDrawerWidgetState extends State<SideDrawerWidget> with ModelObjectHelper {

  List<Map<String,dynamic>> drawerMenus = [
    {"title" : "My Profile","screen" : UserProfileScreen(isMyProfile: true,)},
    {"title" : "Search User","screen" : Container()},
  ];




  @override
  void initState() {
    // TODO: implement initState
    initModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print("WHAT IS VALUE ${userModel.isPushNotificationOn}");

    return Drawer(
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(20)),
                child: AutoSizeText(
                  "THE BLOG APP",
                  maxLines: 1,
                  style: GoogleFonts.anton(fontSize: 35, letterSpacing: 2),
                ),
              ),

              Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(8),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text("${userModel.userDetails!.username}"),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(4),
                        ),
                        Container(
                          child: Text("${userModel.userDetails!.userEmail}"),
                        )
                      ],
                    ),
                    Spacer(),
                    InkWell(
                      onTap: (){
                        userModel.logOut();
                      },
                      child: const Icon(
                        LineIcons.alternateSignOut,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(8),),
              Divider(color: appModel.primaryColor,)
            ],
          ),

          SwitchListTile(key: UniqueKey(),value: userModel.isPushNotificationOn, onChanged: (value) async {
            if(value)
            {
              var notificationToken = await PushNotificationService.instance.messaging.getToken();
              if(notificationToken!=null)
              {
                await userModel.subscribeToPushNotification(context: context, userId: userModel.userDetails!.userId, notificationToken: notificationToken);
                setState(() {

                });
              }
            }else{
              await userModel.unsubscribeToPushNotification(context: context, userId: userModel.userDetails!.userId);
              setState(() {

              });
            }
          },title: Text("Turn On Push Notification"),),

          Expanded(
            child: ListView.builder(
                itemCount: drawerMenus.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (ctx, index) {

                  return InkWell(
                    onTap: (){
                      Get.to(() => drawerMenus[index]["screen"] as Widget);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(30)),
                      child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          drawerMenus[index]["title"],
                          maxLines: 1,
                          style: GoogleFonts.roboto(
                              letterSpacing: 2, color: Colors.black,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );


                }),
          ),
          InkWell(
            onTap: (){
              userModel.logOut();
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(20)),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text(
                    "Sign Out",
                    style: GoogleFonts.poppins(
                        letterSpacing: 2, color: Colors.red,fontSize: 25),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
