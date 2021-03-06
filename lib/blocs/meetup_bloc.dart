import 'package:flutter/material.dart';
import 'dart:async';

import 'package:meetuper_app/blocs/bloc_provider.dart';
import 'package:meetuper_app/models/meetup.dart';
import 'package:meetuper_app/models/thread.dart';
import 'package:meetuper_app/models/user.dart';
import 'package:meetuper_app/services/auth_api_service.dart';
import 'package:meetuper_app/services/meetup_api_service.dart';
import 'package:rxdart/rxdart.dart';

class MeetupBloc implements BlocBase {
  final MeetupApiService _api = MeetupApiService();
  final AuthApiService _auth = AuthApiService();

  final StreamController<List<Meetup>> _meetupController = StreamController.broadcast();
  Stream<List<Meetup>> get meetups => _meetupController.stream;
  StreamSink<List<Meetup>> get _inMeetups => _meetupController.sink;

  final BehaviorSubject<Meetup> _meetupDetailController = BehaviorSubject();
  Stream<Meetup> get meetup => _meetupDetailController.stream;
  StreamSink<Meetup> get _inMeetup => _meetupDetailController.sink;

  final BehaviorSubject<List<Thread>> _threadSubject = BehaviorSubject();
  Stream<List<Thread>> get threads => _threadSubject.stream;
  StreamSink<List<Thread>> get _inThreads => _threadSubject.sink;

  void fetchMeetups() async {
    final meetups = await _api.fetchMeetups();
    _inMeetups.add(meetups);
  }

  void fetchMeetup(String meetupId) async {
    final meetup = await _api.fetchMeetupById(meetupId);
    _inMeetup.add(meetup);
  }

  void fetchThreads(String meetupId) async {
    final threads = await _api.fetchThreads(meetupId);
    _inThreads.add(threads);
  }

  void joinMeetup(Meetup meetup) {
    _api.joinMeetup(meetup.id).then((_) {
      User user = _auth.GetauthUser;
      user.joinedMeetups.add(meetup.id);

      meetup.joinedPeople.add(user);
      meetup.joinedPeopleCount++;
      _inMeetup.add(meetup);
    }).catchError((err) => print(err));
  }

  Future<bool> leaveMeetup(Meetup meetup) {
    return _api.leaveMeetup(meetup.id).then((_) {
      User user = _auth.GetauthUser;
      user.joinedMeetups.removeWhere((jMeetup) => jMeetup == meetup.id);

      meetup.joinedPeople.removeWhere((jUser) => jUser.id == user.id);
      meetup.joinedPeopleCount--;
      _inMeetup.add(meetup);
      return true;
    }).catchError((err) {
      print(err);
      return false;
    });
  }

  void dispose() {
    _meetupController.close();
    _meetupDetailController.close();
    _threadSubject.close();
  }
}
