import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:news_app/model/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/screens/search_page.dart';
import 'package:news_app/screens/web_view_page.dart';
import 'package:provider/provider.dart';
import '../provider/news_provide.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String sortBy = "publishedAt";
  int pageNo = 1;
  @override
  Widget build(BuildContext context) {
    var newsProvider = Provider.of<NewsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.newspaper_outlined),
        title: Center(child: Text(" News_Today")),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => SearchPage())));
              },
              icon: Icon(Icons.search)),
        ],
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      body: Container(
          padding: EdgeInsets.all(11),
          child: ListView(children: [
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        if (pageNo == 1) {
                          return null;
                        } else {
                          setState(() {
                            pageNo -= 1;
                          });
                        }
                      },
                      child: Text("Prev")),
                  Flexible(
                    flex: 2,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              setState(() {
                                pageNo = index + 1;
                              });
                            },
                            child: Container(
                              color: pageNo == index + 1
                                  ? Colors.deepOrange
                                  : Colors.blueGrey,
                              margin: EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ));
                      },
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        if (pageNo < 5) {
                          setState(() {
                            pageNo += 1;
                          });
                        }
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: DropdownButton(
                value: sortBy,
                items: [
                  DropdownMenuItem(
                    child: Text("relevancy"),
                    value: "relevancy",
                  ),
                  DropdownMenuItem(
                    child: Text("popularity"),
                    value: "popularity",
                  ),
                  DropdownMenuItem(
                    child: Text("publishedAt"),
                    value: "publishedAt",
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    sortBy = value!;
                  });
                },
              ),
            ),
            FutureBuilder<NewsModel>(
                future: newsProvider.getHomeData(pageNo, sortBy),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                        " Something went Wrong/n Check Your Networ Connection");
                  } else if (snapshot.data == null) {
                    return Text("No Data Found ");
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, i) {
                        return Container(
                          padding: const EdgeInsets.all(9),
                          height: 131,
                          color: Colors.white,
                          child: Stack(children: [
                            Container(
                              height: 60,
                              width: 60,
                              color: Colors.black26,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 60,
                                width: 60,
                                color: Colors.black26,
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(14),
                              margin: EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${snapshot.data!.articles![i].urlToImage}",
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Image.network(
                                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOmYqa4Vpnd-FA25EGmYMiDSWOl9QV8UN1du_duZC9mQ&s"),
                                        ),
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      flex: 10,
                                      child: Column(
                                        children: [
                                          Text(
                                            "${snapshot.data!.articles![i].title}",
                                            maxLines: 2,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              WebViewPage(
                                                                articles: snapshot
                                                                    .data!
                                                                    .articles![i],
                                                              )));
                                                },
                                                child: Icon(Icons.abc),
                                              ),
                                              Text(
                                                  "${snapshot.data!.articles![i].publishedAt}"),
                                            ],
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            )
                          ]),
                        );
                      });
                }),
          ])),
    );
  }
}
