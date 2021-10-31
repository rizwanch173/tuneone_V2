import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tuneone/Services/remote_services.dart';

class SignUpController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var create = "Create Account".obs;

  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  var errorMsg = "Error".obs;
  var isLoading = false.obs;

  Future<bool?> userRegisterController(
      {firstName, lastName, username, email, password}) async {
    try {
      isLoading(true);
      var user = await RemoteServices.registerUser(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        password: password,
      );
      if (user![0]) {
        isLoading(false);
        return true;
      } else {
        isLoading(false);
        errorMsg.value = user[1];

        return false;
      }
    } finally {
      isLoading(false);

    }
  }
}
