import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuneone/ui/forgetpassword/newpassword_view.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/styled_widgets/styled_button.dart';
import 'package:tuneone/ui/styled_widgets/styled_textfield.dart';

import 'forgetpassword_viewmodel.dart';


class CodeEntryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.png")
            ),
          ),
          child: GetBuilder<ForgetPasswordViewModel>(builder: (_){
            return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xffEF1930).withOpacity(0.7)],end: Alignment.bottomCenter,stops: [1],begin: Alignment.topCenter)
              ),
              child: Form(
                key: _.codeEntryKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
                  child: Column(
                    children: [
                      SizedBox(height: Get.height*0.08,),
                      AutoSizeText("Enter Code",style: TextStyle(fontSize: FontSizes.s20,color: Colors.white,fontWeight: FontWeight.w600),),
                      SizedBox(height: Get.height*0.03,),
                      StyledTextField(
                        errorColor: Colors.black,
                        hintText: "Enter 6 digit code",
                      ),
                      SizedBox(height: Get.height*0.03,),
                      StyledButton(
                        onPressed: (){
                          Get.to(()=>NewPasswordView());
                        },
                        title: "Next",backgroundColor: Colors.white,titleColor: backGroundColor,borderRadius: BorderRadius.circular(5),fontSize: 16,),

                    ],
                  ),
                ),
              ),
            );
          },),
        ),
      ),
    );
  }
}
