import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:the_blog_app/animation/fade_animation.dart';
import 'package:the_blog_app/screens/LoginRegister/register_screen.dart';
import 'package:the_blog_app/utils/clippers.dart';
import 'package:the_blog_app/utils/misc_functions.dart';
import 'package:the_blog_app/utils/model_object_helper.dart';
import 'package:the_blog_app/utils/size_config.dart';

class LoginScreen extends StatefulWidget   {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ModelObjectHelper {

  final TextEditingController emailTextEditingController = TextEditingController();
  final TextEditingController passwordTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    initModel(context,loadAll: true);
    super.initState();
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.preciseScreenHeight,
                width: SizeConfig.screenWidth,
                child: Stack(
                  children: [
                    //Bottom Section
                    Positioned(
                      top: 0,
                      height: SizeConfig.preciseScreenHeight,
                      width: SizeConfig.screenWidth,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                              color: appModel.primaryColor,
                              child: Column(
                                children: [
                                  SizedBox(height: constraints.maxHeight * 0.1,),
                                  FadeAnimation(delay: 0.75,child: AutoSizeText("LOGIN ",style: SizeConfig.themeData.textTheme.headline4!.copyWith(color: appModel.whiteColor),maxLines: 1,)),
                                  const Spacer(),
                                  FadeAnimation(
                                    delay: 1.25,
                                    child: Form(
                                      key: _formKey,

                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20),vertical: getProportionateScreenHeight(10)),
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: emailTextEditingController,
                                              style: TextStyle(color: appModel.whiteColor),
                                              keyboardType: TextInputType.emailAddress,
                                              validator: (value) {
                                                if(value!.isEmpty)
                                                {
                                                  return "Email Required";
                                                }else if(!MiscFunctions().isEmailValid(value))
                                                {
                                                  return "Please Enter Valid Email Address";
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                  hintText: "Email",
                                                  hintStyle: TextStyle(color: appModel.whiteColor),
                                                  errorStyle: TextStyle(color: Colors.red)
                                              ),
                                            ),
                                            SizedBox(height: getProportionateScreenHeight(20),),
                                            TextFormField(
                                              controller: passwordTextEditingController,
                                              obscureText: true,
                                              style: TextStyle(color: appModel.whiteColor),
                                              keyboardType: TextInputType.emailAddress,
                                              validator: (value) {
                                                if(value!.isEmpty)
                                                {
                                                  return "Password Required";
                                                }else if(value.length<8)
                                                {
                                                  return "Password Must Be Greater Then  8 Characters";
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                  hintText: "Password",
                                                  hintStyle: TextStyle(color: appModel.whiteColor),
                                                  errorStyle: TextStyle(color: Colors.red)
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  FadeAnimation(
                                    delay: 1.5,
                                    child: Column(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            if(_formKey.currentState!.validate()){
                                              // userModel.sendOtp(context, mobileNumberTextEditingController.text);
                                              await userModel.loginWithEmail(context: context,email: emailTextEditingController.text,password: passwordTextEditingController.text);
                                            }
                                          },
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(18.0),
                                                    side: const BorderSide(color: Colors.white)
                                                )
                                            ),
                                          ),
                                          child: const Text("Login"),
                                        ),
                                        SizedBox(height: getProportionateScreenHeight(12),),
                                        FadeAnimation(delay: 0.75,child: AutoSizeText("OR",style: SizeConfig.themeData.textTheme.subtitle2!.copyWith(color: Colors.grey),maxLines: 1,)),
                                        SizedBox(height: getProportionateScreenHeight(12),),
                                        InkWell(
                                          onTap: () async {
                                            await userModel.loginWithGoogle(context: context);
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(LineIcons.googleLogo,color: appModel.whiteColor,),
                                              SizedBox(width: getProportionateScreenWidth(12),),
                                              AutoSizeText("Sign In With Google",style: SizeConfig.themeData.textTheme.subtitle1!.copyWith(color: appModel.whiteColor),maxLines: 1,)
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: getProportionateScreenHeight(20),),
                                        FadeAnimation(delay: 0.75,child: InkWell(onTap: (){
                                          Get.to(() => RegisterScreen());
                                        },child: AutoSizeText("New user? Create Account ",style: SizeConfig.themeData.textTheme.subtitle2!.copyWith(color: appModel.whiteColor),maxLines: 1,))),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              )
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
