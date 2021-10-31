import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/pages.dart';
import 'package:tuneone/services_binder.dart';
import 'package:tuneone/ui/shared/styles.dart';

import 'ui/singlechannel/single_radio_view.dart';

late AudioPlayerHandler audioHandler;

Future<void> main() async {
  audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandlerImpl(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: <AppTheme>[
        AppTheme(
          id: "light",
          description: "light",
          data: ThemeData(
            // Real theme data
            primaryColor: Color(0xffFE6232),
            accentColor: Colors.red,
            fontFamily: 'Aeonik',
          ),
        ),
        AppTheme(
          id: "dark",
          description: "dark",
          data: ThemeData(
            // Real theme data
            primaryColor: darkBg,
            accentColor: Colors.red,
            fontFamily: 'Aeonik',
          ),
        )
      ],
      child: ThemeConsumer(
        child: Builder(
            builder: (themeContext) => GetMaterialApp(
                  theme: ThemeProvider.themeOf(themeContext).data,
                  smartManagement: SmartManagement.keepFactory,
                  initialBinding: ServicesBinder(),
                  getPages: pages,
                  debugShowCheckedModeBanner: false,
                  initialRoute: "/splash",
                )),
      ),
    );
  }
}
