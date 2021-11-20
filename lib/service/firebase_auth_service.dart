import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_blog_app/service/firestore_service.dart';


class FirebaseAuthService{

  
  FirebaseAuthService._();

  static final instance = FirebaseAuthService._();

  Map<String, dynamic> defaultFailedResponse = {
    "status": false,
    "message": "",
    "data": []
  };
  final FirebaseAuth authInstance = FirebaseAuth.instance;

  Future<Map<String,dynamic>?> loginWithEmail({required String email,required String password})
  async {
    Map<String,dynamic>? responseToSend;


    try {
      final User? user = (await authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).user;

      if(user!=null)
      {
        Map<String,dynamic> userData = {};
        userData["email"] = user.email;
        userData["uid"] = user.uid;

        DocumentSnapshot insertData = await FireStoreService.instance.fetchDocumentWithDocId(collectionName: "Users",docId: user.uid);
        if(insertData.exists)
        {
          responseToSend = {
            "status" : true,
            "data" : insertData.data(),
            "message" : "Login Successfully",
          };
        }else{
          defaultFailedResponse["message"] = "User Not Exists";
          responseToSend = defaultFailedResponse;
          return responseToSend;
        }




      }else{
        defaultFailedResponse["message"] = "User Not Exists";
        responseToSend = defaultFailedResponse;
        return responseToSend;
      }

    } on FirebaseAuthException catch (e) {
      defaultFailedResponse["message"] = "User Not Exists";
      responseToSend = defaultFailedResponse;
      return responseToSend;
    }

    return responseToSend;
  }

  Future<Map<String,dynamic>?> loginWithGoogle()
  async {
    Map<String,dynamic>? responseToSend;


    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await authInstance.signInWithCredential(credential);
      User? user = authInstance.currentUser;
      if(user!=null)
      {
        Map<String,dynamic> userData = {};
        userData["email"] = user.email;
        userData["uid"] = user.uid;

        DocumentSnapshot insertData = await FireStoreService.instance.fetchDocumentWithDocId(collectionName: "Users",docId: user.uid);
        if(insertData.exists)
        {
          responseToSend = {
            "status" : true,
            "data" : insertData.data(),
            "message" : "Login Successfully",
          };
        }else{

          Map<String,dynamic> userToInsert = {
            "user_id" : user.uid,
            "username" : user.displayName,
            "user_email" : user.email,
          };
          DocumentSnapshot insertData = await FireStoreService.instance.insertDataWithDocId(collectionName: "Users",json: userToInsert,docId: user.uid);
          if(insertData.exists)
          {
            responseToSend = {
              "status" : true,
              "data" : insertData.data(),
              "message" : "User Registered Successfully",
            };
          }else{
            defaultFailedResponse["message"] = "Something Went Wrong While Adding To Firestore";
            responseToSend = defaultFailedResponse;
            return responseToSend;
          }





        }
      }else{
        defaultFailedResponse["message"] = "User Not Exists";
        responseToSend = defaultFailedResponse;
        return responseToSend;
      }

    } catch(e){
      defaultFailedResponse["message"] = e.toString();
      responseToSend = defaultFailedResponse;
      return responseToSend;
    }



    return responseToSend;
  }

  Future<Map<String,dynamic>?> register({required String username,required String email,required String password})
  async {
    Map<String,dynamic>? responseToSend;
    try {
      final User? user = (await authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )).user;

      if(user!=null)
      {
        Map<String,dynamic> userToInsert = {
          "user_id" : user.uid,
          "username" : username,
          "user_email" : user.email,
        };
        DocumentSnapshot insertData = await FireStoreService.instance.insertDataWithDocId(collectionName: "Users",json: userToInsert,docId: user.uid);
        if(insertData.exists)
        {
          responseToSend = {
            "status" : true,
            "data" : insertData.data(),
            "message" : "User Registered Successfully",
          };
        }else{
          defaultFailedResponse["message"] = "Something Went Wrong While Adding To Firestore";
          responseToSend = defaultFailedResponse;
          return responseToSend;
        }



      }else{
        defaultFailedResponse["message"] = "Something Went Wrong In Registering User";
        responseToSend = defaultFailedResponse;
        return responseToSend;
      }

    } on FirebaseAuthException catch (e) {
      defaultFailedResponse["message"] = e.message;
      responseToSend = defaultFailedResponse;
      return responseToSend;
    }

    return responseToSend;
  }

  Future<Map<String,dynamic>?> fetchUserDetail({required String userId})
  async {
    Map<String,dynamic>? responseToSend;


    try {
      DocumentSnapshot fetchUser = await FireStoreService.instance.fetchDocumentWithDocId(collectionName: "Users",docId: userId);
      if(fetchUser.exists)
      {
        responseToSend = {
          "status" : true,
          "data" : fetchUser.data(),
          "message" : "User Details Fetched Successfully",
        };
      }else{
        defaultFailedResponse["message"] = "User Not Found";
        responseToSend = defaultFailedResponse;
        return responseToSend;
      }

    } on FirebaseAuthException catch (e) {
      defaultFailedResponse["message"] = "User Not Found";
      responseToSend = defaultFailedResponse;
      return responseToSend;
    }

    return responseToSend;
  }





}