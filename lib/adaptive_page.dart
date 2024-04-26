import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marseille_flutter/liste_page.dart';

class AdaptivePage extends StatefulWidget{
  final TargetPlatform platform;

  const AdaptivePage({super.key, required this.platform});

  @override
  AdaptivePageState createState()=> AdaptivePageState();
}

class AdaptivePageState extends State<AdaptivePage>{
  @override
  Widget build(BuildContext context) {
    return scaffold();
  }

  bool isAndroid() => (widget.platform == TargetPlatform.android);

  Widget scaffold() {
    return (isAndroid())
        ? Scaffold(appBar: appBar(), body: body())
        : CupertinoPageScaffold(navigationBar: navBar(),child: body());
  }

  AppBar appBar() {
    return AppBar(
        title: const Text("Android"),
        backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  CupertinoNavigationBar navBar() {
    return CupertinoNavigationBar(
        middle: const Text("iOS"),
        backgroundColor: Theme.of(context).colorScheme.primary
    );
  }

  Widget body(){
    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListePage(platform: widget.platform),
    );
  }
}