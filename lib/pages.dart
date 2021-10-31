import 'package:get/get.dart';
import 'package:tuneone/controllers/login_controller.dart';
import 'package:tuneone/controllers/splashscreen_controller.dart';
import 'package:tuneone/ui/authoption/authoption_view.dart';
import 'package:tuneone/ui/forgetpassword/forgetpassword_view.dart';
import 'package:tuneone/ui/forgetpassword/forgetpassword_viewmodel.dart';
import 'package:tuneone/ui/login/login_view.dart';
import 'package:tuneone/ui/signup/signup_view.dart';
import 'package:tuneone/controllers/signup_controller.dart';
import 'package:tuneone/ui/splashscreen/splashscreen_view.dart';
import 'package:tuneone/ui/tabsview/tabs_view.dart';
import 'package:tuneone/ui/tabsview/tabs_viewmodel.dart';

List<GetPage> pages = [
  GetPage(
      name: '/splash',
      page: () => SplashScreenView(),
      binding: BindingsBuilder(() {
        Get.put(SplashScreenController());
      })),
  GetPage(name: '/authoption', page: () => AuthOptionView()),
  GetPage(
      name: '/signup',
      page: () => SignUpView(),
      binding: BindingsBuilder(() {
        Get.put(SignUpController());
      })),
  GetPage(
      name: '/login',
      page: () => LoginView(),
      binding: BindingsBuilder(() {
        Get.put(LoginController());
      })),
  GetPage(
      name: '/forgetpassword',
      page: () => ForgetPasswordView(),
      binding: BindingsBuilder(() {
        Get.put(ForgetPasswordViewModel());
      })),
  GetPage(
      name: '/tabs',
      page: () => TabsView(),
      binding: BindingsBuilder(() {
        Get.put(TabsViewModel());
      })),
  // GetPage(
  //     name: '/radio',
  //     page: () => RadioStationsView(),
  //     binding: BindingsBuilder(() {
  //       Get.put(RadioController());
  //     })),
];
