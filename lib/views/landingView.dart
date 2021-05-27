import 'package:flutter/material.dart';
import 'package:meeme_app/views/onboardingView.dart';
import 'package:provider/provider.dart';
import 'package:meeme_app/model/user.dart';
import 'package:meeme_app/views/mainView.dart';

class LandingView extends StatelessWidget {
  LandingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppUser user = Provider.of<AppUser>(context);
    final bool _isLogged = user != null;
    return _isLogged ? MainView() : OnboardingView();
  }
}
