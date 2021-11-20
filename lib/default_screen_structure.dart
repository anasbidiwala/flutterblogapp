import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_blog_app/utils/model_object_helper.dart';
import 'package:the_blog_app/utils/size_config.dart';

class DefaultScreenStructure extends StatefulWidget {
  const DefaultScreenStructure({Key? key}) : super(key: key);

  @override
  _DefaultScreenStructureState createState() => _DefaultScreenStructureState();
}

class _DefaultScreenStructureState extends State<DefaultScreenStructure> with ModelObjectHelper {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    initModel(context);
    super.initState();
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
                    Text("Title",style: SizeConfig.themeData.textTheme.bodyText1!.copyWith(fontSize: getProportionateScreenWidth(20),fontWeight: FontWeight.w600),)


                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text("Content")
                    ],
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
