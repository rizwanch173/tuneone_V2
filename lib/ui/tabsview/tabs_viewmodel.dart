import 'package:get/get.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/home_controllers.dart';
import 'package:tuneone/ui/following/following_view.dart';
import 'package:tuneone/ui/homepage/homepage_view.dart';
import 'package:tuneone/ui/library/library_view.dart';
import 'package:tuneone/ui/podcasts/podcasts_view.dart';
import 'package:tuneone/ui/radiostations/radiostations_view.dart';
import '../../main.dart';

class TabsViewModel extends GetxController {
  final DataController dataController = Get.find();
  final HomeController homeController = Get.find();

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
    PodCastsView.selectedPod(true);
    RadioStationsView.selectedRadio(true);
    update();
  }

  @override
  onInit() {
    print("onInit tabs");
    Future.delayed(Duration(seconds: 3), () {
      playIt();
    });

    super.onInit();
  }

  Future<bool?> playIt() async {
    var radioListIdIndex = [];
    var podcastListIdIndex = [];
    var indexToRemove = [];

    dataController.radioListMasterCopy.forEach((element) {
      radioListIdIndex.add(element.id);
    });

    dataController.podcastListMasterCopy.forEach((element) {
      podcastListIdIndex.add(element.id);
    });

    for (var i = 0; i < dataController.recentlyList.length; i++) {
      if (dataController.recentlyList[i].isRadio) {
        if (!radioListIdIndex.contains(dataController.recentlyList[i].id)) {
          indexToRemove.add(i);
          //  dataController.recentlyList.removeWhere((e0) => e0.id == element.id);
        }
      } else {
        if (!podcastListIdIndex.contains(dataController.recentlyList[i].id)) {
          indexToRemove.add(i);
          //  dataController.recentlyList.removeWhere((e1) => e1.id == element.id);
        }
      }
    }

    dataController.recentlyList.value = dataController.recentlyList
        .where((x) =>
            !indexToRemove.contains(dataController.recentlyList.indexOf(x)))
        .toList();

    print(dataController.settings[0]);
    if (dataController.settings[0] && dataController.recentlyList.length != 0) {
      if (dataController.recentlyList[0].isRadio) {
        var radioIndex = dataController.radioListMasterCopy
            .indexWhere((w) => w.id == dataController.recentlyList[0].id);

        await audioHandler.updateQueue(dataController.mediaListRadio);

        await audioHandler.skipToQueueItem(radioIndex);
        audioHandler.play();
        dataController.addRecently(
            dataController.radioListMasterCopy[radioIndex], false);
        homeController.whoAccess.value = "radio";
      } else {
        var podIndex = dataController.podcastListMasterCopy
            .indexWhere((w) => w.id == dataController.recentlyList[0].id);

        await audioHandler.updateQueue(dataController.mediaListPodcast);
        await audioHandler.skipToQueueItem(podIndex);
        audioHandler.play();
        dataController.addRecently(
            dataController.podcastListMasterCopy[podIndex], true);
        homeController.whoAccess.value = "pod";
      }
    }
  }
}
