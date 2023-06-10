import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:news_app/http/custome_http.dart';
import 'package:news_app/model/news_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<String> searchKeyword = [
    "Technology",
    "Sports",
    "Politics",
    "Economics",
  ];
  NewsModel? newsModel;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(children: [
            TextField(
              onEditingComplete: () async {
                newsModel = await CustomeHttpRequest.fetchSearchData(
                    searchController.text.toString());
                setState(() {});
              },
              controller: searchController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  // enabledBorder: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  suffix: IconButton(
                      onPressed: () {
                        searchController.clear();
                        newsModel!.articles!.clear();
                        setState(() {});
                      },
                      icon: Icon(Icons.cancel_outlined))),
            ),
            SizedBox(
              height: 22,
            ),
            MasonryGridView.count(
              shrinkWrap: true,
              itemCount: searchKeyword.length,
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    searchController.text = searchKeyword[index];
                    newsModel = await CustomeHttpRequest.fetchSearchData(
                        searchController.text.toString());
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text("${searchKeyword[index]}"),
                  ),
                );
              },
            ),
            newsModel?.articles == null
                ? SizedBox(
                    height: 0,
                  )
                : ListView.builder(
                    itemCount: newsModel!.articles!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
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
                                            "${newsModel!.articles![index].urlToImage}",
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
                                          "${newsModel!.articles![index].title}",
                                          maxLines: 2,
                                        ),
                                        Text(
                                            "${newsModel!.articles![index].publishedAt}"),
                                      ],
                                    ))
                              ],
                            ),
                          )
                        ]),
                      );
                    })
          ]),
        ),
      ),
    ));
  }
}
