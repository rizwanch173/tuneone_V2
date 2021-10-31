import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuneone/controllers/login_controller.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/styled_widgets/styled_button.dart';
import 'package:tuneone/ui/styled_widgets/styled_textfield.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.png"), fit: BoxFit.fill),
          ),
          child: GetBuilder<LoginController>(
            builder: (_) {
              return Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xffEF1930).withOpacity(0.7)],
                        end: Alignment.bottomCenter,
                        stops: [1],
                        begin: Alignment.topCenter)),
                child: Form(
                  key: _.formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                    child: Column(
                      children: [
                        SizedBox(
                          height: Get.height * 0.08,
                        ),
                        AutoSizeText(
                          "Login",
                          style: TextStyle(
                              fontSize: FontSizes.s20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        StyledTextField(
                          errorColor: Colors.black,
                          hintText: "username",
                          controller: _username,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "username is required";
                            }
                            // if (!GetUtils.isEmail(val)) {
                            //   return "Enter a valid email";
                            // }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        StyledTextField(
                          errorColor: Colors.black,
                          hintText: "Password",
                          controller: _password,
                          obscureText: true,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Password is required";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        _.errorMsg.value != "Error"
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: AutoSizeText(
                                  _.errorMsg.value.toString(),
                                  style: TextStyle(
                                      fontSize: FontSizes.s15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                                onTap: () {
                                  Get.toNamed("/forgetpassword");
                                },
                                child: AutoSizeText(
                                  "Forget Password?",
                                  style: TextStyle(
                                      fontSize: FontSizes.s20,
                                      color: Colors.white),
                                ))),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        _.isLoading.isTrue
                            ? Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/loader.gif",
                                  height: 40,
                                ),
                              )
                            : StyledButton(
                                onPressed: () {
                                  if (_.formKey.currentState!.validate()) {
                                    _
                                        .userLoginController(
                                            _username.text, _password.text)
                                        .then((value) {
                                      if (value!) {
                                        Get.offAndToNamed("/tabs");
                                        _.saveUserLogin(
                                            email: _username.text,
                                            pass: _password.text);
                                      }
                                    });
                                    //Get.toNamed("/tabs");
                                  }
                                },
                                title: "Login",
                                backgroundColor: Colors.white,
                                titleColor: backGroundColor,
                                borderRadius: BorderRadius.circular(5),
                                fontSize: 16,
                              ),
                        // Spacer(),
                        // AutoSizeText(
                        //   "OR",
                        //   style: TextStyle(
                        //       fontSize: FontSizes.s20, color: Colors.white),
                        // ),
                        // Spacer(),
                        // StyledButton(
                        //   icon: 'assets/facebook.png',
                        //   title: "Facebook",
                        //   backgroundColor: Colors.white,
                        //   titleColor: Color(0xff003281),
                        //   borderRadius: BorderRadius.circular(5),
                        //   fontSize: 16,
                        // ),
                        // SizedBox(
                        //   height: Get.height * 0.02,
                        // ),
                        // StyledButton(
                        //   icon: 'assets/google.png',
                        //   title: "Google",
                        //   backgroundColor: Colors.white,
                        //   titleColor: Color(0xffEF1930),
                        //   borderRadius: BorderRadius.circular(5),
                        //   fontSize: 16,
                        // ),
                        SizedBox(
                          height: Get.height * 0.05,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
