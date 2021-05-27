import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meeme_app/views/meemesView.dart';
import 'package:meeme_app/views/profileView.dart';
import 'package:meeme_app/views/meemecreatorView.dart';

class MainView extends StatefulWidget {
  MainView({Key key}) : super(key: key);

  final List<Widget> screens = [
    new MeemesView(),
    new MeemeCreatorView(),
    new ProfileView()
  ];

  @override
  State<StatefulWidget> createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  File file;
  int _pageIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: new BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(Icons.wallpaper), title: new Text('Meemes')),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.add_a_photo),
                title: new Text('Add meeme')),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.account_box_rounded),
                title: new Text('Profile'))
          ],
          onTap: (int index) {
            setState(() {
              _pageIndex = index;
            });
          },
          currentIndex: _pageIndex,
        ),
        body: IndexedStack(
          index: _pageIndex,
          children: widget.screens,
        ));
  }
}
