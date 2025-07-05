import 'package:flutter/material.dart';

class Article {
  final int id;
  final String title;
  final String content;
  final String image; // Tambahkan ini

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.image, // Tambahkan ini
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: json['image'], // Parsing image dari JSON
    );
  }
}
