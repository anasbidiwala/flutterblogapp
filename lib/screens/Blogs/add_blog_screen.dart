import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:the_blog_app/models/blogs_model.dart';
import 'package:the_blog_app/models/category_model.dart';
import 'package:the_blog_app/service/api_service.dart';
import 'package:the_blog_app/utils/constants.dart';
import 'package:the_blog_app/utils/misc_functions.dart';
import 'package:the_blog_app/utils/model_object_helper.dart';
import 'package:the_blog_app/utils/size_config.dart';




class AddBlogScreen extends StatefulWidget {
  const AddBlogScreen({Key? key, this.addBlogScreenMode = AddBlogScreenMode.ADD, this.singleBlog}) : super(key: key);

  final AddBlogScreenMode addBlogScreenMode;
  final SingleBlog? singleBlog;

  @override
  _AddBlogScreenState createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> with ModelObjectHelper {

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController blogTitle = TextEditingController();
  final TextEditingController blogDescription = TextEditingController();
  Category selectedCategory = Category(catId: "-1", catName: "Select Category");
  final ImagePicker _picker = ImagePicker();
  XFile? image;



  @override
  void initState() {
    // TODO: implement initState
    initModel(context);
    if(widget.addBlogScreenMode==AddBlogScreenMode.EDIT)
    {
      blogTitle.text = widget.singleBlog!.blogTitle;
      blogDescription.text = widget.singleBlog!.blogDesc;
      selectedCategory = categoryModel.categoryList.firstWhere((element) => element.catName == widget.singleBlog!.blogCategory);
    }
    super.initState();
  }


  String getCategoryName(Category? data) {
    return data!=null ? data.catName : "Select Category";
  }

  Future getGallery() async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = pickedImage;
    });
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
                    Text("Add Blog",style: SizeConfig.themeData.textTheme.bodyText1!.copyWith(fontSize: getProportionateScreenWidth(20),fontWeight: FontWeight.w600),)


                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("Blog Title"),
                          ),
                          SizedBox(height: getProportionateScreenHeight(6),),
                          TextFormField(
                            controller: blogTitle,
                            style: TextStyle(color: appModel.primaryColor),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if(value!.isEmpty) {
                                return "Blog Title Required";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Blog Title",
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
                          SizedBox(height: getProportionateScreenHeight(16),),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("Select Category"),
                          ),
                          SizedBox(height: getProportionateScreenHeight(6),),
                          Container(
                            height: 50,
                            child: Consumer<CategoryModel>(
                              builder: (context, model, child) {
                                return DropdownSearch<Category>(
                                  dropdownBuilder: (context, selectedItem) {
                                    return Text(getCategoryName(selectedItem),
                                        style: Theme.of(context).textTheme.subtitle1!.copyWith(color: appModel.primaryColor));
                                  },
                                  validator: (value) {
                                    if(value!.catId == "-1")
                                    {
                                      return "Please Select Category";
                                    }
                                    return null;
                                  },
                                  mode: Mode.BOTTOM_SHEET,
                                  maxHeight: SizeConfig.preciseScreenHeight * 0.4,
                                  items: model.categoryList,
                                  itemAsString: getCategoryName,

                                  label: "Select Category",
                                  clearButton: Icon(Icons.clear, size: 24,color: appModel.primaryColor,),
                                  dropDownButton: Icon(Icons.arrow_drop_down, size: 24,color: appModel.primaryColor,),
                                  dropdownSearchBaseStyle: GoogleFonts.roboto(color: Colors.white),
                                  dropdownSearchDecoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    labelStyle: TextStyle(color: Colors.white),
                                    hintText: "Blog Title",
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
                                  onChanged: (value) {
                                    print("Selected Product ${value}");
                                    if(value!=null)
                                    {
                                      selectedCategory = value;

                                    }
                                  },
                                  selectedItem: selectedCategory,
                                  showSearchBox: true,
                                  searchFieldProps : TextFieldProps(style: GoogleFonts.roboto(color: Colors.white),decoration: InputDecoration(fillColor: appModel.primaryColor,hintStyle: GoogleFonts.roboto(color: Colors.white),hintText: "Search Product",)),
                                  popupTitle: Container(
                                    height: 45,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(0),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Select Category',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: appModel.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  popupShape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(16),),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("Blog Description"),
                          ),
                          SizedBox(height: getProportionateScreenHeight(6),),
                          TextFormField(
                            controller: blogDescription,
                            style: TextStyle(color: appModel.primaryColor),
                            keyboardType: TextInputType.multiline,
                            validator: (value) {
                              if(value!.isEmpty) {
                                return "Blog Description Required";
                              }
                              return null;
                            },
                            minLines: 5,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Blog Description",
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
                          SizedBox(height: getProportionateScreenHeight(16),),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("Select Header Image"),
                          ),
                          SizedBox(height: getProportionateScreenHeight(6),),
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: (){
                                getGallery();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: appModel.primaryColor,
                                onPrimary: appModel.whiteColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(image == null ? "Select Image" : "Change Image"),
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(6),),
                          Align(
                            alignment: Alignment.center,
                            child: widget.addBlogScreenMode == AddBlogScreenMode.ADD ? image == null ? Container(
                              child: Text("No Image Selected"),
                            ) : Container(
                              height: 120,
                              width: double.infinity,
                              child: Image.file(File(image!.path),fit: BoxFit.cover,),
                            ) : image != null ? Container(
                              height: 120,
                              width: double.infinity,
                              child: Image.file(File(image!.path),fit: BoxFit.cover,),
                            ) : Container(
                              height: 120,
                              width: double.infinity,
                              child: CachedNetworkImage(
                                imageUrl: "${widget.singleBlog!.blogImgUrl}",
                                fit: BoxFit.cover,

                                placeholder: (context, url) => SkeletonLoader(builder: Container(
                                  height: 120,
                                  width: double.infinity,
                                  color: Colors.black,
                                ),),
                                errorWidget: (context, url, error){
                                  print("WHAT IS ERROR ${url} ${error.toString()}");
                                  return Icon(Icons.error);
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if(_formKey.currentState!.validate())
                                {
                                  if(widget.addBlogScreenMode == AddBlogScreenMode.ADD)
                                  {
                                    if(image==null)
                                    {
                                      ApiService.instance.showToastMessage(message: "Please Select Image",toastType: ToastType.error);
                                    }else{

                                      print("ADD BLOG CODE");
                                      Map<String,dynamic> params = {};
                                      params["blogId"] = MiscFunctions().getRandomString(10);
                                      params["blogOwnerId"] = userModel.userDetails!.userId;
                                      params["blogOwnerName"] = userModel.userDetails!.username;
                                      params["blogCategory"] = selectedCategory.catName;
                                      params["blogTitle"] = blogTitle.text;
                                      params["blogDesc"] = blogDescription.text;
                                      params["blogAddedOn"] = DateFormat('dd-MM-yyyy hh:mm').format(DateTime.now());

                                      await blogsModel.addBlogToServer(context: context,fileToUpload: File(image!.path),params: params,backNavigationRequired: true);
                                      // _formKey.currentState!.reset();
                                      // blogTitle.text = "";
                                      // blogDescription.text = "";
                                      // image = null;
                                      // selectedCategory = Category(catId: "-1", catName: "Select Category");
                                      // setState(() {
                                      //
                                      // });
                                    }
                                  }else{
                                    Map<String,dynamic> params = {};
                                    params["blogTitle"] = blogTitle.text;
                                    params["blogDesc"] = blogDescription.text;
                                    params["blogCategory"] = selectedCategory.catName;
                                    await blogsModel.updateBlogToServer(context: context,fileToUpload: image!=null ? File(image!.path) : null,params: params,blogId: widget.singleBlog!.blogId,backNavigationRequired: true);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: appModel.primaryColor,
                                onPrimary: appModel.whiteColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(widget.addBlogScreenMode == AddBlogScreenMode.ADD ? "Add Blog" : "Update Blog"),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              )



            ],
          ),
        ),
      ),
    );
  }
}
