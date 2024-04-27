import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///Classe qui permet de gérer l'affichage des pages suivant si on est sur Android ou IOS
class AdaptivePage extends StatefulWidget{
  final TargetPlatform platform;
  final Widget page;
  final String titleBar;

  const AdaptivePage({
    super.key,
    required this.platform,
    required this.page,
    required this.titleBar
  });

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
        title: Text(widget.titleBar),
        backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  CupertinoNavigationBar navBar() {
    return CupertinoNavigationBar(
        middle: Text(widget.titleBar),
        backgroundColor: Theme.of(context).colorScheme.primary
    );
  }

  Widget body(){
    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: widget.page,
    );
  }
}