import 'package:firebase_auth/firebase_auth.dart';
import 'package:sosyal_ag/core/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<bool> authStateChanges() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user != null) {
        return true;
      } else{return false;} 
    });
    
  }

  @override
  Future<User?> currentUser() async{
    User? user =_auth.currentUser;
    return user;
  }

  @override
  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential;
  }

  @override
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential;
  }

  @override
  Future<UserCredential?> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Apple Sign In

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.

    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider(
        "apple.com",
      ).credential(idToken: appleCredential.identityToken, rawNonce: rawNonce);

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}
