import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:the_blog_app/animation/fade_animation.dart';
import 'package:the_blog_app/screens/Blogs/blog_list_tile_widget.dart';
import 'package:the_blog_app/utils/model_object_helper.dart';
import 'package:the_blog_app/utils/size_config.dart';

class BlogListWidget extends StatefulWidget {
  const BlogListWidget({Key? key, this.fetchAllBlogs = true, this.userId, required this.title}) : super(key: key);

  final bool fetchAllBlogs;
  final String? userId;
  final String title;

  @override
  _BlogListWidgetState createState() => _BlogListWidgetState();
}

class _BlogListWidgetState extends State<BlogListWidget> with ModelObjectHelper {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  bool filterApplied = false;
  String filterValue = "";

  Future<void> fetchAllBlogList()
  async {
    if(widget.fetchAllBlogs)
    {
      await blogsModel.fetchAllBlog(context: context);
    }else{
      await blogsModel.fetchUserWiseBlog(context: context,userId: widget.userId!);
    }
  }

  void showFilterModal(){

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12))
      ),
      builder: (context) {
        return StatefulBuilder(
        builder: (context, setState) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(true);
            },
            child: AnimatedPadding(
              padding: EdgeInsets.only(bottom: SizeConfig.mediaQueryData.viewInsets.bottom,top : SizeConfig.mediaQueryData.viewInsets.bottom == 0 ? 0 : 10),
              duration: const Duration(milliseconds: 300),
              curve: Curves.decelerate,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: appModel.whiteColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: appModel.primaryColor.withOpacity(0.1), //color of shadow
                      spreadRadius: 10, //spread radius
                      blurRadius: 15, // blur radius
                      offset: Offset(0, 2), // changes position of shadow
                      //first paramerter of offset is left-right
                      //second parameter is top to down
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(8),
                      width: SizeConfig.screenWidth * 0.2,
                      height: 5,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(10),),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Apply Filter",style: SizeConfig.themeData.textTheme.headline5!.copyWith(color: Colors.black,fontWeight: FontWeight.bold),),
                          ClipOval(
                            child: Container(
                              height: 25,
                              width: 25,
                              padding: const EdgeInsets.all(2),
                              child: Center(child: Icon(Icons.close,color: appModel.whiteColor,size: 20,)),
                              color: appModel.primaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(10),),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(12),vertical: getProportionateScreenHeight(8)),
                      child: Column(
                        children: [
                          ...List.generate(categoryModel.categoryList.length, (index){
                            return CheckboxListTile(value: categoryModel.categoryList[index].catName == filterValue ? true : false, onChanged: (value) {
                              setState((){
                                if(value!=null && value)
                                {
                                  filterApplied = true;
                                  filterValue = categoryModel.categoryList[index].catName;
                                }
                              });
                            },title: Text("${categoryModel.categoryList[index].catName}"),);
                          })
                        ],
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(10),),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                setState((){
                                  filterApplied = false;
                                  filterValue = "";
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(8),vertical: getProportionateScreenHeight(16)),
                                child: Center(
                                  child: Text("Reset Filter",style: SizeConfig.themeData.textTheme.headline6!.copyWith(color: appModel.primaryColor),),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: (){
                                widget.fetchAllBlogs ? blogsModel.blogListUpdateInformer.add({}) : blogsModel.userWiseBlogListUpdateInformer.add({});
                                Get.back();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(8),vertical: getProportionateScreenHeight(16)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                    color: appModel.primaryColor
                                ),
                                child: Center(
                                  child: Text("Apply",style: SizeConfig.themeData.textTheme.headline6!.copyWith(color: appModel.whiteColor),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
        },
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    initModel(context);
    WidgetsBinding.instance!.addPostFrameCallback((_){
      fetchAllBlogList();
    });
    super.initState();
  }

  void _onRefresh() async{
    // monitor network fetch
    await fetchAllBlogList();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        FadeAnimation(
          delay: 0.50,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(16),vertical: getProportionateScreenHeight(18)),
            child: StreamBuilder(
              stream: widget.fetchAllBlogs ? blogsModel.blogListUpdateInformer.stream : blogsModel.userWiseBlogListUpdateInformer.stream,
              builder: (context, snapshot) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${widget.title}",style: SizeConfig.themeData.textTheme.bodyText1!.copyWith(fontSize: getProportionateScreenWidth(20),fontWeight: FontWeight.w600),),
                    InkWell(
                      onTap: (){
                        showFilterModal();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Stack(
                          children: [
                            Icon(LineIcons.filter),
                            filterApplied ? Positioned(
                              right: 0,
                              top: 0,
                              child: ClipOval(
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  color: Colors.red,
                                ),
                              ),
                            ) : Container(),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder(
              stream: widget.fetchAllBlogs ? blogsModel.blogListUpdateInformer.stream : blogsModel.userWiseBlogListUpdateInformer.stream,
              builder: (context, snapshot) {
                return SmartRefresher(
                  controller: _refreshController,
                  header: WaterDropHeader(),
                  onRefresh: _onRefresh,
                  child: snapshot.data == null ? const Center(child: Text("Loading..."),) : (widget.fetchAllBlogs ? blogsModel.blogList.isNotEmpty : blogsModel.userWiseBlogList.isNotEmpty) ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.fetchAllBlogs ? blogsModel.getBlogList(filterValue: filterValue,isFilterApplied: filterApplied).length : blogsModel.getUserWiseBlogList(filterValue: filterValue,isFilterApplied: filterApplied).length,
                    itemBuilder: (context, index) {
                      return BlogListTile(blog: widget.fetchAllBlogs ? blogsModel.getBlogList(filterValue: filterValue,isFilterApplied: filterApplied)[index] : blogsModel.getUserWiseBlogList(filterValue: filterValue,isFilterApplied: filterApplied)[index],);
                    },
                  ) : const Center(child: Text("No Blogs To Show"),),
                );
              }
          ),
        ),
      ],
    );
  }
}
