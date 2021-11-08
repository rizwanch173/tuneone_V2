import 'package:audio_service/audio_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart' as Rxt;
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/home_controllers.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/singlechannel/single_podcast_view.dart';
import 'package:tuneone/ui/singlechannel/single_radio_view.dart';
import 'package:tuneone/ui/styled_widgets/cached_network_image.dart';
import 'package:marquee_text/marquee_text.dart';

import '../../main.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DataController dataController = Get.find();
    final HomeController homeController = Get.find();
    return Container(
      child: StreamBuilder<MediaItem?>(
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          // final queueState = snapshot.data;
          // final queue = queueState?.queue ?? [];
          // final mediaItem = queueState?.mediaItem;
          final mediaItem = snapshot.data;
          return GestureDetector(
            onTap: () {
              if (mediaItem?.duration == null) {
                var radioIndex = dataController.radioListMasterCopy
                    .indexWhere((w) => w.stream == mediaItem!.id);

                homeController.indexToPlayRadio.value = radioIndex;

                print(radioIndex);
                Get.to(SingleRadioView());
              } else {
                var podIndex = dataController.podcastListMasterCopy
                    .indexWhere((w) => w.stream == mediaItem!.id);

                homeController.indexToPlayPod = podIndex;

                print(podIndex);
                Get.to(SinglePodcastView());
              }
            },
            child: Container(
              color: ThemeProvider.themeOf(context).id == "light"
                  ? backGroundColor
                  : Theme.of(context).primaryColor,
              width: Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (mediaItem?.title != null)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color:
                                  ThemeProvider.themeOf(context).id == "light"
                                      ? Color(0xffF2F2F2).withOpacity(0.5)
                                      : darkTxt.withOpacity(0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x14000000),
                                offset: Offset(5, 5),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: StyledCachedNetworkImage(
                              url: mediaItem!.artUri.toString(),
                              height: Get.height * 0.06,
                              width: Get.width * 0.14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (mediaItem?.title != null)
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(
                            width: Get.width * 0.62,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: MarqueeText(
                                text: TextSpan(
                                  text: mediaItem!.title,
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Aeonik-medium",
                                ),
                                speed: 12,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            width: Get.width * 0.62,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: MarqueeText(
                                text: TextSpan(
                                  text: mediaItem.album,
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: "Aeonik-medium",
                                ),
                                speed: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (mediaItem?.title != null)
                    Expanded(
                      flex: 1,
                      child: StreamBuilder<PlaybackState>(
                        stream: audioHandler.playbackState,
                        builder: (context, snapshot) {
                          final playbackState = snapshot.data;
                          final processingState =
                              playbackState?.processingState;
                          final playing = playbackState?.playing;
                          if (processingState == AudioProcessingState.loading ||
                              processingState ==
                                  AudioProcessingState.buffering) {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              width: 40.0,
                              height: 40.0,
                              child: const CupertinoActivityIndicator(),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (playing == true)
                                    pauseButton(context)
                                  else
                                    playButton(
                                        context, mediaItem, dataController),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget playButton(context, mediaItem, dataController) => Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: IconButton(
          icon: Icon(Icons.play_arrow),
          color: Theme.of(context).primaryColor,
          onPressed: () async {
            if (mediaItem?.duration == null) {
              var radioIndex = dataController.radioListMasterCopy
                  .indexWhere((w) => w.stream == mediaItem!.id);
              await audioHandler.skipToQueueItem(radioIndex);
              print("radio");
            }
            audioHandler.play();
          },
        ),
      );
  Widget pauseButton(context) => Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: IconButton(
          icon: Icon(Icons.pause),
          color: Theme.of(context).primaryColor,
          onPressed: audioHandler.pause,
        ),
      );
}
