import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meeme_app/model/meeme.dart';
import 'package:meeme_app/model/meemeImage.dart';
import 'package:meeme_app/model/user.dart';

class DatabaseService
{
  final userCollectionReference =
  FirebaseFirestore.instance.collection('users');
  final imagesCollectionReference =
  FirebaseFirestore.instance.collection('images');
  final meemesCollectionReference =
  FirebaseFirestore.instance.collection('meemes');

  Future createUser(AppUser user) async {
    return await userCollectionReference
        .doc(user.id)
        .set(user.toMap());
  }

  Future createMeeme(Meeme meeme) async {
    return await meemesCollectionReference
        .doc(meeme.id)
        .set(meeme.toMap());
  }

  Future createImage(MeemeImage image) async {
    return await imagesCollectionReference
        .doc(image.id)
        .set(image.toMap());
  }

  Future<AppUser> getUser(String id) async {
    AppUser userFromDB;
    var snapshot = await userCollectionReference.doc(id).get();
    userFromDB = AppUser.fromJson(snapshot.data());
    return userFromDB;
  }

  Future<String> getUserName(String id) async {
    var userFromDB = await getUser(id);
    if (userFromDB != null) {
      return userFromDB.firstName;
    }
    return null;
  }

  Future<List<MeemeImage>> getMeemeImages() async {
    QuerySnapshot snapshot = await imagesCollectionReference.orderBy("createdAt").get();
    return snapshot.docs
        .map((doc) => MeemeImage.fromJson(doc.id, doc.data()))
        .toList();
  }

  Future<List<Meeme>> getMeemes() async {
    QuerySnapshot snapshot = await meemesCollectionReference.orderBy("createdAt").get();
    return snapshot.docs
        .map((doc) => Meeme.fromJson(doc.id, doc.data()))
        .toList();
  }
}