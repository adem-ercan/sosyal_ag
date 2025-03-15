
abstract class AuthBase {

  Future loginWithEmailAndPassword(String email, String password);  
  Future loginWithGoogle();
  Future currentUser(); 
  Stream authStateChanges();


}