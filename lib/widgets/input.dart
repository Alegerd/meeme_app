import 'package:flutter/material.dart';
import 'package:meeme_app/const/const.dart';

class InputWidget {
  static Widget createInput(String hint, TextEditingController textController,
      bool obscure) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: textController,
          obscureText: obscure,
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            hintStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 20,
                color: Colors.black38),
            hintText: hint,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.mainColor, width: 1)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.mainColor, width: 1)),
          ),
        )
    );
  }
}