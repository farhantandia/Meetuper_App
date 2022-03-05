import 'dart:async';

import 'package:meetuper_app/blocs/user_bloc/states.dart';
import 'package:meetuper_app/models/meetup.dart';
import 'package:meetuper_app/models/user.dart';
import 'package:meetuper_app/services/auth_api_service.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc_provider.dart';
import 'events.dart';

class UserBloc extends BlocBase {
  AuthApiService auth;

  final BehaviorSubject<UserState> _userSubject = BehaviorSubject<UserState>();
  Stream<UserState> get userState => _userSubject.stream;
  StreamSink<UserState> get _inUserState => _userSubject.sink;

  UserBloc({required this.auth}) : assert(auth != null);

  void dispatch(UserEvent event) async {
    if (_isDisposed) {
      return;
    }
    await for (var state in _userStream(event)) {
      _inUserState.add(state);
    }
  }

  Stream<UserState> _userStream(UserEvent event) async* {
    if (event is CheckUserPermissionsOnMeetup) {
      final bool isAuth = await auth.isAuthenticated();
      if (isAuth) {
        final User user = auth.GetauthUser;
        final meetup = event.meetup;

        if (_isUserMeetupOwner(meetup, user)) {
          yield UserIsMeetupOwner();
          return;
        }

        if (_isUserJoinedInMeetup(meetup, user)) {
          yield UserIsMember();
        } else {
          yield UserIsNotMember();
        }
      } else {
        yield UserIsNotAuth();
      }
    }
    // Remove it after testing (:
    // if (event is JoinMeetup) {
    //   yield UserIsMember();
    // }

    // if (event is LeaveMeetup) {
    //   yield UserIsNotMember();
    // }
  }

  bool _isUserMeetupOwner(Meetup meetup, User user) {
    // Fix it in next lecture
    return user != null && meetup.meetupCreator?.id == user.id;
  }

  bool _isUserJoinedInMeetup(Meetup meetup, User user) {
    return user != null && user.joinedMeetups.isNotEmpty && user.joinedMeetups.contains(meetup.id);
  }

  bool _isDisposed = false;
  @override
  dispose() {
    _userSubject.close();

    _isDisposed = true;
  }
}
