import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meetuper_app/models/category.dart';
import 'package:meetuper_app/models/user.dart';

class Meetup {
  final String id;
  final String processedLocation;
  final String location;
  final String title;
  final String image;
  final String description;
  final String shortInfo;
  final userCategory category;
  final String startDate;
  final String timeFrom;
  final String timeTo;
  final String createdAt;
  final String updatedAt;
  int joinedPeopleCount;
  final User? meetupCreator;
  final List<User> joinedPeople;

  Meetup.fromJSON(Map<String, dynamic> parsedJson)
      : id = parsedJson['_id'],
        location = parsedJson['location'] ?? '',
        processedLocation = parsedJson['processedLocation'] ?? '',
        title = parsedJson['title'] ?? '',
        image = parsedJson['image'] ?? '',
        description = parsedJson['description'] ?? '',
        shortInfo = parsedJson['shortInfo'] ?? '',
        startDate = parsedJson['startDate'] ?? '',
        timeFrom = parsedJson['timeFrom'] ?? '',
        timeTo = parsedJson['timeTo'] ?? '',
        joinedPeopleCount = parsedJson['joinedPeopleCount'] ?? 0,
        createdAt = parsedJson['createdAt'] ?? '',
        updatedAt = parsedJson['updatedAt'] ?? '',
        category = userCategory.fromJSON(parsedJson['category']),
        meetupCreator = User.fromJSON(parsedJson['meetupCreator']),
        joinedPeople =
            parsedJson['joinedPeople'].map<User>((json) => User.fromJSON(json)).toList() ?? [];
}
