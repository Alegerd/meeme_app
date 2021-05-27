import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:meeme_app/model/user.dart';
import 'package:meeme_app/services/auth.dart';
import 'package:uuid/uuid.dart';

class EditProfileView extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  File file;
  AppUser localUser;
  selectImage(BuildContext parentContext) async {
    return showDialog<Null>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  PickedFile imageFile = await imagePicker.getImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  file = File(imageFile.path);
                  String imageUrl = await uploadImage(file);
                  applyNewPhoto(imageUrl);
                }),
            SimpleDialogOption(
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  PickedFile imageFile = await imagePicker.getImage(
                      source: ImageSource.gallery,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  file = File(imageFile.path);
                  String imageUrl = await uploadImage(file);
                  applyNewPhoto(imageUrl);
                }),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Future<String> uploadImage(var imageFile) async {
    var id = Uuid().v1();
    Reference ref = FirebaseStorage.instance.ref().child("post_$id.jpg");
    UploadTask uploadTask = ref.putFile(imageFile);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  applyChanges() {
    FirebaseFirestore.instance.collection('users').doc(localUser.id).update({
      "name": nameController.text
      // "bio": bioController.text,
    });
  }

  applyNewPhoto(String photoUrl) {
    FirebaseFirestore.instance.collection('users').doc(localUser.id).update({
      "profileImageUrl": photoUrl
      // "bio": bioController.text,
    });
  }

  Widget buildTextField({String name, TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            name,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: name,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    localUser = Provider.of<AppUser>(context);
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(localUser.id)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());

          localUser = AppUser.fromDocument(snapshot.data);

          nameController.text = localUser.firstName;
          // bioController.text = user.bio;

          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(localUser.profileImageUrl),
                  radius: 50.0,
                ),
              ),
              FlatButton(
                  onPressed: () {
                    selectImage(context);
                  },
                  child: Text(
                    "Change Photo",
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  )),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    buildTextField(name: "Name", controller: nameController)
                  ],
                ),
              )
            ],
          );
        });
  }

  void _logout(BuildContext context) async {
    await AuthenticationService().logout();
  }
}
