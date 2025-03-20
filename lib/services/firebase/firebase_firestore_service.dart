// Metotlarda try-catch'i sadece viewmodel'lerde kullanıyoruz. 
// Firebase servisleri ve repository'de kullanmıyoruz. 
// Her katmanda ayrı hata yakalamaya gerek yok. Efektif de değil.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sosyal_ag/core/db_base.dart';



class FirestoreService implements DataBaseCore {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> createNewUser(Map<String, dynamic> userJsonData) async {
    CollectionReference usersRef = _firestore.collection('users');
     await usersRef.doc(userJsonData['uid']).set(userJsonData);
  }


}