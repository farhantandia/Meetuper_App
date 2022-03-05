import 'package:meetuper_app/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:meetuper_app/models/forms.dart';
import 'package:meetuper_app/models/thread.dart';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meetuper_app/models/meetup.dart';

class MeetupApiService {
  final String url =
      Platform.isIOS ? 'http://localhost:3001/api/v1' : 'http://10.0.2.2:3001/api/v1';

  static final MeetupApiService _singleton = MeetupApiService._internal();

  factory MeetupApiService() {
    return _singleton;
  }
  MeetupApiService._internal();

  Future<List<Meetup>> fetchMeetups() async {
    final res = await http.get(Uri.parse("$url/meetups"));
    final List<dynamic> parsedMeetups = json.decode(res.body);

    return parsedMeetups.map((val) => Meetup.fromJSON(val)).toList();
  }

  Future<List<userCategory>> fetchCategories() async {
    final res = await http.get(Uri.parse('$url/categories'));
    final List decodedBody = json.decode(res.body);
    return decodedBody.map((val) => userCategory.fromJSON(val)).toList();
  }

  Future<Meetup> fetchMeetupById(String id) async {
    final res = await http.get(Uri.parse("$url/meetups/$id"));
    final parsedMeetup = json.decode(res.body);
    return Meetup.fromJSON(parsedMeetup);
  }

  Future<String> createMeetup(MeetupFormData formData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final body = json.encode(formData.toJSON());
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final res = await http.post(Uri.parse('$url/meetups'), headers: headers, body: body);

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return Future.error(res.body);
    }
  }

  Future<List<Thread>> fetchThreads(String meetupId) async {
    final res = await http.get(Uri.parse('$url/threads?meetupId=$meetupId'));
    final Map<String, dynamic> parsedBody = json.decode(res.body);
    List<dynamic> parsedThreads = parsedBody['threads'];
    return parsedThreads.map((val) => Thread.fromJSON(val)).toList();
  }

  Future<bool> joinMeetup(String meetupId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      await http.post(Uri.parse('$url/meetups/$meetupId/join'),
          headers: {'Authorization': 'Bearer $token'});
      return true;
    } catch (e) {
      throw Exception('Cannot join meetup!');
    }
  }

  Future<bool> leaveMeetup(String meetupId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      await http.post(Uri.parse('$url/meetups/$meetupId/leave'),
          headers: {'Authorization': 'Bearer $token'});
      return true;
    } catch (e) {
      throw Exception('Cannot leave meetup!');
    }
  }
}
