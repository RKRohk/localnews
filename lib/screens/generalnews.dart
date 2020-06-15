import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:locationnews/components/card.dart';
import 'package:locationnews/models/news.dart';
import 'package:http/http.dart' as http;

class GeneralNews extends StatefulWidget {
  @override
  _GeneralNewsState createState() => _GeneralNewsState();
}

final api_key = 'c3331ea850994b449943e957ef2e6f05';

class _GeneralNewsState extends State<GeneralNews> {
  var business;
  var entertainment;
  var general;
  var health;
  var science;
  var sports;
  var technology;

  bool newsLoaded;

  getCategory(category) async {
    List<News> list = [];
    var response = await http.get(
        'https://newsapi.org/v2/top-headlines?category=${category}&country=in&apiKey=c3331ea850994b449943e957ef2e6f05');
    if (response.statusCode == 200) {
      setState(() {
        jsonDecode(response.body)['articles']
            .forEach((e) => list.add(News.fromJson(e)));
      });
      print(list);
    }
    return list;
  }

  getNews() async {
    business = await getCategory('business');
    entertainment = await getCategory('entertainment');
    general = await getCategory('general');
    health = await getCategory('health');
    science = await getCategory('science');
    sports = await getCategory('sports');
    technology = await getCategory('technology');
    setState(() {
      newsLoaded = true;
    });
  }

  getList(list) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Container(
          height: 300,
          padding: EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: list.length > 10 ? 10 : list.length,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var news = list[index];
              return Container(
                width: MediaQuery.of(context).size.width * 0.8,
                margin: EdgeInsets.only(right: 12.0),
                child: PrimaryCard(news: news),
              );
            },
          ),
        ),
      ],
    );
  }

  final kTextStyle = TextStyle(fontSize: 22,fontWeight: FontWeight.w600);

  @override
  void initState() {
    newsLoaded = false;
    getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !newsLoaded
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Container(
                child: Padding(
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:16),
                    child: Text("Business",style: kTextStyle),
                  ),
                  SizedBox(height: 300, child: getList(business)),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:16),
                    child: Text("Entertainment",style: kTextStyle,),
                  ),
                  SizedBox(height: 300, child: getList(entertainment)),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:16),
                    child: Text("General",style: kTextStyle,),
                  ),
                  SizedBox(height: 300, child: getList(general)),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:16),
                    child: Text("Health",style: kTextStyle,),
                  ),
                  SizedBox(height: 300, child: getList(health)),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:16),
                    child: Text("Science",style: kTextStyle,),
                  ),
                  SizedBox(height: 300, child: getList(science)),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:16),
                    child: Text("Sports",style: kTextStyle,),
                  ),
                  SizedBox(height: 300, child: getList(sports)),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:16),
                    child: Text("Technology",style: kTextStyle,),
                  ),
                  SizedBox(height: 300, child: getList(technology)),
                ],
              )),
            )),
          );
  }
}
