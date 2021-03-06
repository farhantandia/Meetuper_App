import 'package:flutter/material.dart';
import 'package:meetuper_app/blocs/bloc_provider.dart';
import 'package:meetuper_app/blocs/meetup_bloc.dart';
import 'package:meetuper_app/blocs/user_bloc/events.dart';
import 'package:meetuper_app/blocs/user_bloc/states.dart';
import 'package:meetuper_app/blocs/user_bloc/user_bloc.dart';
import 'package:meetuper_app/models/meetup.dart';
import 'package:meetuper_app/services/auth_api_service.dart';
import 'package:meetuper_app/services/meetup_api_service.dart';
import 'package:meetuper_app/widgets/bottom_navigation_bar.dart';
import 'package:meetuper_app/widgets/joined_people_list.dart';
import 'package:meetuper_app/widgets/thread_list.dart';

import 'package:intl/intl.dart';

enum Views { detailView, threadView, peopleView }

class MeetupDetailScreen extends StatefulWidget {
  static final String route = '/meetupDetail';
  final String meetupId;
  final MeetupApiService api = MeetupApiService();

  MeetupDetailScreen({required this.meetupId});

  @override
  MeetupDetailScreenState createState() => MeetupDetailScreenState();
}

class MeetupDetailScreenState extends State<MeetupDetailScreen> {
  MeetupBloc? _meetupBloc;
  UserBloc? _userBloc;
  Meetup? _meetup;
  int screenIndex = 0;

  bool _isActiveView(Views view) {
    return view.index == screenIndex;
  }

  void initState() {
    _meetupBloc = BlocProvider.of<MeetupBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);

    _meetupBloc?.fetchMeetup(widget.meetupId);
    _meetupBloc?.meetup.listen((meetup) {
      _meetup = meetup;
      _userBloc?.dispatch(CheckUserPermissionsOnMeetup(meetup: meetup));
    });

    super.initState();
  }

  _joinMeetup() {
    _meetupBloc?.joinMeetup(_meetup!);
  }

  _leaveMeetup() {
    _meetupBloc?.leaveMeetup(_meetup!).then((_) {
      if (screenIndex != 0) {
        screenIndex = 0;
      }
    });
  }

  Widget build(BuildContext context) {
    return StreamBuilder<UserState>(
        stream: _userBloc?.userState,
        initialData: UserInitialState(),
        builder: (BuildContext context, AsyncSnapshot<UserState> snapshot) {
          final userState = snapshot.data;
          return Scaffold(
            body: Builder(builder: (BuildContext context) {
              if (_isActiveView(Views.detailView)) {
                return StreamBuilder<Meetup>(
                  stream: _meetupBloc?.meetup,
                  builder: (BuildContext context, AsyncSnapshot<Meetup> snapshot) {
                    if (snapshot.hasData) {
                      final meetup = snapshot.data;
                      return ListView(
                        children: <Widget>[
                          HeaderSection(meetup: meetup),
                          TitleSection(meetup: meetup),
                          AdditionalInfoSection(meetup: meetup),
                          Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(meetup!.description)))
                        ],
                      );
                    } else {
                      return Container(width: 0, height: 0);
                    }
                  },
                );
              }
              if (_isActiveView(Views.threadView)) {
                _meetupBloc?.fetchThreads(_meetup!.id);
                return ThreadList(bloc: _meetupBloc!);
              }

              if (_isActiveView(Views.peopleView)) {
                return JoinedPeopleList(bloc: _meetupBloc!);
              } else {
                return Container(width: 0, height: 0);
              }
            }),
            appBar: AppBar(title: Text('Meetup Detail')),
            bottomNavigationBar: BottomNavigation(
                onChange: (i) => setState(() => screenIndex = i),
                userState: userState,
                currentIndex: screenIndex),
            floatingActionButton: _MeetupActionButton(
                userState: userState, joinMeetup: _joinMeetup, leaveMeetup: _leaveMeetup),
          );
        });
  }
}

class _MeetupActionButton extends StatelessWidget {
  final Function() joinMeetup;
  final Function() leaveMeetup;

  final UserState? userState;
  _MeetupActionButton(
      {required this.userState, required this.joinMeetup, required this.leaveMeetup});
  final AuthApiService auth = AuthApiService();
  @override
  Widget build(BuildContext context) {
    if (userState is UserIsMember) {
      return FloatingActionButton(
        onPressed: leaveMeetup,
        child: Icon(Icons.cancel),
        backgroundColor: Colors.red,
        tooltip: 'Leave Meetup',
      );
    } else if (userState is UserIsNotMember) {
      return FloatingActionButton(
        onPressed: joinMeetup,
        child: Icon(Icons.person_add),
        backgroundColor: Colors.green,
        tooltip: 'Join Meetup',
      );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }
}

class HeaderSection extends StatelessWidget {
  Meetup? meetup;

  final dateFormat = DateFormat('dd/MM/yyyy');
  HeaderSection({required this.meetup});

  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        Image.network(meetup!.image, width: width, height: 240.0, fit: BoxFit.cover),
        Container(
            width: width,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(meetup!.meetupCreator!.avatar),
                ),
                title: Text(meetup!.meetupCreator!.name,
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white)),
                subtitle: Text(dateFormat.format(DateTime.parse(meetup!.createdAt)),
                    style: const TextStyle(
                        fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ))
      ],
    );
  }
}

class TitleSection extends StatelessWidget {
  Meetup? meetup;

  TitleSection({Key? key, required this.meetup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meetup!.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(meetup!.shortInfo, style: TextStyle(color: Colors.grey[500]))
                ],
              ),
            ),
            Icon(Icons.people, color: color, size: 25),
            Text(' ${meetup!.joinedPeopleCount} People', style: const TextStyle(fontSize: 17))
          ],
        ),
      ),
    );
  }
}

class AdditionalInfoSection extends StatelessWidget {
  Meetup? meetup;

  AdditionalInfoSection({Key? key, required this.meetup}) : super(key: key);

  String _capitilize(String word) {
    return (word != null && word.isNotEmpty) ? word[0].toUpperCase() + word.substring(1) : '';
  }

  Widget _buildColumn(String label, String text, Color color) {
    return Column(
      children: <Widget>[
        Text(label, style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color: color)),
        Text(_capitilize(text),
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500, color: color))
      ],
    );
  }

  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildColumn('CATEGORY', meetup!.category.name, color),
            _buildColumn('FROM', meetup!.timeFrom, color),
            _buildColumn('TO', meetup!.timeTo, color)
          ],
        ),
      ),
    );
  }
}
