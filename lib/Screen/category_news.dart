import 'package:flutter/material.dart';
import 'package:newsapp/Model/NewsModel.dart';
import 'package:newsapp/Services/services.dart';

class SelectedCategoryNews extends StatefulWidget {
  final String category;

  SelectedCategoryNews({Key? key, required this.category}) : super(key: key);

  @override
  State<SelectedCategoryNews> createState() => _SelectedCategoryNewsState();
}

class _SelectedCategoryNewsState extends State<SelectedCategoryNews> {
  List<NewsModel> articles = [];
  bool isLoading = true;
  Set<int> bookmarkedArticles = {};

  @override
  void initState() {
    super.initState();
    getNews();
  }

  Future<void> getNews() async {
    CategoryNews news = CategoryNews();
    await news.getNews(widget.category);
    setState(() {
      articles = news.dataStore;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: TextStyle(fontSize: screenWidth * 0.05),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
        itemCount: articles.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final article = articles[index];
          bool isBookmarked = bookmarkedArticles.contains(index);

          return GestureDetector(
            onTap: () {

            },
            child: NewsArticleView(
              article: article,
              isBookmarked: isBookmarked,
              onBookmarkToggle: () {
                setState(() {
                  if (isBookmarked) {
                    bookmarkedArticles.remove(index);
                  } else {
                    bookmarkedArticles.add(index);
                  }
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isBookmarked
                          ? 'Article removed from bookmarks'
                          : 'Article added to bookmarks',
                    ),
                  ),
                );
              },
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
          );
        },
      ),
    );
  }
}

class NewsArticleView extends StatelessWidget {
  final NewsModel article;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final double screenWidth;
  final double screenHeight;

  const NewsArticleView({
    Key? key,
    required this.article,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              article.urlToImage ?? '',
              height: screenHeight * 0.3,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            article.title ?? "No Title",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.015),
          Text(
            article.description ?? "No Description",
            style: TextStyle(fontSize: screenWidth * 0.04),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.02),
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.blue,
              size: screenWidth * 0.08,
            ),
            onPressed: onBookmarkToggle,
          ),
        ],
      ),
    );
  }
}
