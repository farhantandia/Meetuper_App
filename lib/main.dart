import 'package:flutter/material.dart';
import 'package:meetuper_app/blocs/bloc_provider.dart';
import 'package:meetuper_app/blocs/counter_bloc.dart';
import 'package:meetuper_app/other/counter_home_screen.dart';
import 'package:meetuper_app/screens/login_screen.dart';
import 'package:meetuper_app/screens/meetup_detail_screen.dart';
import 'package:meetuper_app/screens/meetup_home_screen.dart';
import 'package:meetuper_app/other/post_screen.dart';
import 'package:meetuper_app/other/app_state.dart';
import 'package:meetuper_app/screens/register_screen.dart';
import 'package:meetuper_app/screens/start_app_screen.dart';

import 'blocs/meetup_bloc.dart';
import 'models/arguments.dart';

void main() {
  runApp(const MeetuperApp());
}

class MeetuperApp extends StatelessWidget {
  const MeetuperApp({Key? key}) : super(key: key);
  final String appTitle = 'Meetuper App';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.teal,
          primaryColor: Colors.teal,),
        // home: BlocProvider<CounterBloc>(
        //   bloc: CounterBloc(),
        //   child: CounterHomeScreen(title: appTitle,),
    // ),
        home: StartScreen(),

        routes: {
          LoginScreen.route: (context) =>LoginScreen(),
          RegisterScreen.route: (context) =>RegisterScreen(),
          StartScreen.route: (context) => StartScreen(),
          MeetupHomeScreen.route: (context) =>BlocProvider<MeetupBloc>(
            bloc: MeetupBloc(),
            child: MeetupHomeScreen(),
          ),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name == MeetupDetailScreen.route) {
            final arguments = settings.arguments as MeetupDetailArguments;

            return
              MaterialPageRoute(
                builder: (context) => BlocProvider<MeetupBloc>(
                    bloc: MeetupBloc(),
                    child: MeetupDetailScreen(meetupId: arguments.id)
                )
            );
          }
        }
    );
  }
}