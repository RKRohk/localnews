import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:locationnews/components/mapview.dart';
import 'package:locationnews/screens/generalnews.dart';
import 'package:locationnews/screens/newsscreen.dart';
import 'package:geocoder/geocoder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primaryColor: Color.fromARGB(255, 231, 201, 171),
          accentColor: Color.fromARGB(255, 231, 201, 171),
          textTheme: TextTheme(bodyText1: TextStyle(color: Colors.black),bodyText2: TextStyle(color: Colors.black)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MapSample());
  }
}


class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  int index;
  var GMap;

  @override
  void initState() {
    index = 0;
    GMap = MapView();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: index == 0
          ? GMap
          : GeneralNews(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Maps",style: TextStyle(color: Colors.black),)),
          BottomNavigationBarItem(
              icon: Icon(Icons.near_me), title: Text("News",style: TextStyle(color: Colors.black),))
        ],
        onTap: (value) {
          print(value);
          setState(() {
            index = value;
          });
        },
      ),
    );
  }

}
