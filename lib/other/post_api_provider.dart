import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meetuper_app/other/posts.dart';

class PostApiProvider {

  static final PostApiProvider _singleton = PostApiProvider._internal();
  factory PostApiProvider() => _singleton;
  PostApiProvider._internal();


  Future<List<Post>> fetchPosts() async {
    final res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    final List<dynamic> parsedPosts = json.decode(res.body);

    return parsedPosts.map((parsedPost) => Post.fromJSON(parsedPost)).take(2).toList();
  }
}