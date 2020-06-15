import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:locationnews/models/news.dart';
import 'package:locationnews/components/card.dart';
class NewsScreen extends StatefulWidget {
  final String location;

  NewsScreen({this.location});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final api_key = 'c3331ea850994b449943e957ef2e6f05';
  final mapsApi = 'AIzaSyBMMz1Eu83QBzurikicMKIE5GriC9Y5v54';
  bool newsLoaded;
  List<News> list = [];

  getNews() async {
    var response = await http.get('https://newsapi.org/v2/everything?q=${widget.location}&apiKey=${api_key}');
    if(response.statusCode == 200){
      setState(() {
        jsonDecode(response.body)['articles'].forEach((e) => list.add(News.fromJson(e)));
        newsLoaded = true;
      });
      print(list);
    }
  }

  @override
  void initState() {
    super.initState();
    newsLoaded = false;
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("News"),),
      body: !newsLoaded
      ? Center(child: CircularProgressIndicator()) 
      : ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: list.length,
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var news = list[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 12.0),
                        child: PrimaryCard(news: news),
                      );
                    },
                  ),
                ),
              ],
            )
    );
  }
}
