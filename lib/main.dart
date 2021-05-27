import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meeme_app/views/landingView.dart';
import 'package:meeme_app/views/loginView.dart';
import 'package:meeme_app/views/mainView.dart';
import 'package:meeme_app/services/auth.dart';

import 'model/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MeemeApp());
}

class MeemeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser>.value(
      value: AuthenticationService().currentUser,
      child: MaterialApp(
        routes: <String, WidgetBuilder>
        {
          "/SignUp": (BuildContext context) => new LoginView(),
          "/Main": (BuildContext context) => new MainView()
        },
        title: 'Meeme App',
        home: LandingView(),
      ),
    );
  }

}