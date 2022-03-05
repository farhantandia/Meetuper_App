import 'dart:convert';

import 'package:meetuper_app/models/user.dart';

class Post {
  final String text;
  final String body;
  final int id;
  User? user;
  final String updatedAt;

  Post(
      {required String text,
      required String body,
      required int id,
      this.user,
      required this.updatedAt})
      : this.text = text,
        this.body = body,
        this.id = id;

  Post.fromJSON(Map<String, dynamic> parsedJson)
      : this.text = parsedJson['text'],
        this.body = parsedJson['body'],
        this.updatedAt = parsedJson['updatedAt'],
        this.id = parsedJson['id'],
        this.user = User.fromJSON(parsedJson['user']);
}
