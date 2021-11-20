import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_blog_app/service/firebase_storage_service.dart';
import 'package:the_blog_app/service/firestore_base_function.dart';
import 'package:the_blog_app/utils/misc_functions.dart';

class FireStoreService with FireStoreBaseFunction{


  FireStoreService._();

  static final instance = FireStoreService._();

  Map<String, dynamic> defaultFailedResponse = {
    "status": false,
    "message": "",
    "data": []
  };


  //**************************** USER *******************************
  Future<Map<String,dynamic>?> fetchMyPushNotificationStatus({required String userId})
  async {
    Map<String,dynamic>? responseToSend;


    try {
      DocumentSnapshot notificationTokenData = await fetchDocumentWithDocId(collectionName: "NotificationToken",docId: userId);
      print("TOKEND ADAT ${notificationTokenData.data()}");
      if(notificationTokenData.exists)
      {
        responseToSend = {
          "status" : true,
          "data" : notificationTokenData.data(),
          "message" : "Token Details Fetched Successfully",
        };
      }else{
        defaultFailedResponse["message"] = "Token Not Found";
        responseToSend = defaultFailedResponse;
        return responseToSend;
      }

    } on FirebaseException catch (e) {
      defaultFailedResponse["message"] = "Token Not Found";
      responseToSend = defaultFailedResponse;
      return responseToSend;
    }

    return responseToSend;
  }


  Future<Map<String,dynamic>?> searchUser({required String searchKeyword})
  async {
    final Map<String,dynamic>? responseToSend;
    List<Map<String,dynamic>> listOfData = [];
    await fireStoreInstance
        .collection("Users")
        .orderBy("username")
        .startAt([searchKeyword]).endAt([searchKeyword + "\uf8ff"])
        // .where("username",isGreaterThanOrEqualTo: searchKeyword)
        // .where("username",isLessThanOrEqualTo: searchKeyword)
        .get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        listOfData.add(result.data());
      });
    });

    await fireStoreInstance
        .collection("Users")
        .orderBy("user_email")
        .startAt([searchKeyword]).endAt([searchKeyword + "\uf8ff"])
    // .where("username",isGreaterThanOrEqualTo: searchKeyword)
    // .where("username",isLessThanOrEqualTo: searchKeyword)
        .get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if(listOfData.where((element) => element["user_id"]==result.data()["user_id"]).toList().isEmpty)
        {
          listOfData.add(result.data());
        }

      });
    });




    final blogList = listOfData;
    // if(blogList)
    // {
    //
    // }else{
    //   defaultFailedResponse["message"] = fetchStaffList.error!.toJson()["message"];
    //   responseToSend = defaultFailedResponse;
    //   print("WHAT IS STAFF ${responseToSend}");
    //   return responseToSend;
    // }

    responseToSend = {
      "status" : true,
      "data" : blogList,
      "message" : "User List Fetched Successfully",
    };

    return responseToSend;
  }

  Future<Map<String,dynamic>?> subscribeToPushNotification({required String userId,required String notificationToken})
  async {
    Map<String,dynamic>? responseToSend;
    try {
      Map<String,dynamic> userToInsert = {
        "token" : notificationToken,
      };
      DocumentSnapshot insertData = await FireStoreService.instance.insertDataWithDocId(collectionName: "NotificationToken",json: userToInsert,docId: userId);
      if(insertData.exists)
      {
        responseToSend = {
          "status" : true,
          "data" : insertData.data(),
          "message" : "Token Added Successfully",
        };
      }else{
        defaultFailedResponse["message"] = "Something Went Wrong While Adding To Firestore";
        responseToSend = defaultFailedResponse;
        return responseToSend;
      }

    } on FirebaseException catch (e) {
      defaultFailedResponse["message"] = e.message;
      responseToSend = defaultFailedResponse;
      return responseToSend;
    }

    return responseToSend;
  }

  Future<Map<String,dynamic>?> unsubscribeToPushNotification({required String userId})
  async {
    Map<String,dynamic>? responseToSend;
    try {
      await FireStoreService.instance.deleteDateWithDocId(collectionName: "NotificationToken",docId: userId);
      responseToSend = {
        "status": true,
        "data": [],
        "message": "Token Deleted Successfully"
      };


    } on FirebaseException catch (e) {
      defaultFailedResponse["message"] = e.message;
      responseToSend = defaultFailedResponse;
      return responseToSend;
    }

    return responseToSend;
  }

  Future<Map<String,dynamic>?> fetchAllCategories()
  async {
    final Map<String,dynamic>? responseToSend;

    final blogList = await fetchAllDocument(collectionName: "Categories");
    // if(blogList)
    // {
    //
    // }else{
    //   defaultFailedResponse["message"] = fetchStaffList.error!.toJson()["message"];
    //   responseToSend = defaultFailedResponse;
    //   print("WHAT IS STAFF ${responseToSend}");
    //   return responseToSend;
    // }

    responseToSend = {
      "status" : true,
      "data" : blogList,
      "message" : "Categories Fetched Successfully",
    };

    return responseToSend;
  }

  //*************************** Category Section ********************
  Future<Map<String,dynamic>?> fetchAllUserAndSendNotification()
  async {
    final Map<String,dynamic>? responseToSend;

    final userList = await fetchAllDocument(collectionName: "NotificationToken");
    // if(blogList)
    // {
    //
    // }else{
    //   defaultFailedResponse["message"] = fetchStaffList.error!.toJson()["message"];
    //   responseToSend = defaultFailedResponse;
    //   print("WHAT IS STAFF ${responseToSend}");
    //   return responseToSend;
    // }

    responseToSend = {
      "status" : true,
      "data" : userList,
      "message" : "Users Fetched Successfully",
    };

    return responseToSend;
  }


  // *********************** BLOGS SECTION ********************************
  Future<Map<String,dynamic>?> fetchAllBlogs()
  async {
    final Map<String,dynamic>? responseToSend;

    final blogList = await fetchAllDocument(collectionName: "Blogs",orderByFeild: "blog_added_on",desc: true);
    // if(blogList)
    // {
    //
    // }else{
    //   defaultFailedResponse["message"] = fetchStaffList.error!.toJson()["message"];
    //   responseToSend = defaultFailedResponse;
    //   print("WHAT IS STAFF ${responseToSend}");
    //   return responseToSend;
    // }

    responseToSend = {
      "status" : true,
      "data" : blogList,
      "message" : "Blogs Fetched Successfully",
    };

    return responseToSend;
  }

  Future<Map<String,dynamic>?> fetchUserWiseBlogs({required String userId})
  async {
    final Map<String,dynamic>? responseToSend;
    List<Map<String,dynamic>> listOfData = [];
    await fireStoreInstance
        .collection("Blogs").orderBy("blog_added_on",descending: true).where("blog_owner_id",isEqualTo: userId).get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        listOfData.add(result.data());
      });
    });

    
    final blogList = listOfData;
    // if(blogList)
    // {
    //
    // }else{
    //   defaultFailedResponse["message"] = fetchStaffList.error!.toJson()["message"];
    //   responseToSend = defaultFailedResponse;
    //   print("WHAT IS STAFF ${responseToSend}");
    //   return responseToSend;
    // }

    responseToSend = {
      "status" : true,
      "data" : blogList,
      "message" : "User Wise Blogs Fetched Successfully",
    };

    return responseToSend;
  }

  Future<Map<String,dynamic>?> addBlogs({required Map<String,dynamic> params,required File fileToUpload})
  async {
    Map<String,dynamic>? responseToSend;

    String randomImageName = MiscFunctions().getRandomString(15)+".jpg";

    String? imageUrl = await FirebaseStorageService.instance.uploadFileToServer(fileToUpload, randomImageName);
    if(imageUrl!=null)
    {
      final Map<String,dynamic> dataToInsertBlog = {};
      dataToInsertBlog["blog_id"] = params["blogId"];
      dataToInsertBlog["blog_owner_id"] = params["blogOwnerId"];
      dataToInsertBlog["blog_owner_name"] = params["blogOwnerName"];
      dataToInsertBlog["blog_category"] = params["blogCategory"];
      dataToInsertBlog["blog_title"] = params["blogTitle"];
      dataToInsertBlog["blog_desc"] = params["blogDesc"];
      dataToInsertBlog["blog_img_url"] = imageUrl;
      dataToInsertBlog["blog_img_name"] = randomImageName;
      dataToInsertBlog["blog_added_on"] = params["blogAddedOn"];

      print("WHAT IS DATA TO INSERT Staff ${dataToInsertBlog}");

      DocumentSnapshot insertData = await FireStoreService.instance.insertData(collectionName: "Blogs",json: dataToInsertBlog);
      if(insertData.exists)
      {
        responseToSend = {
          "status" : true,
          "data" : insertData.data(),
          "message" : "Blog Successfully",
        };
      }else{
        defaultFailedResponse["message"] = "Something Went Wrong While Adding To Firestore";
        responseToSend = defaultFailedResponse;
        return responseToSend;
      }

    }else{
      defaultFailedResponse["message"] = "Image Upload Failed";
      responseToSend = defaultFailedResponse;
      return responseToSend;
    }

    return responseToSend;
  }

  Future<Map<String,dynamic>?> updateBlogs({required Map<String,dynamic> params,File? fileToUpload,required String blogId})
  async {
    Map<String,dynamic>? responseToSend;


    final Map<String,dynamic> dataToInsertBlog = {};
    if(fileToUpload!=null)
    {
      String randomImageName = MiscFunctions().getRandomString(15)+".jpg";
      String? imageUrl = await FirebaseStorageService.instance.uploadFileToServer(fileToUpload, randomImageName);
      if(imageUrl!=null)
      {
        dataToInsertBlog["blog_category"] = params["blogCategory"];
        dataToInsertBlog["blog_title"] = params["blogTitle"];
        dataToInsertBlog["blog_desc"] = params["blogDesc"];
        dataToInsertBlog["blog_img_url"] = imageUrl;
        dataToInsertBlog["blog_img_name"] = randomImageName;
        print("WHAT IS DATA TO Update BLOG ${dataToInsertBlog}");



      }else{
        defaultFailedResponse["message"] = "Image Upload Failed";
        responseToSend = defaultFailedResponse;
        return responseToSend;
      }
    }else{

      dataToInsertBlog["blog_category"] = params["blogCategory"];
      dataToInsertBlog["blog_title"] = params["blogTitle"];
      dataToInsertBlog["blog_desc"] = params["blogDesc"];

      print("WHAT IS DATA TO Update BLOG ${dataToInsertBlog}");

    }


    DocumentSnapshot? updateData = await FireStoreService.instance.updateData(collectionName: "Blogs",json: dataToInsertBlog,feildName: "blog_id",value: blogId);
    if(updateData!=null)
    {
      responseToSend = {
        "status" : true,
        "data" : updateData.data(),
        "message" : "Blog Updated Successfully",
      };
    }else{
      defaultFailedResponse["message"] = "Something Went Wrong While Update Blog";
      responseToSend = defaultFailedResponse;
      return responseToSend;
    }

    return responseToSend;
  }


  Future<Map<String,dynamic>?> deleteBlog({required String blogId})
  async {
    Map<String,dynamic>? responseToSend;


      await deleteData(collectionName: "Blogs",feildName: "blog_id",value: blogId);

      responseToSend = {
        "status" : true,
        "data" : [],
        "message" : "Blogs Deleted Successfully",
      };



    return responseToSend;
  }

}