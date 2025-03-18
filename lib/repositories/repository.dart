import 'package:firebase_auth/firebase_auth.dart';
import 'package:sosyal_ag/model/user_model.dart';
import 'package:sosyal_ag/services/firebase/firebase_auth_service.dart';

class Repository {


  final FirebaseAuthServices _firebaseAuthServices = FirebaseAuthServices();
  
  // Burada bir geri dönüş değerine gerek yok. 
  // Geri dönüş değeri oturum açıldıktan sonra çağırılan veritabanı fonksiyonunda olacak.

  Future<void> createUserWithEmailAndPassword(String email, String password) async { 
    UserCredential? credential = await _firebaseAuthServices.createUserWithEmailAndPassword(email, password);
    User? user = credential?.user;

    if (user != null) {
      // Burada veritabanı işlemleri yapılacak.
      
    } else {
      print("Oturum açılamadı");
    }
  }


  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    UserCredential? credential = await _firebaseAuthServices.signInWithEmailAndPassword(email, password);
    User? user = credential?.user;

    if (user != null) {
      // Burada veritabanı işlemleri yapılacak.
      
    } else {
      print("Oturum açılamadı");
    }
  }

  Future<void> signOut() async {
    await _firebaseAuthServices.signOut();
  }
  
}
