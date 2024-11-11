import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newsapp/Model/NewsModel.dart';

class NewsApi {
  List<NewsModel> dataStore = [];

  Future<void> getNews() async {
    Uri url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=493cb7373c7e4a7496475ee3a7ec3f82");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      if (jsonData["articles"] != null) {
        jsonData["articles"].forEach((element) {
          NewsModel newsModel = NewsModel(
            title: element['title'] ?? "No Title",
            description: element['description'] ?? "No Description",
            urlToImage: element['urlToImage'] ?? "",
            author: element['author'] ?? "Unknown Author",
            content: element['content'] ?? "Content not available",
            publishedAt: element['publishedAt'] ?? "Unknown Date",
            sourceName: element['source']?['name'] ?? "Unknown Source",
          );


          dataStore.add(newsModel);
        });
      }
    }
  }
}
class CategoryNews {
  List<NewsModel> dataStore = [];

  Future<void> getNews(String category) async {

    Uri url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=493cb7373c7e4a7496475ee3a7ec3f82");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      if (jsonData["articles"] != null) {

        dataStore.clear();

        jsonData["articles"].forEach((element) {
          NewsModel newsModel = NewsModel(
            title: element['title'] ?? "No Title",
            description: element['description'] ?? "No Description",
            urlToImage: element['urlToImage'] ?? "",
            author: element['author'] ?? "Unknown Author",
            content: element['content'] ?? "Content not available",
            publishedAt: element['publishedAt'] ?? "Unknown Date",
            sourceName: element['source']?['name'] ?? "Unknown Source",
          );

          dataStore.add(newsModel);
        });
      }
    }
  }
}
