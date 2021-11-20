import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:the_blog_app/service/api_service.dart';
import 'package:the_blog_app/service/firestore_service.dart';

class CategoryModel with ChangeNotifier{


  List<Category> categoryList = [];

  void addCategoryToList(Map<String,dynamic> singleCategoryJson){
    categoryList.add(Category.fromJson(singleCategoryJson));
  }

  Future<void> fetchAllCategory({required BuildContext context,bool isToAppend = false}) async {
    try {

      final getCategoryList = await ApiService.instance.apiWrapper(apiFunction: (){
        return FireStoreService.instance.fetchAllCategories();
      },context: context,showLoader: false,showToast: false);
      if(getCategoryList!=null)
      {

        // if(!isToAppend)
        // {
        //   blogList.clear();
        // }
        categoryList.clear();
        (getCategoryList["data"] as List<dynamic>).forEach((element) {
          addCategoryToList(element);
        });
        notifyListeners();

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

}


Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    required this.catName,
    required this.catId,
  });

  String catName;
  String catId;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    catName: json["cat_name"],
    catId: json["cat_id"],
  );

  Map<String, dynamic> toJson() => {
    "cat_name": catName,
    "cat_id": catId,
  };
}
