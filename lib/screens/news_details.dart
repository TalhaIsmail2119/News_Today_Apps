import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../model/news_model.dart';

class NewsDetails extends StatelessWidget {
  //const NewsDetails({super.key});
  NewsDetails({Key? key, this.articles}) : super(key: key);
  Articles? articles;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${articles!.author}"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("${articles!.title}"),
            ],
          ),
        ),
      ),
    );
  }
}
