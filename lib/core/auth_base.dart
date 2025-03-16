
abstract class AuthBase {

  Future createUserWithEmailAndPassword(String email, String password);  
  Future loginWithGoogle();
  Future currentUser(); 
  Future signOut();
  Stream authStateChanges();


}