import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:tuneone/controllers/radio_controller.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:audio_manager/audio_manager.dart';

class RadioPlayer extends StatelessWidget {
  final RadioController controller = Get.find();

  Widget build(BuildContext context) {
    print(controller.isPlaying.value);

    AudioManager.instance
        .play(index: controller.nextStationIndex.value, auto: false);
    AudioManager.instance.toPause();

    return Scaffold(
      body: Obx(
        () => Container(
            color: backGroundColor,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                child: Column(children: [
                  SizedBox(
                    height: kToolbarHeight,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          LineIcons.stepBackward,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (controller.nextStationIndex.value == 0)
                            controller.nextStationIndex.value =
                                controller.radioList.length - 1;
                          else
                            controller.nextStationIndex.value -= 1;
                          AudioManager.instance.previous();
                          controller.isPlaying(true);
                        },
                      ),
                      Expanded(
                        child: AutoSizeText(
                          controller
                              .radioList[controller.nextStationIndex.value]
                              .title,
                          presetFontSizes: [18, 16, 14],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          LineIcons.stepForward,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (controller.nextStationIndex.value ==
                              controller.radioList.length - 1)
                            controller.nextStationIndex.value = 0;
                          else
                            controller.nextStationIndex.value += 1;
                          AudioManager.instance.next();
                          controller.isPlaying(true);
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              height: Get.height * 0.4,
                              imageUrl: controller
                                  .radioList[controller.nextStationIndex.value]
                                  .thumbnail,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                  child: Center(
                                      child: new CupertinoActivityIndicator())),
                              errorWidget: (context, url, error) {
                                return Image(
                                  image:
                                      AssetImage("assets/image-not-found.svg"),
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AutoSizeText(
                          controller
                              .radioList[controller.nextStationIndex.value]
                              .title,
                          style: TextStyle(color: Colors.white),
                          presetFontSizes: [18, 16],
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Icon(
                          Icons.add_to_photos,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Expanded(
                        child: Icon(Icons.replay_30_outlined,
                            color: Colors.white, size: 30),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          padding: EdgeInsets.all(5),
                          child: controller.isPlaying.value == true
                              ? IconButton(
                                  iconSize: 30,
                                  icon: Icon(
                                    Icons.stop_rounded,
                                    color: backGroundColor,
                                  ),
                                  onPressed: () {
                                    AudioManager.instance.playOrPause();
                                    controller.isPlaying(false);
                                    //AudioManager.instance.stop();
                                  })
                              : IconButton(
                                  iconSize: 30,
                                  icon: Icon(
                                    Icons.play_arrow,
                                    color: backGroundColor,
                                  ),
                                  onPressed: () {
                                    AudioManager.instance.toPlay();
                                    //AudioManager.instance.playOrPause();
                                    controller.isPlaying(true);
                                    // controller.isPlaying.value = true;
                                  }),
                        ),
                      ),
                      Expanded(
                        child: Icon(
                          Icons.thumbs_up_down_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Expanded(
                        child: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: kBottomNavigationBarHeight,
                  )
                ]))),
      ),
    );
  }
}

//
//   Widget bottomPanel() {
//     return Column(children: <Widget>[
//       Container(
//         padding: EdgeInsets.symmetric(vertical: 16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             IconButton(
//                 icon: getPlayModeIcon(controller.playMode.value),
//                 onPressed: () {
//                   controller.playMode.value = AudioManager.instance.nextMode();
//                 }),
//             IconButton(
//                 iconSize: 36,
//                 icon: Icon(
//                   Icons.skip_previous,
//                   color: Colors.black,
//                 ),
//                 onPressed: () => AudioManager.instance.previous()),
//             IconButton(
//               onPressed: () async {
//                 bool playing = await AudioManager.instance.playOrPause();
//                 print("await -- $playing");
//               },
//               padding: const EdgeInsets.all(0.0),
//               icon: Icon(
//                 controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
//                 size: 48.0,
//                 color: Colors.black,
//               ),
//             ),
//             IconButton(
//                 iconSize: 36,
//                 icon: Icon(
//                   Icons.skip_next,
//                   color: Colors.black,
//                 ),
//                 onPressed: () => AudioManager.instance.next()),
//             IconButton(
//                 icon: Icon(
//                   Icons.stop,
//                   color: Colors.black,
//                 ),
//                 onPressed: () => AudioManager.instance.stop()),
//           ],
//         ),
//       ),
//     ]);
//   }
//
//   Widget getPlayModeIcon(PlayMode playMode) {
//     switch (playMode) {
//       case PlayMode.sequence:
//         return Icon(
//           Icons.repeat,
//           color: Colors.black,
//         );
//       case PlayMode.shuffle:
//         return Icon(
//           Icons.shuffle,
//           color: Colors.black,
//         );
//       case PlayMode.single:
//         return Icon(
//           Icons.repeat_one,
//           color: Colors.black,
//         );
//     }
//     return Container();
//   }
//
//   String _formatDuration(Duration d) {
//     if (d == null) return "--:--";
//     int minute = d.inMinutes;
//     int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
//     String format = ((minute < 10) ? "0$minute" : "$minute") +
//         ":" +
//         ((second < 10) ? "0$second" : "$second");
//     return format;
//   }
//
//   Widget volumeFrame() {
//     return Row(children: <Widget>[
//       IconButton(
//           padding: EdgeInsets.all(0),
//           icon: Icon(
//             Icons.audiotrack,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             AudioManager.instance.setVolume(0);
//           }),
//       // Expanded(
//       //     child: Padding(
//       //         padding: EdgeInsets.symmetric(horizontal: 0),
//       //         child: Slider(
//       //           value: controller.sliderVolume.value ?? 0,
//       //           onChanged: (value) {
//       //             controller.sliderVolume.value = value;
//       //             AudioManager.instance.setVolume(value, showVolume: true);
//       //           },
//       //         )))
//     ]);
//   }
// }
