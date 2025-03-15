import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {

  Future loginWithEmailAndPassword();
  Future loginWithGoogle();
  Future currentUser(); 
  Stream<User?> authStateChanges();


}