import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/news_model.dart';

class CustomeHttpRequest {
  static Future<NewsModel> fetchHomeData(int pageNo, String sortBy) async {
    String url =
        "https://newsapi.org/v2/everything?q=football&sortBy=$sortBy&pageSize=10&page=${pageNo}&apiKey=dae4eb4267724b77b9831c0f448decaa";

    NewsModel? newsModel;
    var responce = await http.get(Uri.parse(url));
    print("status code is ${responce.statusCode}");
    var data = jsonDecode(responce.body);
    print("our responce is ${data}");
    newsModel = NewsModel.fromJson(data);
    return newsModel;
  }

  static Future<NewsModel> fetchSearchData(String query) async {
    String url =
        "https://newsapi.org/v2/everything?q=$query&pageSize=20&apiKey=dae4eb4267724b77b9831c0f448decaa";

    NewsModel? newsModel;
    var responce = await http.get(Uri.parse(url));
    print("status code is ${responce.statusCode}");
    var data = jsonDecode(responce.body);
    print("our responce is ${data}");
    newsModel = NewsModel.fromJson(data);
    return newsModel;
  }
}

//Check

//  String url =
//       "https://newsapi.org/v2/everything?q=football&sortBy=relevancy&pageSize=10&page=1&apiKey=dae4eb4267724b77b9831c0f448decaa";
//   NewsModel? newModel;

//   Future<NewsModel> fetchHomeData() async {
//     var response = await http.get(Uri.parse(url));
//     var data = jsonDecode(response.body);
//     newModel = NewsModel.fromJson(data);
//     return newModel!;
//   }
