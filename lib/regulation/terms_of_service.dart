import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  static final route ='/termsofbenefit';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 0,
        backgroundColor: Colors.teal,
        title: Text('Terms of Service'),

        // actionsIconTheme: ,
      ),
      body:
      Center(
        child: Container(
          child: Text('Details of Terms of Service'),
        ),
      ),

      // bottomNavigationBar: BottomNavigation(),
    );
  }
}
