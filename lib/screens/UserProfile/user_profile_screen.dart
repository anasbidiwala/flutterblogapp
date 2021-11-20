import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_blog_app/models/user_model.dart';
import 'package:the_blog_app/screens/Blogs/blog_list_widget.dart';
import 'package:the_blog_app/utils/model_object_helper.dart';
import 'package:the_blog_app/utils/size_config.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key, this.isMyProfile = true, this.userId}) : super(key: key);

  final bool isMyProfile;
  final String? userId;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> with ModelObjectHelper {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UserDetails? userDetail;
  late StreamController<UserDetails> userDetailFetchedInformer;
  @override
  void initState() {
    // TODO: implement initState
    initModel(context);
    userDetailFetchedInformer = StreamController.broadcast();
    WidgetsBinding.instance!.addPostFrameCallback((_){
      fetchUserDetails();
    });
    super.initState();
  }

  Future<void> fetchUserDetails()
  async {
    userDetail = await userModel.fetchUserDetails(context: context, userId: widget.isMyProfile ? userModel.userDetails!.userId : widget.userId!);
    if(userDetail!=null)
    {
      userDetailFetchedInformer.add(userDetail!);
    }

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: StreamBuilder<UserDetails>(
          initialData: null,
          stream: userDetailFetchedInformer.stream,
          builder: (context, snapshot) {
            return  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: getProportionateScreenWidth(16),right: getProportionateScreenWidth(16),top: getProportionateScreenHeight(18),bottom: 0),
                    child: Row(

                      children: [
                        InkWell(
                          onTap: (){
                            Get.back();
                          },
                          child: Container(
                            child: Center(child: const Icon(Icons.arrow_back)),
                            decoration: BoxDecoration(
                                color: appModel.whiteColor,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            padding: const EdgeInsets.all(6),
                          ),
                        ),
                        SizedBox(width: getProportionateScreenWidth(20),),
                        Text("${widget.isMyProfile ? "My Profile" : "Profile"}",style: SizeConfig.themeData.textTheme.bodyText1!.copyWith(fontSize: getProportionateScreenWidth(20),fontWeight: FontWeight.w600),)


                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: snapshot.data==null ? Container() : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          child: ClipOval(
                            child: Image.asset("assets/img/users.png"),
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(8),),
                        Text("${userDetail!.username}",style: SizeConfig.themeData.textTheme.subtitle1,),
                        SizedBox(height: getProportionateScreenHeight(4),),
                        Text("${userDetail!.userEmail}",style :SizeConfig.themeData.textTheme.subtitle2),
                        SizedBox(width: getProportionateScreenWidth(8),),

                        Expanded(
                          child: BlogListWidget(fetchAllBlogs: false,userId: userDetail!.userId,title: "${widget.isMyProfile ? "My" : "${userDetail!.username}'s"} Blogs",),
                        )
                      ],
                    ),
                  ),



                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
