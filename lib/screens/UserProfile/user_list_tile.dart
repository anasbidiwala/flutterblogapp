import 'package:flutter/material.dart';
import 'package:the_blog_app/models/user_model.dart';
import 'package:the_blog_app/utils/model_object_helper.dart';
import 'package:the_blog_app/utils/size_config.dart';

class UserListTileWidget extends StatefulWidget {
  const UserListTileWidget({Key? key, required this.onClick, required this.userDetail}) : super(key: key);

  final UserDetails userDetail;
  final Function onClick;

  @override
  _UserListTileWidgetState createState() => _UserListTileWidgetState();
}

class _UserListTileWidgetState extends State<UserListTileWidget> with ModelObjectHelper {

  @override
  void initState() {
    // TODO: implement initState
    initModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return InkWell(
      onTap: (){
        widget.onClick();
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(8),vertical: getProportionateScreenHeight(8)),
        decoration: BoxDecoration(
          color: appModel.whiteColor,
          borderRadius: BorderRadius.circular(12),
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
        child: Row(
          children: [
            ClipOval(
              child: Container(color: appModel.primaryColor.withOpacity(0.1),padding: const EdgeInsets.all(6),height: 50,width: 50,child: Image.asset("assets/img/users.png"),),
            ),
            SizedBox(width: getProportionateScreenWidth(20),),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.userDetail.username,style: SizeConfig.themeData.textTheme.headline6,),
                  SizedBox(height: 8,),
                  Text(widget.userDetail.userEmail,style: SizeConfig.themeData.textTheme.subtitle1,),

                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_sharp)
          ],
        ),
      ),
    );
  }
}
