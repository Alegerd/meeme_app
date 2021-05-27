import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meeme_app/model/user.dart';
import 'package:meeme_app/services/auth.dart';
import 'package:meeme_app/services/database.dart';

class AccountView extends StatelessWidget {
  AccountView({Key key}) : super(key: key);
  AuthenticationService _authService = new AuthenticationService();

  @override
  Widget build(BuildContext context) {
    Widget _button() {
      return RaisedButton(
        splashColor: Colors.white,
        highlightColor: Colors.white,
        color: Colors.red,
        child: Text('LOGOUT',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        onPressed: () => {_authService.logout()},
      );
    }

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 43),
          FutureBuilder(
            future: DatabaseService().getUserName(Provider.of<AppUser>(context).id),
            builder: (_, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return Text(snapshot.data, style: TextStyle(fontSize: 20, color: Colors.black));
            },
          ),
          SizedBox(height: 43),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: _button(),
            ),
          )
        ],
      ),
    );
  }
}
