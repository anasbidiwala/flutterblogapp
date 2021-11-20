import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:the_blog_app/models/blogs_model.dart';
import 'package:the_blog_app/screens/Home/home_screen.dart';
import 'package:the_blog_app/screens/LoginRegister/login_screen.dart';
import 'package:the_blog_app/service/api_service.dart';
import 'package:the_blog_app/service/cache_manager_service.dart';
import 'package:the_blog_app/service/firebase_auth_service.dart';
import 'package:the_blog_app/service/firestore_service.dart';
import 'package:the_blog_app/service/push_notification_service.dart';

import 'category_model.dart';

class UserModel with ChangeNotifier
{
  UserDetails? userDetails;
  bool isLoggedIn = false;
  bool isPushNotificationOn = false;

  StreamController<List<UserDetails>?> searchFetchedInformer = StreamController.broadcast();
  List<UserDetails> searchedUser = [];

  Future<void> loginWithEmail({required BuildContext context,required String email,required String password}) async {
    try {

      final loginWithEmail = await ApiService.instance.apiWrapper(apiFunction: (){
        return FirebaseAuthService.instance.loginWithEmail(email: email, password: password);
      },context: context,showLoader: true,showToast: true);

      if(loginWithEmail!=null)
      {
        print("WHAT IS LOGIN RESPONSE ${loginWithEmail.toString()}");
        print("LOGIN SUCCESS");

        userDetails = userDetailsFromJson(jsonEncode(loginWithEmail["data"]));
        isLoggedIn = true;
        Provider.of<CategoryModel>(context,listen: false).fetchAllCategory(context: context);
        Provider.of<BlogsModel>(context,listen: false).addBlogsUpdateListener(context);
        fetchMyPushNotificationStatus(context: context,userId: userDetails!.userId);
        CacheService.instance.writeCache(key: "isLoggedIn", value: "YES");
        CacheService.instance.writeCache(key: "userDetails", value: json.encode(userDetails!.toJson()));
        Get.offAll(() => const HomeScreen());
        notifyListeners();

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

  Future<void> loginWithGoogle({required BuildContext context}) async {
    try {

      final loginWithEmail = await ApiService.instance.apiWrapper(apiFunction: (){
        return FirebaseAuthService.instance.loginWithGoogle();
      },context: context,showLoader: true,showToast: true);

      if(loginWithEmail!=null)
      {
        print("WHAT IS LOGIN RESPONSE ${loginWithEmail.toString()}");
        print("LOGIN SUCCESS");

        userDetails = userDetailsFromJson(jsonEncode(loginWithEmail["data"]));
        isLoggedIn = true;
        Provider.of<CategoryModel>(context,listen: false).fetchAllCategory(context: context);
        Provider.of<BlogsModel>(context,listen: false).addBlogsUpdateListener(context);
        fetchMyPushNotificationStatus(context: context,userId: userDetails!.userId);
        CacheService.instance.writeCache(key: "isLoggedIn", value: "YES");
        CacheService.instance.writeCache(key: "userDetails", value: json.encode(userDetails!.toJson()));
        Get.offAll(() => const HomeScreen());
        notifyListeners();

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

  Future<void> register({required BuildContext context,required String username,required String email,required String password}) async {
    try {

      final register = await ApiService.instance.apiWrapper(apiFunction: (){
        return FirebaseAuthService.instance.register(username: username,email: email, password: password);
      },context: context,showLoader: true,showToast: true);

      if(register!=null)
      {
        print("WHAT IS Register RESPONSE ${register.toString()}");
        print("Register SUCCESS");

        userDetails = userDetailsFromJson(jsonEncode(register["data"]));
        isLoggedIn = true;
        Provider.of<CategoryModel>(context,listen: false).fetchAllCategory(context: context);
        Provider.of<BlogsModel>(context,listen: false).addBlogsUpdateListener(context);
        fetchMyPushNotificationStatus(context: context,userId: userDetails!.userId);
        CacheService.instance.writeCache(key: "isLoggedIn", value: "YES");
        CacheService.instance.writeCache(key: "userDetails", value: json.encode(userDetails!.toJson()));
        Get.offAll(() => const HomeScreen());
        notifyListeners();

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

  Future<UserDetails?> fetchUserDetails({required BuildContext context,required String userId}) async {
    try {

      final loginWithEmail = await ApiService.instance.apiWrapper(apiFunction: (){
        return FirebaseAuthService.instance.fetchUserDetail(userId: userId);
      },context: context,showLoader: true,showToast: true);

      if(loginWithEmail!=null)
      {
        print("WHAT IS LOGIN RESPONSE ${loginWithEmail.toString()}");
        print("LOGIN SUCCESS");

        UserDetails userDetails = userDetailsFromJson(jsonEncode(loginWithEmail["data"]));
        return userDetails;

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

  Future<void> searchUser({required BuildContext context,required String searchKeyword}) async {
    try {
      final getSearchedResult = await ApiService.instance.apiWrapper(apiFunction: (){
        return FireStoreService.instance.searchUser(searchKeyword: searchKeyword);
      },context: context,showLoader: false,showToast: false);

      if(getSearchedResult!=null)
      {
        print("Searched Success ${getSearchedResult.toString()}");
        print("Searched SUCCESS");
        searchedUser.clear();


        (getSearchedResult["data"] as List<dynamic>).forEach((element) {
          searchedUser.add(UserDetails.fromJson(element));
        });

        searchFetchedInformer.add(searchedUser);

        // UserDetails userDetails = userDetailsFromJson(jsonEncode(loginWithEmail["data"]));
        // return userDetails;

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

  Future<void> fetchMyPushNotificationStatus({required BuildContext context,required String userId}) async {
    try {

      final fetchMyPushNotificationState = await ApiService.instance.apiWrapper(apiFunction: (){
        return FireStoreService.instance.fetchMyPushNotificationStatus(userId: userId);
      },context: context,showLoader: false,showToast: false);
      print("WHAT IS PUSH NOTIFICATION STATE ${fetchMyPushNotificationState}");
      if(fetchMyPushNotificationState!=null)
      {
        isPushNotificationOn =  true;

        // userDetails = userDetailsFromJson(jsonEncode(loginWithEmail["data"]));
        // isLoggedIn = true;
        //
        // CacheService.instance.writeCache(key: "isLoggedIn", value: "YES");
        // CacheService.instance.writeCache(key: "userDetails", value: json.encode(userDetails!.toJson()));
        //
        //
        // Get.offAll(() => const HomeScreen());
        // notifyListeners();

      }else{
        isPushNotificationOn =  false;
      }
    } catch (err, trace) {
      print("#ERROR ${err}");
      print("StackTrace $trace");
      notifyListeners();
    }
  }


  Future<void> subscribeToPushNotification({required BuildContext context,required String userId,required String notificationToken}) async {
    try {

      final register = await ApiService.instance.apiWrapper(apiFunction: (){
        return FireStoreService.instance.subscribeToPushNotification(userId: userId,notificationToken: notificationToken);
      },context: context,showLoader: true,showToast: false);

      if(register!=null)
      {

        await fetchMyPushNotificationStatus(context: context,userId: userId);

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

  Future<void> unsubscribeToPushNotification({required BuildContext context,required String userId}) async {
    try {

      final register = await ApiService.instance.apiWrapper(apiFunction: (){
        return FireStoreService.instance.unsubscribeToPushNotification(userId: userId);
      },context: context,showLoader: true,showToast: false);

      if(register!=null)
      {

        await fetchMyPushNotificationStatus(context: context,userId: userId);

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

  Future<void> fetchAllUserAndSendNotification({required BuildContext context,bool isToAppend = false,required String title,required String message,required String userId}) async {
    try {

      final userListToNotify = await ApiService.instance.apiWrapper(apiFunction: (){
        return FireStoreService.instance.fetchAllUserAndSendNotification();
      },context: context,showLoader: false,showToast: false);
      if(userListToNotify!=null)
      {

        // if(!isToAppend)
        // {
        //   blogList.clear();
        // }
        List<String> notificationTokens = [];
        (userListToNotify["data"] as List<dynamic>).forEach((element) {
          notificationTokens.add(element["token"]);
        });
        print("USER TOKENS ${notificationTokens}");
        PushNotificationService.instance.sendNotification(notificationTokens,title,message,userId);

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
      print("ERROR IN Fetching Category ${err}");
      print("#TRACE ${trace}");
      notifyListeners();
    }
  }

  void logOut()
  {
    userDetails = null;
    isLoggedIn = false;
    CacheService.instance.deleteCache(key: "isLoggedIn");
    CacheService.instance.deleteCache(key: "userDetails");
    Get.offAll(() => const LoginScreen());
  }
}

UserDetails userDetailsFromJson(String str) => UserDetails.fromJson(json.decode(str));

String userDetailsToJson(UserDetails data) => json.encode(data.toJson());

class UserDetails {
  UserDetails({
    required this.userId,
    required this.username,
    required this.userEmail,

  });

  String userId;
  String username;
  String userEmail;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    userId: json["user_id"],
    username: json["username"],

    userEmail: json["user_email"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "username": username,
    "user_email": userEmail,
  };
}