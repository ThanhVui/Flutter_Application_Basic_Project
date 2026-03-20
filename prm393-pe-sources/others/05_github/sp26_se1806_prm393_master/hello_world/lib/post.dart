import 'package:flutter/gestures.dart';

class Post {
  int userId;
  int id;
  String title;
  String body;

  Post({                  // unnamed
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) { // named constructor
    return Post(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body
    };
  }

  // Display info displayInfo()
  void displayInfo() {
    print("User Id : $userId");
    print("id : $id");
    print("title : $title");
    print("body : $body");
  }



  // print theo format
  // Post $id: $title
  // $body
}
