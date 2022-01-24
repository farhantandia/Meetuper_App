import 'package:flutter/material.dart';

class MemberBenefitsScreen extends StatelessWidget {
  const MemberBenefitsScreen({Key? key}) : super(key: key);
  static final route ='/memberbenefit';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: Colors.teal,
        title: Text('Member Benefits'),

        // actionsIconTheme: ,
      ),
      body:
      Center(
        child: Container(
          child: Text('Details of Member Benefits'),
        ),
      ),

      // bottomNavigationBar: BottomNavigation(),
    );
  }
}
