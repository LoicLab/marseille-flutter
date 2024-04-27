import 'package:flutter/material.dart';
import 'package:marseille_flutter/place.dart';

///Affiche la description et l'image du quartier
class PlacePage extends StatefulWidget{
  final Place place;

  const PlacePage({super.key, required this.place});

  @override
  PlacePageState createState()=> PlacePageState();
}

class PlacePageState extends State<PlacePage>{
  @override
  Widget build(BuildContext context) {
    return (MediaQuery.of(context).orientation == Orientation.portrait)
        ? columnView()
        : rowView()
    ;
  }

  ///Affiche les informations en colonne
  SingleChildScrollView columnView(){
    return SingleChildScrollView(
      child: Column(
          children: [
            Image.asset(widget.place.getFolderPath()),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(widget.place.desc)
            )
          ]
      ),
    );
  }

  ///Affiche les informations en lignes
  Row rowView(){
    return Row(
            children: [
              Image.asset(
                  widget.place.getFolderPath(),
                  width: MediaQuery.of(context).size.width/2
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width/2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                          widget.place.desc,
                          textAlign: TextAlign.left
                      )
                    ],
                  ),
                ),
              )
            ]
        );
  }
}