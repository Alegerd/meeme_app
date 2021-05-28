import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meeme_app/widgets/goto_signup_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:meeme_app/model/meemeImage.dart';
import 'package:meeme_app/model/user.dart';
import 'package:meeme_app/model/meeme.dart';
import 'package:meeme_app/services/database.dart';
import 'package:uuid/uuid.dart';
import 'package:meeme_app/const/const.dart';
import 'package:meeme_app/widgets/input.dart';

class MeemeCreatorView extends StatefulWidget {
  MeemeCreatorView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MeemeCreatorViewState();
}

class MeemeCreatorViewState extends State<MeemeCreatorView>
    with AutomaticKeepAliveClientMixin<MeemeCreatorView> {
  File file;
  ImagePicker imagePicker = ImagePicker();
  bool uploading = false;
  AppUser user;
  List<MeemeImage> loadedImages;
  List<MeemeImage> meemeImages;
  MeemeImage selectedImage;
  TextEditingController _meemeTextController = TextEditingController();

  _getMeemeImages() async {
    loadedImages = await DatabaseService().getMeemeImages();
    setState(() {
      meemeImages = loadedImages;
      selectedImage = loadedImages[0];
    });
  }

  Widget _buildSwiperList(MeemeImage image, int index) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.network(image.imageUrl, fit: BoxFit.cover)),
    );
  }

  buildSwiper() {
    if (meemeImages != null) {
      return Swiper(
        itemBuilder: (BuildContext context, int index) {
          return _buildSwiperList(meemeImages[index], index);
        },
        itemCount: meemeImages.length,
        itemWidth: MediaQuery.of(context).size.width,
        itemHeight: MediaQuery.of(context).size.height * 0.5,
        layout: SwiperLayout.TINDER,
        onIndexChanged: changeSelectedImage,
      );
    } else {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AppUser>(context);
    if (user == null)
      return GotoSingUpWidget();

    _getMeemeImages();
    super.build(context);

    return file == null
        ? Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: 2, top: 2),
                        child: buildSwiper()),
                    Padding(
                        padding: EdgeInsets.only(bottom: 2, top: 30),
                        child: InputWidget.createInput(
                            "Funny text", _meemeTextController, false)),
                    Padding(
                      padding: EdgeInsets.only(bottom: 2, top: 2),
                      child: RaisedButton(
                        splashColor: Theme.of(context).primaryColor,
                        highlightColor: Theme.of(context).primaryColor,
                        color: AppColors.mainColor,
                        child: Text("Create Meeme",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        onPressed: () => {_createMeeme(context)},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 2, top: 2),
                      child: RaisedButton(
                        splashColor: Theme.of(context).primaryColor,
                        highlightColor: Theme.of(context).primaryColor,
                        color: AppColors.mainColor,
                        child: Text("Create Meeme With Your Photo",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        onPressed: () => {_selectImage(context)},
                      ),
                    ),
                  ],
                )),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.white70,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: clearImage),
              title: const Text(
                'New Meeme',
                style: const TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: postMeeme,
                    child: Text(
                      "Create",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ))
              ],
            ),
            body: ListView(
              children: <Widget>[
                PostForm(
                  imageFile: file,
                  loading: uploading,
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 2),
                    child: InputWidget.createInput(
                        "Funny text", _meemeTextController, false))
              ],
            ));
  }

  changeSelectedImage(int newImageIndex) async {
    selectedImage = meemeImages[newImageIndex];
  }

  _createMeeme(BuildContext parentContext) async {
    Map<String, bool> likes = Map();
    DatabaseService().createMeeme(Meeme.fromParameters(
        Uuid().v1(),
        selectedImage.imageUrl,
        _meemeTextController.text,
        user.id,
        likes,
        DateTime.now()));
    Navigator.of(context).popAndPushNamed("/Main");
  }

  _selectImage(BuildContext parentContext) async {
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
                  setState(() {
                    file = File(imageFile.path);
                  });
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
                  setState(() {
                    file = File(imageFile.path);
                  });
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

  void postMeeme() {
    setState(() {
      uploading = true;
    });
    uploadMeeme(file).then((String data) {
      postToFireStore(data);
    }).then((_) {
      setState(() {
        file = null;
        uploading = false;
      });
    });
    Navigator.of(context).popAndPushNamed("/Main");
  }

  void postToFireStore(String mediaUrl) async {
    Map<String, bool> likes = Map();
    likes.putIfAbsent(user.id, () => false);
    DatabaseService().createMeeme(Meeme.fromParameters(
        Uuid().v1(), mediaUrl, _meemeTextController.text, user.id, likes, DateTime.now()));
  }

  void clearImage() {
    setState(() {
      file = null;
    });
  }

  Future<String> uploadMeeme(var imageFile) async {
    var id = Uuid().v1();
    Reference ref = FirebaseStorage.instance.ref().child("meeme_$id.jpg");
    UploadTask uploadTask = ref.putFile(imageFile);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  bool get wantKeepAlive => true;
}

class PostForm extends StatelessWidget {
  final imageFile;
  final bool loading;

  PostForm({this.imageFile, this.loading});

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        loading
            ? LinearProgressIndicator()
            : Padding(padding: EdgeInsets.only(top: 0.0)),
        Divider(),
        Container(
            height: 360,
            width: 360,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fill,
              alignment: FractionalOffset.topCenter,
              image: FileImage(imageFile),
            ))),
        Divider()
      ],
    );
  }
}
