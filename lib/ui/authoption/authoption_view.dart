import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/styled_widgets/styled_button.dart';

class AuthOptionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.fill
          ),
        ),
        child:
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.black.withOpacity(0.2),Color(0xffEF1930).withOpacity(0.4)],end: Alignment.bottomCenter,stops: [0.3,1],begin: Alignment.topCenter)
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width*0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StyledButton(
                    onPressed: (){
                      Get.toNamed("/signup");
                    },
                    title: "Create Account",backgroundColor: Colors.white,titleColor: backGroundColor,borderRadius: BorderRadius.circular(5),fontSize: 16,),
                SizedBox(height: Get.height*0.02,),
                  StyledButton(
                    onPressed: (){
                      Get.toNamed("/login");
                    },
                    title: "Login",backgroundColor: backGroundColor,titleColor: Colors.white,borderRadius: BorderRadius.circular(5),fontSize: 16,),
                SizedBox(height: Get.height*0.1,)
              ],),
            ),
          )
      ),
    );
  }
}
