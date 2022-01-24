import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetuper_app/models/meetup.dart';
import 'package:meetuper_app/services/auth_api_service.dart';
import 'package:meetuper_app/services/meetup_api_service.dart';
import 'package:meetuper_app/screens/meetup_detail_screen.dart';

class MeetupDetailArguments {
  final String id;

  MeetupDetailArguments({required this.id});
}

class MeetupHomeScreen extends StatefulWidget {
  final MeetupApiService _api = MeetupApiService();
  static final route = '/homescreen';
  MeetupHomeScreenState createState() => MeetupHomeScreenState();
}

class MeetupHomeScreenState extends State<MeetupHomeScreen> {
  List<Meetup> meetups = [];

  @override
  initState() {
    super.initState();
    _fetchMeetups();
  }

  _fetchMeetups() async {
    final meetups = await widget._api.fetchMeetups();
    setState(() => this.meetups = meetups);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _MeetupTitle(),
          _MeetupList(meetups: meetups)
        ],
      ),
      appBar: AppBar(title: Text('Home')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _MeetupTitle extends StatelessWidget {
  final AuthApiService auth = AuthApiService();

  Widget _buildUserWelcome() {
    return FutureBuilder(future: auth.isAuthenticated(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            final user = auth.GetauthUser;
            return Container(
              margin: EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  user.avatar != null
                      ? CircleAvatar(
                    backgroundImage: NetworkImage(user.avatar),
                  )
                      : Container(
                    height: 0,
                    width: 0,
                  ),
                  Text(' Welcome ${user?.name} !'),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      auth.logout()
                          .then((isLogout) =>
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (Route<
                              dynamic> route) => false));
                    },
                    child: Text(
                        'Logout',
                        style: TextStyle(
                            color: Theme
                                .of(context)
                                .primaryColor
                        )
                    ),
                  )
                ],
              ),
            );
          }
          else {
            return Container(width: 0, height: 0);
          }
        }
    );
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(

              'Featured Meetup',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600,)),
          _buildUserWelcome()
        ],
      ),
    );
  }
}

class _MeetupCard extends StatelessWidget {
  final Meetup meetup;

  _MeetupCard({required this.meetup});

  Widget build(BuildContext context) {
    return Card(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(meetup.image),
            ),
            title: Text(meetup.title),
            subtitle: Text(meetup.description)),
        ButtonTheme(
            child: ButtonBar(
          children: <Widget>[
            TextButton(
                child: Text('Visit Meetup'),
                onPressed: () {
                  Navigator.pushNamed(context, MeetupDetailScreen.route,
                      arguments: MeetupDetailArguments(id: meetup.id));
                }),
            TextButton(child: Text('Favorite'), onPressed: () {})
          ],
        ))
      ],
    ));
  }
}

class _MeetupList extends StatelessWidget {
  final List<Meetup> meetups;

  _MeetupList({required this.meetups});

  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
      itemCount: meetups.length * 2,
      itemBuilder: (BuildContext context, int i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;

        return _MeetupCard(meetup: meetups[index]);
      },
    ));
  }
}
