import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuneone/controllers/signup_controller.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/styled_widgets/styled_button.dart';
import 'package:tuneone/ui/styled_widgets/styled_textfield.dart';

class SignUpView extends StatelessWidget {
  final SignUpController signUpController = Get.find();
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
          child: Obx(
            () => Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xffEF1930).withOpacity(0.7)],
                      end: Alignment.bottomCenter,
                      stops: [1],
                      begin: Alignment.topCenter)),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: signUpController.formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                  child: Column(
                    children: [
                      SizedBox(
                        height: Get.height * 0.08,
                      ),
                      AutoSizeText(
                        signUpController.create.value,
                        style: TextStyle(
                            fontSize: FontSizes.s20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      StyledTextField(
                        controller: signUpController.firstName,
                        errorColor: Colors.black,
                        hintText: "First Name",
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "First Name is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      StyledTextField(
                        controller: signUpController.lastname,
                        errorColor: Colors.black,
                        hintText: "Last Name",
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Last Name is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      StyledTextField(
                        controller: signUpController.userName,
                        errorColor: Colors.black,
                        hintText: "Username",
                        validator: (val) {
                          if (val!.isEmpty) {
                            return " Username is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      StyledTextField(
                        controller: signUpController.email,
                        errorColor: Colors.black,
                        hintText: "E-mail",
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Email is required";
                          }
                          if (!GetUtils.isEmail(val)) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      StyledTextField(
                        controller: signUpController.password,
                        errorColor: Colors.black,
                        hintText: "Password",
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      StyledTextField(
                        controller: signUpController.confirmPassword,
                        errorColor: Colors.black,
                        hintText: "Confirm Password",
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Confirm Password is required";
                          } else if (val != signUpController.password.text) {
                            return "Password not match!";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      signUpController.errorMsg.value != "Error"
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: AutoSizeText(
                                signUpController.errorMsg.value.toString(),
                                style: TextStyle(
                                    fontSize: FontSizes.s16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          : Container(),

                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      signUpController.isLoading.isTrue
                          ? Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                "assets/loader.gif",
                                height: 40,
                              ),
                            )
                          : StyledButton(
                              onPressed: () {
                                signUpController.errorMsg.value = "Error";
                                if (signUpController.formKey.currentState!
                                    .validate()) {
                                  signUpController
                                      .userRegisterController(
                                    firstName: signUpController.firstName.text,
                                    lastName: signUpController.lastname.text,
                                    username: signUpController.userName.text,
                                    email: signUpController.email.text,
                                    password: signUpController.password.text,
                                  )
                                      .then((value) {
                                    if (value!) {
                                      Get.toNamed("/login");
                                    }
                                  });
                                }
                              },
                              title: "Sign Up",
                              backgroundColor: Colors.white,
                              titleColor: backGroundColor,
                              borderRadius: BorderRadius.circular(5),
                              fontSize: 16,
                            ),
                      Spacer(),
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
            ),
          ),
        ),
      ),
    );
  }
}
