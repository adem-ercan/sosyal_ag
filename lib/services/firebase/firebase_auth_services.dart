import 'package:firebase_auth/firebase_auth.dart';
import 'package:sosyal_ag/core/auth_base.dart';

class FirebaseAuthServices implements AuthBase {
  @override
  Stream<User?> authStateChanges() {
    // TODO: implement authStateChanges
    throw UnimplementedError();
  }

  @override
  Future currentUser() {
    // TODO: implement currentUser
    throw UnimplementedError();
  }

  @override
  Future loginWithEmailAndPassword() {
    // TODO: implement loginWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future loginWithGoogle() {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
  }

}