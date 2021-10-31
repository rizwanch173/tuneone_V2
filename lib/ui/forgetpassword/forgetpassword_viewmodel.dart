
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgetPasswordViewModel extends GetxController{
    final GlobalKey<FormState> formKey=GlobalKey<FormState>();
    final GlobalKey<FormState> codeEntryKey=GlobalKey<FormState>();
    final GlobalKey<FormState> newPasswordKey=GlobalKey<FormState>();
}