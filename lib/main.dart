import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marseille_flutter/adaptive_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //final platform = Theme.of(context).platform;
    //Just for test
    const platform = TargetPlatform.android;
    bool isAndroid = (platform == TargetPlatform.android);
    return isAndroid ? androidBase(platform: platform) : iOSBase(platform: platform);
  }
  ///Defined the theme
  final ThemeData materialTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark
        ),
        useMaterial3: true
  );
  
  final String title = 'Marseille';

  MaterialApp androidBase({required TargetPlatform platform}){
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: materialTheme,
      home: AdaptivePage(platform: platform)
    );
  }

  CupertinoApp iOSBase({required TargetPlatform platform}){
    return CupertinoApp(
      title: title,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate
      ],
      theme: CupertinoThemeData(
        primaryColor: materialTheme.primaryColor,
      ),
      home: AdaptivePage(platform: platform)
    );
  }
}