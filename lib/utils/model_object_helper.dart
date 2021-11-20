import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:the_blog_app/models/app_model.dart';
import 'package:the_blog_app/models/blogs_model.dart';
import 'package:the_blog_app/models/category_model.dart';
import 'package:the_blog_app/models/user_model.dart';

class ModelObjectHelper{
  late final AppModel appModel;
  late final UserModel userModel;
  late final BlogsModel blogsModel;
  late final CategoryModel categoryModel;
  // late final ProductModel productModel;
  // late final InventoryModel inventoryModel;
  // late final TransactionModel transactionModel;
  // late final StaffModel staffModel;
  // late final PlantTransactionModel plantTransactionModel;


  void initModel(BuildContext context,{bool loadAll = true,bool loadAppModel = false,bool loadUserModel = false,bool loadBlogsModel = false,bool loadCategoryModel = false})
  {
    if(loadAll)
    {
      appModel = Provider.of<AppModel>(context,listen: false);
      userModel = Provider.of<UserModel>(context,listen: false);
      blogsModel = Provider.of<BlogsModel>(context,listen: false);
      categoryModel = Provider.of<CategoryModel>(context,listen: false);
    }else{
      if(loadAppModel)
      {
        appModel = Provider.of<AppModel>(context,listen: false);
      }
      if(loadUserModel)
      {
        userModel = Provider.of<UserModel>(context,listen: false);
      }
      if(loadBlogsModel)
      {
        blogsModel = Provider.of<BlogsModel>(context,listen: false);
      }
      if(loadCategoryModel)
      {
        categoryModel = Provider.of<CategoryModel>(context,listen: false);
      }
    }

    // productModel = Provider.of<ProductModel>(context,listen: false);
    // inventoryModel = Provider.of<InventoryModel>(context,listen: false);
    // transactionModel = Provider.of<TransactionModel>(context,listen: false);
    // staffModel = Provider.of<StaffModel>(context,listen: false);
    // plantTransactionModel = Provider.of<PlantTransactionModel>(context,listen: false);
  }

}