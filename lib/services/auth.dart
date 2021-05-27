import 'package:meeme_app/model/user.dart';
import 'package:meeme_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService
{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<AppUser> signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      var user = result.user;
      return DatabaseService().getUser(AppUser.fromFireBase(user).id);
    } catch (e){
      print(e);
      return null;
    }
  }

  Future<AppUser> signUpWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      var user = result.user;
      if (user == null)
        return null;

      DatabaseService().createUser(AppUser.fromFireBase(user));
      return AppUser.fromFireBase(user);
    } catch (e){
      print(e);
      return null;
    }
  }

  Future logout() async {
    await _firebaseAuth.signOut();
  }

  Stream<AppUser> get currentUser{
    return _firebaseAuth.authStateChanges().map((user) => user != null ? AppUser.fromFireBase(user) : null);
  }
}