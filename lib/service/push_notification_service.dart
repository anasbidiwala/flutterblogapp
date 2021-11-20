import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:the_blog_app/screens/UserProfile/user_profile_screen.dart';

class PushNotificationService {
  late FirebaseMessaging messaging;

  PushNotificationService._();

  static final instance = PushNotificationService._();


  Future initialise() async {

    messaging = await FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );



    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      // TODO: handle the received notifications
    } else {
      print('User declined or has not accepted permission');
    }

    messaging.getToken().then((String? token) {
      assert(token != null);
      print("Push Messaging token: $token");
    });


    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      print(event.data);


      showSimpleNotification(
          InkWell(onTap: (){
            Get.to(() => UserProfileScreen(isMyProfile: false,userId: event.data["id"],));
          },child: Text("${event.notification!.title}")),
          autoDismiss: false,
          slideDismiss: true,
          subtitle: Text("${event.notification!.body}"),

          background: Colors.green);

      // Get.defaultDialog(
      //   title: "Notification ${event.notification!.title}",
      //   middleText: "Hello world! ${event.notification!.body}",
      // );

    });


    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
    FirebaseMessaging.onBackgroundMessage(messageHandler);

  }


  Future<void> messageHandler(RemoteMessage message) async {
    print('background message ${message.notification!.body}');
  }

  var postUrl = "https://fcm.googleapis.com/fcm/send";

  Future<void> sendNotification(List<String> tokens,String title,String message,String userId)async{

    var token = await messaging.getToken();
    print('token : $token');

    if(token!=null)
    {
      final data = {
        "notification": {"body": "${message}", "title": "${title}"},
        "priority": "high",
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": "${userId}",
          "status": "done"
        },
        "registration_ids": tokens
      };

      final headers = {
        'content-type': 'application/json',
        'Authorization': 'key=AAAAhZ7OZ7Q:APA91bEh5qzc3Z5a6g9YK-hIm5psqGYpeudV2PsDLTOBP1P1MoYwEcoTm6C-8ThlNDwNbObomj4WPd5fPy4Q91dDPSse5_OG2lxmndo-ogVFHc-hcWTfngCXSOB1vEloM_neIcCOtEyE'
      };


      BaseOptions options = new BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 3000,
        headers: headers,
      );


      try {
        final response = await Dio(options).post(postUrl,
            data: data);

        if (response.statusCode == 200) {
          print("NOTOIFICATION SENT");
        } else {
          print('notification sending failed');
          // on failure do sth
        }
      }
      catch(e){
        print('exception $e');
      }
    }




  }

}