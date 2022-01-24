import 'package:flutter/material.dart';
import 'package:meetuper_app/models/forms.dart';
import 'package:meetuper_app/screens/meetup_home_screen.dart';
import 'package:meetuper_app/screens/register_screen.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/gestures.dart';
import 'package:meetuper_app/screens/start_app_screen.dart';
import 'package:meetuper_app/services/auth_api_service.dart';
import 'package:meetuper_app/utils/jwt.dart';

class LoginScreen extends StatefulWidget {
  static final String route = '/login';
  final authApi = AuthApiService();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState<String>> _passwordKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _emailKey =
      GlobalKey<FormFieldState<String>>();

  LoginFormData _loginData = LoginFormData();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  initState() {
    super.initState();

  }

  bool _isObscure = true;

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    widget.authApi.login(_loginData).then((value) {
      Navigator.pushNamed(context, MeetupHomeScreen.route);
      // print(value);
    }).catchError((error) {
      print(error['errors']['message']);
      snackbar(error['errors']['message'], context,500);
    });
  }

  validator() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      print("Validated");
      _formKey.currentState?.save();
      _login();
      return snackbar("Validated", context,500);
    } else {
      return snackbar("Not Validated", context,500);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
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
                      Center(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 24),
                        ),
                      ),
                      SizedBox(
                        height: 90,
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
                        key: _emailKey,
                        onSaved: (value) => _loginData.email = value,
                        controller: _emailController,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.email),
                            hintText: 'Please input your email',
                            labelText: 'User Email'),
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
                        controller: _passwordController,
                        key: _passwordKey,
                        onSaved: (value) => _loginData.password = value,
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
                                }))
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          validator();
                        },
                        child: Text('Log In'),
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
                _buildBottomOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomOption(){
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
                text: TextSpan(
                    text: "Forgot password?",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                          text: ' Recover here',
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () => Navigator.pushNamed(
                                context, RegisterScreen.route)),
                    ])),
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
            RichText(
                text: TextSpan(
                    text: "Don't have an account",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                          text: ' Sign up ',
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () => Navigator.pushNamed(
                                context, RegisterScreen.route)),
                    ]))
          ],
        ),
      ),
    );
  }
}
