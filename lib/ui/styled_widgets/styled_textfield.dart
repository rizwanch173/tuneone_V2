import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuneone/ui/shared/styles.dart';


class StyledTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final Color? backGroundColor;
  final List<TextInputFormatter>? inputFormatter;
  final Function? onChanged;
  final TextInputType? inputType;
  final bool? obscureText;
  final Widget? leadingIcon;
  final FormFieldValidator<String>? validator;
  final String? initialValue;
  final Color? errorColor;
  final Function? onSaved;
 StyledTextField({this.errorColor,this.obscureText,this.leadingIcon,this.onChanged,this.controller,this.labelText,this.hintText,this.backGroundColor,this.validator,this.onSaved,this.inputType,this.initialValue,this.inputFormatter});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Flexible(child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        onSaved: onSaved as void Function(String?)?,
        validator: validator,
        initialValue: initialValue,
        obscureText: obscureText??false,
        cursorColor: Colors.white,
        inputFormatters: inputFormatter,
        onChanged: onChanged as void Function(String)?,
        style: TextStyle(fontSize: FontSizes.s16,color: Colors.white54),
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
            prefixIcon: leadingIcon,
            filled: backGroundColor!=null?true:false,
            fillColor: backGroundColor,
            hintText: hintText,
            errorStyle: TextStyle(color: errorColor),
            hintStyle: TextStyle(color: Colors.white),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.grey,fontSize: FontSizes.s6),
//        border: OutlineInputBorder(borderRadius: ),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
            errorBorder: errorColor!=null?OutlineInputBorder(borderSide: BorderSide(color: errorColor!)):null
        ),
      ))
    ],);
  }
}
