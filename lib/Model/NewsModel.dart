class NewsModel {
  int? id; // Add an id to uniquely identify each article
  String? title;
  String? description;
  String? urlToImage;
  String? author;
  String? content;
  String? publishedAt;
  String? sourceName;

  NewsModel({
    this.id,
    this.title,
    this.description,
    this.urlToImage,
    this.author,
    this.content,
    this.publishedAt,
    this.sourceName,
  });

  // Convert a NewsModel instance to a Map for storing it in SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'author': author,
      'content': content,
      'publishedAt': publishedAt,
      'sourceName': sourceName,
    };
  }

  // Convert a Map to a NewsModel instance
  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      urlToImage: map['urlToImage'],
      author: map['author'],
      content: map['content'],
      publishedAt: map['publishedAt'],
      sourceName: map['sourceName'],
    );
  }
}

class CategoryModel {
  String? categoryName;

  CategoryModel({
    this.categoryName,
  });
}
