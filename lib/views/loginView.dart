import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meeme_app/model/user.dart';
import 'package:meeme_app/services/auth.dart';
import 'package:meeme_app/services/database.dart';
import 'package:meeme_app/const/const.dart';
import 'package:meeme_app/widgets/input.dart';

class LoginView extends StatefulWidget {
  LoginView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  String _email;
  String _password;
  String _name;
  bool showLogin = true;

  AuthenticationService _authService = AuthenticationService();

  Widget _button(String label, void onPress()) {
    return RaisedButton(
      splashColor: Theme.of(context).primaryColor,
      highlightColor: Theme.of(context).primaryColor,
      color: AppColors.mainColor,
      child: Text(label,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      onPressed: () => {onPress()},
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _form(String label, void onPress()) {
      return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 50),
              child: Text(
                "Meeme App",
                style: TextStyle(
                    color: AppColors.mainColor,
                    fontSize: 50.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child: InputWidget.createInput("Email", _emailController, false),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20, top: 10),
              child: InputWidget.createInput(
                  "password", _passwordController, true),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: _button(label, onPress),
              ),
            )
          ],
        ),
      );
    }

    void _loginUser() async {
      _email = _emailController.text;
      _password = _passwordController.text;

      if (_email.isEmpty || _password.isEmpty) {
        return;
      }

      AppUser user = await _authService.signInWithEmailAndPassword(
          _email.trim(), _password.trim());
      if (user == null) {
        Fluttertoast.showToast(
            msg: "Can't sign in. Invalid email or password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: AppColors.mainColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        _emailController.clear();
        _passwordController.clear();
        Navigator.of(context).popAndPushNamed("/Main");
      }
    }

    void _signUpUser() async {
      _email = _emailController.text;
      _password = _passwordController.text;
      _name = _nameController.text;
      if (_email.isEmpty || _password.isEmpty || _name.isEmpty) {
        Fluttertoast.showToast(
            msg: "Can't sign up. Please fill all fields",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: AppColors.mainColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      AppUser user = await _authService.signUpWithEmailAndPassword(
          _email.trim(), _password.trim());

      if (user == null) {
        Fluttertoast.showToast(
            msg: "Invalid email or password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: AppColors.mainColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        _emailController.clear();
        _passwordController.clear();
        Navigator.of(context).popAndPushNamed("/Main");
      }
      user.firstName = _name;
      DatabaseService().createUser(user);
    }

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 43),
          (showLogin
              ? Column(
                  children: <Widget>[
                    _form("login", _loginUser),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        child: Text(
                          "Don't have an account? Sign up.",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        onTap: () {
                          setState(() {
                            showLogin = false;
                          });
                        },
                      ),
                    )
                  ],
                )
              : Column(
                  children: <Widget>[
                    _form("Sign Up", _signUpUser),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20, top: 10),
                      child: InputWidget.createInput(
                          "Name", _nameController, false),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        child: Text(
                          "Have an account? Login.",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        onTap: () {
                          setState(() {
                            showLogin = true;
                          });
                        },
                      ),
                    )
                  ],
                ))
        ],
      ),
    );
  }
}
