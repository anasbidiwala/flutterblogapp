import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:the_blog_app/models/blogs_model.dart';
import 'package:the_blog_app/screens/Blogs/add_blog_screen.dart';
import 'package:the_blog_app/screens/Blogs/blog_read_screen.dart';
import 'package:the_blog_app/utils/constants.dart';
import 'package:the_blog_app/utils/model_object_helper.dart';
import 'package:the_blog_app/utils/size_config.dart';

class BlogListTile extends StatefulWidget {
  const BlogListTile({Key? key, required this.blog}) : super(key: key);

  final SingleBlog blog;

  @override
  _BlogListTileState createState() => _BlogListTileState();
}

class _BlogListTileState extends State<BlogListTile> with ModelObjectHelper {

  @override
  void initState() {
    // TODO: implement initState
    initModel(context,loadAll: true);
    super.initState();
  }

  void showConfirmationDialog()
  {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed:  () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed:  () async {
        await blogsModel.deleteBlog(context: context, blogId: widget.blog.blogId);
        Get.back();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are You Sure?"),
      content: Text("You Want To Delete This Blog?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                Get.to(() => BlogReadScreen(singleBlog: widget.blog,));
              },
              child: Container(
                height: getProportionateScreenHeight(175),
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: "${widget.blog.blogImgUrl}",
                  fit: BoxFit.cover,

                  placeholder: (context, url) => SkeletonLoader(builder: Container(
                    height: getProportionateScreenHeight(175),
                    width: double.infinity,
                    color: Colors.black,
                  ),),
                  errorWidget: (context, url, error){
                    print("WHAT IS ERROR ${url} ${error.toString()}");
                    return Icon(Icons.error);
                  },
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12))
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Get.to(() => BlogReadScreen(singleBlog: widget.blog,));
                      },
                      child: Text("${widget.blog.blogTitle}",style: SizeConfig.themeData.textTheme.headline5,),),
                  ),
                  widget.blog.blogOwnerId == userModel.userDetails!.userId ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        InkWell(onTap: (){
                          Get.to(() => AddBlogScreen(addBlogScreenMode: AddBlogScreenMode.EDIT,singleBlog: widget.blog,));
                        },child: Icon(LineIcons.edit)),
                        SizedBox(width: 8,),
                        InkWell(onTap: (){
                          showConfirmationDialog();
                        },child: Icon(LineIcons.trash))
                      ],
                    ),
                  ):Container()
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  AutoSizeText.rich(TextSpan(
                      text: "Author : ",
                      style: SizeConfig.themeData.textTheme.subtitle1!.copyWith(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "${widget.blog.blogOwnerName}",
                          style: SizeConfig.themeData.textTheme.subtitle1!.copyWith(color: appModel.primaryColor),
                        )
                      ]
                  ),maxLines: 1,),
                  AutoSizeText.rich(TextSpan(
                      text: "Category : ",
                      style: SizeConfig.themeData.textTheme.subtitle1!.copyWith(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "${widget.blog.blogCategory}",
                          style: SizeConfig.themeData.textTheme.subtitle1!.copyWith(color: appModel.primaryColor),
                        )
                      ]
                  ),maxLines: 1,),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 12),
              child: InkWell(
                onTap: (){
                  Get.to(() => BlogReadScreen(singleBlog: widget.blog,));
                },
                child: Text("${widget.blog.blogDesc}",style: SizeConfig.themeData.textTheme.subtitle2!.copyWith(color: Colors.grey),maxLines: 3,overflow: TextOverflow.ellipsis,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
