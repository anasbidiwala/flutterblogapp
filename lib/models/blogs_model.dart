import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:the_blog_app/models/user_model.dart';
import 'package:the_blog_app/service/api_service.dart';
import 'package:the_blog_app/service/firestore_service.dart';

class BlogsModel with ChangeNotifier{

  List<SingleBlog> blogList = [];
  List<SingleBlog> userWiseBlogList = [];
  StreamController blogListUpdateInformer = StreamController.broadcast();
  StreamController userWiseBlogListUpdateInformer = StreamController.broadcast();



  void addBlogsToList(Map<String,dynamic> singleBlogJson){
    blogList.add(SingleBlog.fromJson(singleBlogJson));
  }

  void addBlogsToUserWiseList(Map<String,dynamic> singleBlogJson){
    userWiseBlogList.add(SingleBlog.fromJson(singleBlogJson));
  }

  List<SingleBlog> getBlogList({bool isFilterApplied = false,String filterValue = ""})
  {
    return isFilterApplied ? blogList.where((element) => element.blogCategory == filterValue).toList() : blogList;
  }

  List<SingleBlog> getUserWiseBlogList({bool isFilterApplied = false,String filterValue = ""})
  {
    return isFilterApplied ? userWiseBlogList.where((element) => element.blogCategory == filterValue).toList() : userWiseBlogList;
  }

  void addBlogsUpdateListener(BuildContext context)
  {
    FireStoreService.instance.addListener(collectionName: "",onData: (event) {
      event.docChanges.forEach((res) {
        if (res.type == DocumentChangeType.added) {
          print("added");
          print(res.doc.data());
        } else if (res.type == DocumentChangeType.modified) {
          print("modified");
          print(res.doc.data());
        } else if (res.type == DocumentChangeType.removed) {
          print("removed");
          print(res.doc.data());
        }
      });
      fetchAllBlog(context: context,showLoader: false,showToast: false);

    },);
  }

  Future<void> addBlogToServer({required BuildContext context,required Map<String,dynamic> params,required File fileToUpload,bool backNavigationRequired = false}) async {
    try {

      final addStaffToServer = await ApiService.instance.apiWrapper(apiFunction: (){
        return FireStoreService.instance.addBlogs(params: params,fileToUpload: fileToUpload);
      },context: context,showLoader: true,showToast: true);
      if(addStaffToServer!=null)
      {

        print("WHAT IS BLOG DATA ${addStaffToServer["data"]}");

        String title = "${addStaffToServer["data"]["blog_owner_name"]} Added New Blog";
        String message  = "${addStaffToServer["data"]["blog_title"]}";
        Provider.of<UserModel>(context,listen: false).fetchAllUserAndSendNotification(context: context,title: title,message: message,userId: addStaffToServer["data"]["blog_owner_id"]);


        // UserModel userModel = Provider.of<UserModel>(context,listen: false);
        //
        // Map<String,dynamic> paramsForFetchStaffList = {};
        // paramsForFetchStaffList["agencyId"] = userModel.userDetails!.agencyId;
        // if(userModel.userDetails!.userRoleMaster.userRoleCode ==  UserType.GDM)
        // {
        //   paramsForFetchStaffList["userRoleIds"] = [
        //     userModel.allUserRoleId[UserType.DEM]!.userRoleId,
        //     userModel.allUserRoleId[UserType.CS]!.userRoleId,
        //   ];
        // }
        //
        // if(userModel.userDetails!.userRoleMaster.userRoleCode ==  UserType.SHM)
        // {
        //   paramsForFetchStaffList["userRoleIds"] = [
        //     userModel.allUserRoleId[UserType.DEM]!.userRoleId,
        //     userModel.allUserRoleId[UserType.CS]!.userRoleId,
        //     // userModel.allUserRoleId[UserType.GDM]!.userRoleId,
        //   ];
        // }
        //
        // fetchStaffList(context: context, params: paramsForFetchStaffList);
        //
        // // fetchStaffList(context: context,agencyId: userModel.userDetails!.agencyMaster.agencyId);
        //
        //
        // // Map<String,dynamic> paramsToRefreshPlantTransactionList = {};
        // // paramsToRefreshPlantTransactionList["userId"] = userModel.userDetails!.userId;
        // // paramsToRefreshPlantTransactionList["plantTransactionType"] = getPlantTransactionType(params["plantTransactionType"]);
        // // fetchTransactionList(context: context, params: paramsToRefreshPlantTransactionList);
        //
        // Map<String,dynamic> paramsForFetchingCount = {};
        //
        // if(userModel.userDetails!.userRoleMaster.userRoleCode == UserType.DEM || userModel.userDetails!.userRoleMaster.userRoleCode == UserType.CS)
        // {
        //   paramsForFetchingCount["userid"] = userModel.userDetails!.userId;
        //   paramsForFetchingCount["userrole"] = userModel.userDetails!.userRoleMaster.userRoleName;
        //   Provider.of<InventoryModel>(context,listen: false).fetchTotalRequestAndAmount(context: context,params: paramsForFetchingCount);
        // }else{
        //
        //   paramsForFetchingCount["agencyid"] = userModel.userDetails!.agencyId;
        //   paramsForFetchingCount["userrole"] = userModel.userDetails!.userRoleMaster.userRoleName;
        //   Provider.of<InventoryModel>(context,listen: false).fetchTotalRequestAndAmount(context: context,params: paramsForFetchingCount);
        // }

        if(backNavigationRequired)
        {
          Get.back();
        }
        // ApiService.instance.showToastMessage(message: "Inventory Transaction Added Successfully");

      }
    } catch (err, trace) {
      print("ERROR IN SEND OTP ${err}");
      print("#TRACE ${trace}");
      notifyListeners();
    }
  }

  Future<void> updateBlogToServer({required BuildContext context,required Map<String,dynamic> params,required File? fileToUpload,bool backNavigationRequired = false,required String blogId}) async {
    try {

      final updateBlogToServer = await ApiService.instance.apiWrapper(apiFunction: (){
        return FireStoreService.instance.updateBlogs(params: params,fileToUpload: fileToUpload,blogId: blogId);
      },context: context,showLoader: true,showToast: true);
      if(updateBlogToServer!=null)
      {


        // UserModel userModel = Provider.of<UserModel>(context,listen: false);
        //
        // Map<String,dynamic> paramsForFetchStaffList = {};
        // paramsForFetchStaffList["agencyId"] = userModel.userDetails!.agencyId;
        // if(userModel.userDetails!.userRoleMaster.userRoleCode ==  UserType.GDM)
        // {
        //   paramsForFetchStaffList["userRoleIds"] = [
        //     userModel.allUserRoleId[UserType.DEM]!.userRoleId,
        //     userModel.allUserRoleId[UserType.CS]!.userRoleId,
        //   ];
        // }
        //
        // if(userModel.userDetails!.userRoleMaster.userRoleCode ==  UserType.SHM)
        // {
        //   paramsForFetchStaffList["userRoleIds"] = [
        //     userModel.allUserRoleId[UserType.DEM]!.userRoleId,
        //     userModel.allUserRoleId[UserType.CS]!.userRoleId,
        //     // userModel.allUserRoleId[UserType.GDM]!.userRoleId,
        //   ];
        // }
        //
        // fetchStaffList(context: context, params: paramsForFetchStaffList);
        //
        // // fetchStaffList(context: context,agencyId: userModel.userDetails!.agencyMaster.agencyId);
        //
        //
        // // Map<String,dynamic> paramsToRefreshPlantTransactionList = {};
        // // paramsToRefreshPlantTransactionList["userId"] = userModel.userDetails!.userId;
        // // paramsToRefreshPlantTransactionList["plantTransactionType"] = getPlantTransactionType(params["plantTransactionType"]);
        // // fetchTransactionList(context: context, params: paramsToRefreshPlantTransactionList);
        //
        // Map<String,dynamic> paramsForFetchingCount = {};
        //
        // if(userModel.userDetails!.userRoleMaster.userRoleCode == UserType.DEM || userModel.userDetails!.userRoleMaster.userRoleCode == UserType.CS)
        // {
        //   paramsForFetchingCount["userid"] = userModel.userDetails!.userId;
        //   paramsForFetchingCount["userrole"] = userModel.userDetails!.userRoleMaster.userRoleName;
        //   Provider.of<InventoryModel>(context,listen: false).fetchTotalRequestAndAmount(context: context,params: paramsForFetchingCount);
        // }else{
        //
        //   paramsForFetchingCount["agencyid"] = userModel.userDetails!.agencyId;
        //   paramsForFetchingCount["userrole"] = userModel.userDetails!.userRoleMaster.userRoleName;
        //   Provider.of<InventoryModel>(context,listen: false).fetchTotalRequestAndAmount(context: context,params: paramsForFetchingCount);
        // }

        if(backNavigationRequired)
        {
          Get.back();
        }
        // ApiService.instance.showToastMessage(message: "Inventory Transaction Added Successfully");

      }
    } catch (err, trace) {
      print("ERROR IN SEND OTP ${err}");
      print("#TRACE ${trace}");
      notifyListeners();
    }
  }

  Future<void> fetchAllBlog({required BuildContext context,bool isToAppend = false,bool showLoader = true,bool showToast = false}) async {
    try {
      final getBlogList = await ApiService.instance.apiWrapper(apiFunction: (){
        return FireStoreService.instance.fetchAllBlogs();
      },context: context,showLoader: showLoader,showToast: showToast);
      if(getBlogList!=null)
      {

        if(!isToAppend)
        {
          blogList.clear();
        }

        (getBlogList["data"] as List<dynamic>).forEach((element) {
          addBlogsToList(element);
          print(jsonEncode(element));
        });
        blogListUpdateInformer.add({});

        //
        // (getStaffList["data"] as List<dynamic>).forEach((element) {
        //   addStaffToList(element);
        // });
        // staffFetchListener.add({});
        // inventoryListFetchListener[params["inventoryTransactionCode"] as InventoryTransactionCode]!.add({});
        // ApiService.instance.showToastMessage(message: "Transaction Added Successfully");
        // Get.back();
      }
    } catch (err, trace) {
      print("ERROR IN Fetching Blogs ${err}");
      print("#TRACE ${trace}");
      notifyListeners();
    }
  }

  Future<void> fetchUserWiseBlog({required BuildContext context,required String userId,bool isToAppend = false}) async {
    try {

      final getBlogList = await ApiService.instance.apiWrapper(apiFunction: (){
        return FireStoreService.instance.fetchUserWiseBlogs(userId: userId);
      },context: context,showLoader: true,showToast: false);
      if(getBlogList!=null)
      {


        if(!isToAppend)
        {
          userWiseBlogList.clear();
        }

        (getBlogList["data"] as List<dynamic>).forEach((element) {
          addBlogsToUserWiseList(element);
          print(jsonEncode(element));
        });
        print("WHAT IS LENGTh ${userWiseBlogList.length}");
        userWiseBlogListUpdateInformer.add({});

        //
        // (getStaffList["data"] as List<dynamic>).forEach((element) {
        //   addStaffToList(element);
        // });
        // staffFetchListener.add({});
        // inventoryListFetchListener[params["inventoryTransactionCode"] as InventoryTransactionCode]!.add({});
        // ApiService.instance.showToastMessage(message: "Transaction Added Successfully");
        // Get.back();
      }
    } catch (err, trace) {
      print("ERROR IN FETCHING USERWISE BLOGS ${err}");
      print("#TRACE ${trace}");
      notifyListeners();
    }
  }

  Future<void> deleteBlog({required BuildContext context,required String blogId}) async {
    try {

      final loginWithEmail = await ApiService.instance.apiWrapper(apiFunction: (){
        return FireStoreService.instance.deleteBlog(blogId: blogId);
      },context: context,showLoader: true,showToast: true);

      if(loginWithEmail!=null)
      {
        print("BLOG DELETED RESPONSE ${loginWithEmail.toString()}");
        print("LOGIN SUCCESS");

        // userDetails = userDetailsFromJson(jsonEncode(loginWithEmail["data"]));
        // isLoggedIn = true;
        //
        // CacheService.instance.writeCache(key: "isLoggedIn", value: "YES");
        // CacheService.instance.writeCache(key: "userDetails", value: json.encode(userDetails!.toJson()));
        //
        //
        // Get.offAll(() => const HomeScreen());
        // notifyListeners();

      }
    } catch (err, trace) {
      print("#ERROR ${err}");
      print("StackTrace $trace");
      notifyListeners();
    }
  }
}


SingleBlog singleBlogFromJson(String str) => SingleBlog.fromJson(json.decode(str));

String singleBlogToJson(SingleBlog data) => json.encode(data.toJson());

class SingleBlog {
  SingleBlog({
    required this.blogImgUrl,
    required this.blogId,
    required this.blogAddedOn,
    required this.blogCategory,
    required this.blogOwnerId,
    required this.blogOwnerName,
    required this.blogTitle,
    required this.blogDesc,
  });

  String blogImgUrl;
  String blogId;
  String blogAddedOn;
  String blogCategory;
  String blogOwnerId;
  String blogOwnerName;
  String blogTitle;
  String blogDesc;

  factory SingleBlog.fromJson(Map<String, dynamic> json) => SingleBlog(
    blogImgUrl: json["blog_img_url"],
    blogId: json["blog_id"],
    blogAddedOn: json["blog_added_on"],
    blogCategory: json["blog_category"],
    blogOwnerId: json["blog_owner_id"],
    blogOwnerName: json["blog_owner_name"],
    blogTitle: json["blog_title"],
    blogDesc: json["blog_desc"],
  );

  Map<String, dynamic> toJson() => {
    "blog_img_url": blogImgUrl,
    "blog_id": blogId,
    "blog_added_on": blogAddedOn,
    "blog_category": blogCategory,
    "blog_owner_id": blogOwnerId,
    "blog_owner_name": blogOwnerName,
    "blog_title": blogTitle,
    "blog_desc": blogDesc,
  };
}
