import 'package:flutter/material.dart';
import 'package:meetuper_app/models/arguments.dart';
import 'package:meetuper_app/models/forms.dart';
import 'package:meetuper_app/regulation/member_benefits.dart';
import 'package:meetuper_app/regulation/terms_of_service.dart';
import 'package:meetuper_app/screens/login_screen.dart';
import 'package:meetuper_app/screens/meetup_home_screen.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/gestures.dart';
import 'package:meetuper_app/screens/start_app_screen.dart';
import 'package:meetuper_app/services/auth_api_service.dart';
import 'package:meetuper_app/utils/jwt.dart';

import 'package:flutter/services.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static final String route = '/register';
  final authApi = AuthApiService();
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool agree = false;
  bool _isObscure = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  RegisterFormData _registerData = RegisterFormData();

  void _handleSuccess(data) {

    Future.delayed(Duration(seconds: 3),(){
      snackbar('You have been successfully registered. Feel free to log in.', context, 2000);
      setState(() {
        Navigator.pushNamedAndRemoveUntil(
            context, '/login', (Route<
            dynamic> route) => false);
      });
    });
  }

  void _handleError(error) {
    print(error['errors']['message']);
    snackbar(error['errors']['message'], context,500);
  }

  void _register() {
    widget.authApi
        .register(_registerData)
        .then(_handleSuccess)
        .catchError(_handleError);
    print('ok');
  }

  validator() {
    if (agree == true) {
      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
        print("Validated");
        _formKey.currentState?.save();

        // print(_registerData.toJSON());
        snackbar("Validated", context,500);

        _register();
      } else {
        // return
          // null;
          snackbar("Not Validated", context,500);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, StartScreen.route),
                    alignment: Alignment.centerLeft,
                    icon: Icon(Icons.close),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 28.0, right: 28, top: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Sign Up',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 24),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            decoration: const InputDecoration(
                                icon: Icon(Icons.camera_front),
                                hintText: 'Please input your picture link',
                                labelText: 'Avatar'),
                            onSaved: (value) => _registerData.avatar = value!,
                            keyboardType: TextInputType.url
                        ),
                        TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("^[a-zA-Z ]*")),
                          ],
                          validator: (String? value) {
                            if (value == null || value.trim().length == 0) {
                              return "Field is required";
                            }
                            if (value.length <= 6) {
                              return "Name should not be less than 6 characters";
                            }
                            if (value.length >= 20) {
                              return "Name should not be more than 20 characters";
                            }

                            return null;
                          },
                          onSaved: (value) => _registerData.name = value!,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: 'Please input your name',
                              labelText: 'Name'),
                        ),
                        TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("^[A-Za-z0-9_-]*")),
                          ],
                          validator: (String? value) {
                            if (value == null || value.trim().length == 0) {
                              return "Field is required";
                            }
                            if (value.length <= 6) {
                              return "Username should not be less than 6 characters";
                            }
                            if (value.length >= 20) {
                              return "Name should not be more than 20 characters";
                            }
                            return null;
                          },
                          onSaved: (value) => _registerData.username = value!,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.account_circle),
                              hintText: 'Please input your username',
                              labelText: 'Username'),
                        ),
                        TextFormField(
                          validator: (String? value) {
                            if (value == null || value.trim().length == 0) {
                              return "Field is required";
                            }
                            if (!RegExp(
                                r"^([a-zA-Z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+\/=?^_`{|}"
                                r"~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:"
                                r"[a-zA-Z0-9-]*[a-zA-Z0-9])?)$")
                                .hasMatch(value)) {
                              return "Please Enter valid email address";
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) => _registerData.email = value!,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              hintText: 'Please input your email',
                              labelText: 'Email'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (String? value) {
                            if (value == null || value.trim().length == 0) {
                              return "Field is required";
                            }
                            if (value.length <= 6) {
                              return "Password should not be less then 6 characters";
                            }
                            return null;
                          },
                          onSaved: (value) => _registerData.password = value!,
                          obscureText: _isObscure,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.password),
                              hintText: 'Please input your password',
                              labelText: 'Password'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (String? value) {
                            if (value == null || value.trim().length == 0) {
                              return "Field is required";
                            }
                            if (value.length <= 6) {
                              return "Password should not be less then 6 characters";
                            }
                            return null;
                          },
                          onSaved: (value) =>
                          _registerData.passwordConfirmation = value!,
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                              icon: Icon(Icons.password),
                              hintText: 'Please input your password',
                              labelText: 'Password Confirmation',
                              suffixIcon: IconButton(
                                icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                              })),

                        ),

                        SizedBox(
                          height: 20,
                        ),
                        _buildRegulation(),
                        ElevatedButton(
                          onPressed:
                          // validator(),
                          agree ? () => validator() : null,
                          child: Text('Sign Up'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  _buildSignInOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegulation(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: agree,
          onChanged: (value) {
            setState(() {
              agree = value ?? false;
            });
          },
        ),
        Expanded(
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "I have read and accept",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                        text: ' Member Benefits',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                        new TapGestureRecognizer()
                          ..onTap = () =>
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder:
                                          (context) {
                                        return MemberBenefitsScreen();
                                      }))),
                    TextSpan(
                      text: ' and ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                        text: ' Terms of Service',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                        new TapGestureRecognizer()
                          ..onTap = () =>
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder:
                                          (context) {
                                        return TermsOfServiceScreen();
                                      }))),
                  ])),
        ),
      ],
    );
  }

  Widget _buildSignInOption(){
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
              text: TextSpan(
                  text: "Have an account?",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                        text: ' Sign in ',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () => Navigator.pushNamed(
                              context, LoginScreen.route)),
                  ])),
          SizedBox(
            height: 5,
          ),
          Column(
            children: [
              Text(
                'Or using',
                style: TextStyle(color: Colors.black),
              ),
              SignInButton(
                Buttons.Google,
                text: "Sign in with Google",
                // shape: new RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20)),
                onPressed: () {},
              ),
              SignInButton(
                Buttons.Facebook,
                // shape: new RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20)),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
