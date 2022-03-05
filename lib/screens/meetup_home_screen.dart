import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetuper_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:meetuper_app/blocs/bloc_provider.dart';
import 'package:meetuper_app/blocs/meetup_bloc.dart';
import 'package:meetuper_app/models/meetup.dart';
import 'package:meetuper_app/screens/meetup_create_screen.dart';
import 'package:meetuper_app/screens/register_screen.dart';
import 'package:meetuper_app/services/auth_api_service.dart';
import 'package:meetuper_app/screens/meetup_detail_screen.dart';

import 'login_screen.dart';

class MeetupDetailArguments {
  final String id;

  MeetupDetailArguments({required this.id});
}

class MeetupHomeScreen extends StatefulWidget {
  static const route = '/homescreen';

  MeetupHomeScreen({Key? key}) : super(key: key);
  MeetupHomeScreenState createState() => MeetupHomeScreenState();
}

class MeetupHomeScreenState extends State<MeetupHomeScreen> {
  List<Meetup> meetups = [];

  AuthBloc? authBloc;

  void initState() {
    BlocProvider.of<MeetupBloc>(context)?.fetchMeetups();
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  _showBottomMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => _ModalBottomSheet(authBloc: authBloc!));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_MeetupTitle(authBloc: authBloc), _MeetupList()],
      ),
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _showBottomMenu(context),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, MeetupCreateScreen.route);
        },
      ),
    );
  }
}

class _ModalBottomSheet extends StatelessWidget {
  final AuthBloc authBloc;
  final AuthApiService auth = AuthApiService();
  _ModalBottomSheet({required this.authBloc}) : assert(authBloc != null);

  Widget build(BuildContext context) {
    return StreamBuilder<AuthenticationState>(
        stream: authBloc.authState,
        initialData: AuthenticationUninitialized(),
        builder: (BuildContext context, AsyncSnapshot<AuthenticationState> snapshot) {
          final state = snapshot.data;

          if (state is AuthenticationUninitialized) {
            return Container(width: 0, height: 0);
          }

          if (state is AuthenticationAuthenticated) {
            return Container(
              height: 150.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.photo_album),
                    title: Text('Create Meetup'),
                    onTap: () => {
                      Navigator.pushNamed(
                          context, MeetupCreateScreen.route)
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () => auth.logout().then((isLogout) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.route, ModalRoute.withName('/'));
                      authBloc.dispatch(LoggedOut());
                    }),
                  )
                ],
              ),
            );
          }

          if (state is AuthenticationUnauthenticated) {
            return Container(
              height: 150.0,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: new Icon(Icons.person),
                    title: new Text('Login'),
                    onTap: () => {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.route, ModalRoute.withName(MeetupHomeScreen.route))
                    },
                  ),
                  ListTile(
                    leading: new Icon(Icons.app_registration),
                    title: new Text('Register'),
                    onTap: () => {
                      Navigator.pushNamedAndRemoveUntil(context, RegisterScreen.route,
                          ModalRoute.withName(MeetupHomeScreen.route))
                    },
                  )
                ],
              ),
            );
          } else {
            return Container(
              width: 0,
              height: 0,
            );
          }
        });
  }
}

class _MeetupTitle extends StatelessWidget {
  final AuthApiService auth = AuthApiService();
  AuthBloc? authBloc;

  _MeetupTitle({required this.authBloc});
  Widget _buildUserWelcome() {
    return FutureBuilder(
        future: auth.isAuthenticated(),
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
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      auth.logout().then((isLogout) => authBloc?.dispatch(LoggedOut()));
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (Route<dynamic> route) => false);
                    },
                    child: Text('Logout', style: TextStyle(color: Theme.of(context).primaryColor)),
                  )
                ],
              ),
            );
          } else {
            return Container(width: 0, height: 0);
          }
        });
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text('Featured Meetup',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
              )),
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
            subtitle: Text(meetup.shortInfo)),
        ButtonTheme(
            child: ButtonBar(
          children: <Widget>[
            TextButton(
                child: const Text('Visit Meetup'),
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
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder<List<Meetup>>(
      stream: BlocProvider.of<MeetupBloc>(context)?.meetups,
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<Meetup>> snaphot) {
        var meetups = snaphot.data;
        if (meetups != null) {
          return ListView.builder(
            itemCount: meetups.length * 2,
            itemBuilder: (BuildContext context, int i) {
              if (i.isOdd) return Divider();
              final index = i ~/ 2;

              return _MeetupCard(meetup: meetups[index]);
            },
          );
        }
        return Text("");
      },
    ));
  }
}
