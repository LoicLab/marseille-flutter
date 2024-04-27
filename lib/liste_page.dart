import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marseille_flutter/cupertino_inkwell.dart';
import 'package:marseille_flutter/datasource.dart';
import 'package:marseille_flutter/place.dart';
import 'package:marseille_flutter/place_page.dart';

import 'adaptive_page.dart';

///Liste ou de grid des lieux
class ListePage extends StatefulWidget{
  final TargetPlatform platform;

  const ListePage({super.key, required this.platform});

  @override
  ListePageState createState()=> ListePageState();
}

class ListePageState extends State<ListePage>{

  ///Style pour le texte des grids
  dynamic gridTextStyle = const TextStyle(
      fontSize: 12,
      color: Colors.black,
      fontWeight: FontWeight.bold
  );

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
          return Divider(color: Theme.of(context).colorScheme.primary, thickness: 1,);
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
        title: Text(
            place.name,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary
            ),
        ),
        leading: Text(
            index.toString(),
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary
            )
        ),
        trailing: Image.asset(
          place.getFolderPath(),
          width: MediaQuery.of(context).size.height/6,
          fit: BoxFit.cover,
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
    double radiusCircular = 15;
    return GridView.builder(
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(radiusCircular)
                ),
                color: Colors.white,
                child: Column(
                  children: [
                    InkWell(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(radiusCircular),
                            topRight: Radius.circular(radiusCircular)
                          ),
                          child: Image.asset(
                              places[index].getFolderPath(),
                              width: MediaQuery.of(context).size.width/4,
                              height: MediaQuery.of(context).size.height/2.5,
                              fit: BoxFit.cover
                          ),
                        ),
                        onTap: (){
                          navigatorToPage(place: places[index]);
                        }
                    ),
                    Text(
                        places[index].name,
                        style: gridTextStyle
                    )
                  ],
                )
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
              child: Card(
                child: Column(
                  children: [
                    Image.asset(
                        place.getFolderPath(),
                        width: MediaQuery.of(context).size.width/4.3,
                        height: MediaQuery.of(context).size.height/2.5,
                        fit: BoxFit.cover
                    ),
                    Text(
                        place.name,
                        style: gridTextStyle
                    )
                  ],
                ),
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
              page: PlacePage(place: place),
              titleBar: place.name,
          );
        })
    );
  }
}