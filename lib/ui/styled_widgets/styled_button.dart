import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StyledButton extends StatelessWidget{
  final Function? onPressed;
  final String? title;
  final Color? titleColor;
  final Color? backgroundColor;
  final String? icon;
  final BorderRadius? borderRadius;
  final double? fontSize;
  StyledButton({this.icon,this.backgroundColor,this.titleColor,this.title,this.onPressed,this.borderRadius,this.fontSize});
  @override
  build(BuildContext context){
    return GestureDetector(
      onTap:onPressed as void Function()?,
      child: Container(
          width: Get.width,
          height: Get.height*0.07,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon!=null?Padding(
                padding: EdgeInsets.only(right: 10),
                child: SizedBox(
                    height:Get.height*0.03,
                    child: Image.asset(icon!)),
              ):SizedBox(),
            AutoSizeText(title!,style: TextStyle(color: titleColor,fontSize: fontSize),)
          ],)),);
  }
}