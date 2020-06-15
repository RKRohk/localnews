import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MapSample());
  }
}

final api_key = 'c3331ea850994b449943e957ef2e6f05';
final mapsApi = 'AIzaSyBMMz1Eu83QBzurikicMKIE5GriC9Y5v54';

getNews({String country = 'in'}) async {
  var response = await http.get(
      'https://newsapi.org/v2/top-headlines?country=$country&apiKey=${api_key}');
  return response;
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  LatLng position;

  Marker myMarker;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  getUserLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(_locationData.latitude, _locationData.longitude),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414)));
  }

  int index;

  @override
  void initState() {
    index = 0;
    super.initState();
    position = LatLng(0, 0);
    getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    myMarker = Marker(
        markerId: new MarkerId("myMarker"),
        position: position,
        onTap: () async {
          print(position);
          final coordinates =
              Coordinates(position.latitude, position.longitude);
          var meh =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);

          var feature = meh.first.adminArea ?? meh.first.countryCode;
          print(meh.first.adminArea);
          print(meh.first.countryName);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewsScreen(
                        location: feature,
                      )));
        });

    return Scaffold(
      body: index == 0
          ? GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (value) async {
                print(value);
                setState(() {
                  position = value;
                });
              },
              markers: Set.from([myMarker]),
            )
          : Container(),
      floatingActionButton: index == 0
          ? FloatingActionButton(
              onPressed: _goToTheLake,
              child: Icon(Icons.location_on),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Maps")),
          BottomNavigationBarItem(
              icon: Icon(Icons.near_me), title: Text("News"))
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

  Future<void> _goToTheLake() async {
    getUserLocation();
    setState(() {
      position = LatLng(_locationData.latitude, _locationData.longitude);
    });
  }
}
