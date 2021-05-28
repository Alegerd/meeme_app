import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meeme_app/const/const.dart';

class GotoSingUpWidget extends StatelessWidget {
  const GotoSingUpWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            splashColor: Theme.of(context).primaryColor,
            highlightColor: Theme.of(context).primaryColor,
            color: AppColors.mainColor,
            child: Text("Login or Sign Up",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            onPressed: () => { goToSignUp(context) },
          ),
        ],
      ),
    );
  }

  void goToSignUp(BuildContext context) {
    Navigator.of(context).popAndPushNamed("/SignUp");
  }
}
