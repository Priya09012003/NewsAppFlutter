import 'package:flutter/material.dart';
import 'package:newsapp/Model/NewsModel.dart';
import 'package:newsapp/Services/services.dart';

class Bookmarkscreen extends StatelessWidget {
  final Set<int> bookmarkedArticles;

  const Bookmarkscreen({Key? key, required this.bookmarkedArticles}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bookmarked Articles",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: bookmarkedArticles.isEmpty
          ? const Center(
        child: Text('No Bookmarked Articles'),
      )
          : FutureBuilder<List<NewsModel>>(
        future: fetchBookmarkedArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading articles'));
          }

          final List<NewsModel> bookmarkedData = snapshot.data ?? [];

          return ListView.builder(
            itemCount: bookmarkedData.length,
            itemBuilder: (context, index) {
              final article = bookmarkedData[index];
              return Dismissible(
                key: Key(article.title ?? 'Article$index'),
                onDismissed: (direction) {
                  bookmarkedArticles.remove(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${article.title} removed from bookmarks'),
                    ),
                  );
                },
                background: Container(
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailScreen(
                            article: article,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              article.urlToImage ?? '',
                              height: screenWidth * 0.6,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            article.title ?? "No Title",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Divider(thickness: 2),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<NewsModel>> fetchBookmarkedArticles() async {
    NewsApi newsApi = NewsApi();
    await newsApi.getNews();
    final List<NewsModel> allArticles = newsApi.dataStore;

    List<NewsModel> bookmarkedData = [];
    for (int index in bookmarkedArticles) {
      if (index < allArticles.length) {
        bookmarkedData.add(allArticles[index]);
      }
    }

    return bookmarkedData;
  }
}

class ArticleDetailScreen extends StatelessWidget {
  final NewsModel article;

  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  article.urlToImage ?? '',
                  height: screenWidth * 0.6,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                article.title ?? "No Title",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                article.description ?? "No Description",
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              Text(
                'Source: ${article.sourceName ?? "Unknown"}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 10),
              Text(
                'Published: ${article.publishedAt ?? "Unknown"}',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
