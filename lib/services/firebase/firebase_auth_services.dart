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
  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          User? user = credential.user;
          return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  @override
  Future loginWithGoogle() {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
  }
}
