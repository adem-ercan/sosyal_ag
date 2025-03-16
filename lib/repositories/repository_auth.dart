import 'package:firebase_auth/firebase_auth.dart';
import 'package:sosyal_ag/services/firebase/firebase_auth_services.dart';

class RepositoryAuth {


  final FirebaseAuthServices _firebaseAuthServices = FirebaseAuthServices();
  
  // Burada bir geri dönüş değerine gerek yok. 
  // Geri dönüş değeri oturum açıldıktan sonra çağırılan veritabanı fonksiyonunda olacak.

  Future<void> createUserWithEmailAndPassword(String email, String password) async { 
    User? user = await _firebaseAuthServices.createUserWithEmailAndPassword(email, password);
    if (user != null) {
      // Burada veritabanı işlemleri yapılacak.
      
    } else {
      print("Oturum açılamadı");
    }
  }

  
}
