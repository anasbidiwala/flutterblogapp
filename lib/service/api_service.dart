import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:the_blog_app/models/app_model.dart';

enum ToastType { success, error }

class ApiService {
  Map<String, dynamic> defaultFailedResponse = {
    "status": false,
    "message": "",
    "data": [],
  };

  late AppModel appModel;
  late OverlayEntry overlayEntry;

  ApiService._();

  static final instance = ApiService._();

  void init(BuildContext context) {
    appModel = Provider.of<AppModel>(context, listen: false);
    overlayEntry = OverlayEntry(
      builder: (context) {
        return SpinKitFadingCube(
          color: appModel.primaryColor,
          size: 50.0,
        );
      },
    );
  }

  Future<Map<String, dynamic>?> apiWrapper({
    required Future<Map<String, dynamic>?> Function() apiFunction,
    Map<String, dynamic> params = const {},
    BuildContext? context,
    bool showLoader = true,
    bool showToast = true,
    bool getFullResponse = false,
  }) async {
    late Map<String, dynamic>? responseToSend;
    try {
      if (showLoader) {
        Overlay.of(Get.overlayContext!)!.insert(overlayEntry);
      }
      final Map<String, dynamic>? response = await apiFunction();

      if (showToast) {
        final String message = response!["message"].toString();
        showToastMessage(message: message,toastType: (response["status"] as bool) ? ToastType.success : ToastType.error);
      }
      if (showLoader) {
        overlayEntry.remove();
      }
      responseToSend = getFullResponse
          ? response
          : (response!["status"] as bool)
              ? {"data" : (response)["data"]}
              : null;
    } on FormatException catch (e) {
      defaultFailedResponse["message"] = "Incorrect Response";
      print(defaultFailedResponse["message"]);
      responseToSend = getFullResponse ? defaultFailedResponse : null;
      onException(defaultFailedResponse["message"].toString(), showToast, showLoader);
    } catch (err,trace) {
      defaultFailedResponse["message"] = err.toString();
      print(defaultFailedResponse["message"]);
      responseToSend = getFullResponse ? defaultFailedResponse : null;
      print("ERROR in APi Provider ${err}");
      print("#TRACE ${trace}");
      onException(err.toString(), showToast, showLoader);
    }

    return responseToSend;
  }

  void onException(String message, bool showToast, bool showLoader) {
    // if(showToast)
    // {
    //
    // }
    showToastMessage(message: message, toastType: ToastType.error);
    if (showLoader) {
      Get.back();
    }
  }

  void showToastMessage({
    required String message,
    ToastType toastType = ToastType.success,
  }) {
    showSimpleNotification(Text(message),
        background: toastType == ToastType.success ? Colors.green : Colors.red,duration: toastType == ToastType.success ? Duration(milliseconds: 500) : Duration(seconds:1));
  }

  OverlayEntry showLoader(BuildContext context) {
    return overlayEntry;
  }
}
