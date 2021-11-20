import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_blog_app/models/user_model.dart';
import 'package:the_blog_app/screens/UserProfile/user_list_tile.dart';
import 'package:the_blog_app/screens/UserProfile/user_profile_screen.dart';
import 'package:the_blog_app/utils/model_object_helper.dart';
import 'package:the_blog_app/utils/size_config.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with ModelObjectHelper {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController searchUserTextEditingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    initModel(context);
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    searchUserTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Padding(
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
                    Text("Search User",style: SizeConfig.themeData.textTheme.bodyText1!.copyWith(fontSize: getProportionateScreenWidth(20),fontWeight: FontWeight.w600),)


                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextField(
                  controller: searchUserTextEditingController,
                  style: TextStyle(color: appModel.primaryColor),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    if(value!=null)
                    {
                      if(value!="")
                      {
                        userModel.searchUser(context: context,searchKeyword: value);
                      }else{
                        print("CLEARED");
                        userModel.searchedUser.clear();
                        userModel.searchFetchedInformer.add(userModel.searchedUser);
                      }

                    }else{
                      userModel.searchedUser.clear();
                    }


                  },
                  decoration: InputDecoration(
                    hintText: "Search With Username / Email",
                    hintStyle: TextStyle(color: Colors.grey),
                    errorStyle: TextStyle(color: Colors.red),
                    filled: false,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: appModel.primaryColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(16),vertical: getProportionateScreenHeight(18)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder<List<UserDetails>?>(
                            stream: userModel.searchFetchedInformer.stream,
                            builder: (context, snapshot) {
                              return searchUserTextEditingController.text=="" ? Text("",style: SizeConfig.themeData.textTheme.bodyText1!.copyWith(fontSize: getProportionateScreenWidth(20),fontWeight: FontWeight.w600),) : snapshot.data!=null ? Text("${snapshot.data!.length} Users Found",style: SizeConfig.themeData.textTheme.bodyText1!.copyWith(fontSize: getProportionateScreenWidth(20),fontWeight: FontWeight.w600),) : Text("",style: SizeConfig.themeData.textTheme.bodyText1!.copyWith(fontSize: getProportionateScreenWidth(20),fontWeight: FontWeight.w600),);
                            },
                          )


                        ],
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<List<UserDetails>?>(
                        stream: userModel.searchFetchedInformer.stream,
                        builder: (context, snapshot) {
                          return searchUserTextEditingController.text=="" ? Center(child: Text("Enter Username / Email To Search"),) : snapshot.data!=null && snapshot.data!.isEmpty ? Center(child: Text("No User Found"),) : ListView.builder(
                            itemCount: userModel.searchedUser.length,
                            itemBuilder: (context, index) {
                              return UserListTileWidget(onClick: (){
                                Get.to(() => UserProfileScreen(isMyProfile: false,userId: userModel.searchedUser[index].userId,));
                              }, userDetail: userModel.searchedUser[index]);
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              )



            ],
          ),
        ),
      ),
    );
  }
}
