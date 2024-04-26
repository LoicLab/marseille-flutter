import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marseille_flutter/cupertino_inkwell.dart';
import 'package:marseille_flutter/datasource.dart';
import 'package:marseille_flutter/place.dart';
import 'package:marseille_flutter/place_page.dart';

import 'adaptive_page.dart';

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
        itemBuilder: (BuildContext context, int index) {
          return (widget.platform == TargetPlatform.android)
              ? androidList(place: places[index], index: index)
              : cupertinoList(place: places[index], index: index)
          ;
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(color: Colors.indigoAccent, thickness: 1,);
        },
        itemCount: places.length
    );
  }

  ///Affichage d'une liste pour IOS
  CupertinoListTile cupertinoList({required Place place, required int index}){
    return CupertinoListTile(
        title: Text(place.name),
        leading: Text(index.toString()),
        trailing: Image.asset(
          place.getFolderPath(),
          width: MediaQuery.of(context).size.width/3,
        ),
      onTap: () {
        navigatorToPage(place: place);
      }
    );
  }

  ///Affichage d'une liste pour Android
  ListTile androidList({required Place place, required int index}){
     return ListTile(
       title: Text(place.name),
       leading: Text(index.toString()),
       trailing: Image.asset(
         place.getFolderPath(),
         width: MediaQuery.of(context).size.width/3,
       ),
       onTap: () {
         navigatorToPage(place: place);
       }
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
            child: Card(
              color: Colors.white,
              child: Column(
                  children: [
                    InkWell(
                      child: Image.asset(
                        places[index].getFolderPath(),
                        width: MediaQuery.of(context).size.width/4,
                      ),
                      onTap: (){
                        navigatorToPage(place: places[index]);
                      },
                    ),
                    Text(
                        places[index].name,
                        style: TextStyle(
                            fontSize: gridtextSize,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ]
              ),
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
                navigatorToPage(place: place);
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

  ///Permet d'aller sur la page d'une place
  void navigatorToPage({required Place place }){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext ctx){
          return AdaptivePage(
              platform: widget.platform,
              page: PlacePage(place: place)
          );
        })
    );
  }
}