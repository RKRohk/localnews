class News {
  var source;
  var title;
  var author;
  var description;
  var url;
  var urlToImage;
  var publishedAt;
  var content;

  News(
      {this.source,
      this.title,
      this.author,
      this.description,
      this.url,
      this.urlToImage,
      this.publishedAt,
      this.content});

  News.fromJson(var jsonObject) {
    this.source = jsonObject['source'] ?? '';
    this.title = jsonObject['title'] ?? '';
    this.author = jsonObject['author'] ?? '';
    this.description = jsonObject['description'] ?? '';
    this.urlToImage = jsonObject['urlToImage'] ?? '';
    this.url = jsonObject['url'] ?? '';
    this.publishedAt = jsonObject['publishedAt'] ?? '';
    this.content = jsonObject['content'] ?? '';
  }

  @override
  String toString() {
    // TODO: implement toString
    return (title);
    return super.toString();
  }
}
