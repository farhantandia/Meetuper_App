import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:meetuper_app/screens/meetup_home_screen.dart';

import 'login_screen.dart';

class StartScreen extends StatefulWidget {
  static final String route = '/startscreen';

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/startscreen.jpg',
                ),
                fit: BoxFit.cover)),
        // Image.asset(
        // 'assets/startscreen.jpg',
        child: AnimatedBackground(
          behaviour: RandomParticleBehaviour(
              options: ParticleOptions(
                  baseColor: Colors.white,
                  spawnMaxSpeed: 150,
                  particleCount: 50)),
          vsync: this,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    Text('Welcome to',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontStyle: FontStyle.italic
                      ),
                    ),
                    Text('Meetuper',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontFamily: 'Lobster',
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, LoginScreen.route),
                        child: Text('LOG IN'),
                        style:
                            ElevatedButton.styleFrom(minimumSize: Size(20, 50)),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 3,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pushNamed(context, MeetupHomeScreen.route),
                        child: Text('AS GUEST'),

                        style: OutlinedButton.styleFrom(
                            minimumSize: Size(20, 50),
                            backgroundColor: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
