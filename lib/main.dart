import 'package:flutter/material.dart';
import 'package:meetuper_app/blocs/bloc_provider.dart';
import 'package:meetuper_app/screens/login_screen.dart';
import 'package:meetuper_app/screens/meetup_create_screen.dart';
import 'package:meetuper_app/screens/meetup_detail_screen.dart';
import 'package:meetuper_app/screens/meetup_home_screen.dart';
import 'package:meetuper_app/screens/register_screen.dart';
import 'package:meetuper_app/screens/start_app_screen.dart';
import 'package:meetuper_app/services/auth_api_service.dart';

import 'blocs/auth_bloc/auth_bloc.dart';
import 'blocs/meetup_bloc.dart';
import 'blocs/user_bloc/user_bloc.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      bloc: AuthBloc(auth: AuthApiService()),
      child: MeetuperApp(),
    );
  }
}

class MeetuperApp extends StatefulWidget {
  @override
  State<MeetuperApp> createState() => _MeetuperAppState();
}

class _MeetuperAppState extends State<MeetuperApp> {
  final String appTitle = 'Meetuper App';
  AuthBloc? authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc?.dispatch(AppStarted());

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.teal,
          primaryColor: Colors.teal,
        ),
        debugShowCheckedModeBanner: false,
        // home: BlocProvider<CounterBloc>(
        //   bloc: CounterBloc(),
        //   child: CounterHomeScreen(title: appTitle,),
        // ),
        home: StreamBuilder<AuthenticationState>(
          stream: authBloc?.authState,
          initialData: AuthenticationUninitialized(),
          builder: (BuildContext context, AsyncSnapshot<AuthenticationState> snapshot) {
            final state = snapshot.data;

            if (state is AuthenticationUninitialized) {
              return LoadingScreen();
            }

            if (state is AuthenticationAuthenticated) {
              return BlocProvider<MeetupBloc>(bloc: MeetupBloc(), child: MeetupHomeScreen());
            }

            if (state is AuthenticationUnauthenticated) {
              return StartScreen();
            }

            if (state is AuthenticationLoading) {
              return LoadingScreen();
            } else {
              return StartScreen();
            }
          },
        ),
        routes: {
          MeetupCreateScreen.route: (context) => MeetupCreateScreen(),
          LoginScreen.route: (context) => LoginScreen(),
          RegisterScreen.route: (context) => RegisterScreen(),
          StartScreen.route: (context) => StartScreen(),
          MeetupHomeScreen.route: (context) => BlocProvider<MeetupBloc>(
                bloc: MeetupBloc(),
                child: MeetupHomeScreen(),
              ),
        },
        onUnknownRoute: (RouteSettings settings) {
          StartScreen();
        },
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name == MeetupDetailScreen.route) {
            final arguments = settings.arguments as MeetupDetailArguments;

            return MaterialPageRoute(
                builder: (context) => BlocProvider<MeetupBloc>(
                    bloc: MeetupBloc(),
                    child: BlocProvider<UserBloc>(
                        bloc: UserBloc(auth: AuthApiService()),
                        child: MeetupDetailScreen(meetupId: arguments.id))));
          }
        });
  }
}

class LoadingScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
