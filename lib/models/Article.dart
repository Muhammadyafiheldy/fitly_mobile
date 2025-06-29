class Article {
  final int id;
  final String title;
  final String content;
  final String image;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: '127.0.0.1/storage/' + json['image'], 
    );
  }
}
