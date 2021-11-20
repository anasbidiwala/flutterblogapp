import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:the_blog_app/animation/fade_animation.dart';
import 'package:the_blog_app/common_widgets/drawer.dart';
import 'package:the_blog_app/screens/Blogs/add_blog_screen.dart';
import 'package:the_blog_app/screens/Blogs/blog_list_widget.dart';
import 'package:the_blog_app/screens/UserProfile/search_screen.dart';
import 'package:the_blog_app/screens/UserProfile/user_profile_screen.dart';
import 'package:the_blog_app/service/push_notification_service.dart';
import 'package:the_blog_app/utils/model_object_helper.dart';
import 'package:the_blog_app/utils/size_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ModelObjectHelper {

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    initModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: SideDrawerWidget(scaffoldKey: _scaffoldKey,),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Get.to(() => AddBlogScreen());
          },
          backgroundColor: appModel.primaryColor,
          child: Icon(Icons.add),
        ),
        body: Column(
          children: [
            FadeAnimation(
              delay: 0.25,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(16),vertical: getProportionateScreenHeight(18)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      child: Container(
                        child: const Icon(Icons.menu),
                        decoration: BoxDecoration(
                            color: appModel.whiteColor,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        padding: const EdgeInsets.all(6),
                      ),
                    ),
                    InkWell(onTap: () async {
                      // Get.to(() => const UserProfileScreen(isMyProfile: false,userId: 'yZ8cURzFJRY6ZYOXftrOay6qTx13',));
                      // await PushNotificationService.instance.sendNotification();


                    },child: Text("The Blog App",style: SizeConfig.themeData.textTheme.bodyText1!.copyWith(fontSize: getProportionateScreenWidth(20),fontWeight: FontWeight.w600),)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: InkWell(child: Icon(Icons.search),onTap: (){
                        Get.to(() => const SearchScreen());
                      },),
                    )
                  ],
                ),
              ),
            ),

            const Expanded(
              child: BlogListWidget(fetchAllBlogs: true,title: "Latest Blogs",),
            )
          ],
        ),
      ),
    );
  }
}
