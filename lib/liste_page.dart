import 'package:flutter/material.dart';
import 'package:marseille_flutter/cupertino_inkwell.dart';
import 'package:marseille_flutter/datasource.dart';
import 'package:marseille_flutter/place.dart';

///Affichage des informations sous forme de liste ou de grid
class ListePage extends StatefulWidget{
  final TargetPlatform platform;

  const ListePage({super.key, required this.platform});

  @override
  ListePageState createState()=> ListePageState();
}

class ListePageState extends State<ListePage>{

  ///Taille du texte pour les grid
  double gridtextSize = 12;

  @override
  Widget build(BuildContext context){
    final List<Place> places = DataSource().allPlaces();
    final orientation = MediaQuery.of(context).orientation;
    return (orientation == Orientation.portrait)
        ? listSeparated(places: places)
        : grid(places: places,context: context)
    ;
  }
  ///Affichage d'une liste
  Widget listSeparated({required List<Place> places}){

    return ListView.separated(
        itemBuilder: (BuildContext context, int index){
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(index.toString()),
              Text(
                places[index].name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              Image.asset(
                places[index].getFolderPath(),
                width: MediaQuery.of(context).size.width/3,
              )
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index){
          return Divider(color: Theme.of(context).colorScheme.primary,thickness: 1);
        },
        itemCount: places.length
    );
  }
  ///Utilisation des grid pour l'affichage
  Widget grid({required List<Place> places, required BuildContext context}){
    return (widget.platform == TargetPlatform.android)
        ? androidGrid(places: places)
        : cupertinoGrid(places: places,context: context)
    ;
  }
  ///Affichage des grid pour Android
  Widget androidGrid({required List<Place> places}){
    return GridView.builder(
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
                children: [
                  InkWell(
                      child: Image.asset(
                        places[index].getFolderPath(),
                        width: MediaQuery.of(context).size.width/4,
                      )
                  ),
                  Text(
                      places[index].name,
                      style: TextStyle(
                          fontSize: gridtextSize
                      )
                  )
                ]
            )
        );
      },
      itemCount: places.length,
    );
  }
  ///Affichage des grid pour IOS
  Widget cupertinoGrid({required List<Place> places, required BuildContext context}){
    List<Widget> rowCupertinoInkWell = [];
    List<Widget> cupertinoInkWellList = [];
    //Pour chaque quartier
    for (var place in places) {
      //Ajoute une card
      rowCupertinoInkWell.add(
          CupertinoInkWell(
              onPressed: () {

              },
              child:  Padding(
                  padding: const EdgeInsets.only(right: 4, left: 4),
                  child: Column(
                    children: [
                      Image.asset(
                          place.getFolderPath(),
                          width: MediaQuery.of(context).size.width/4.3
                      ),
                      Text(
                        place.name,
                        style: TextStyle(
                            fontSize: gridtextSize
                        ),
                      )
                    ],
                  )
              )
          )
      );
      if(rowCupertinoInkWell.length == 4){
        cupertinoInkWellList.add(
            Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: rowCupertinoInkWell
                )
            )
        );
        rowCupertinoInkWell = [];
      }
    }
    return SingleChildScrollView(
        child: Column(
            children: cupertinoInkWellList
        )
    );
  }
}