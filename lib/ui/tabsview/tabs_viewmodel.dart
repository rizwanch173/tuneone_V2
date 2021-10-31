import 'package:get/get.dart';
import 'package:tuneone/ui/following/following_view.dart';
import 'package:tuneone/ui/homepage/homepage_view.dart';
import 'package:tuneone/ui/library/library_view.dart';
import 'package:tuneone/ui/podcasts/podcasts_view.dart';
import 'package:tuneone/ui/radiostations/radiostations_view.dart';

class TabsViewModel extends GetxController {
  int index = 0;
  List items = [
    HomePageView(),
    RadioStationsView(),
    PodCastsView(),
    LibraryView(),
    FollowingView()
  ];
  changeIndex(int val) {
    index = val;
    update();
  }
}
