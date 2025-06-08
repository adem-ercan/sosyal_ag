import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadPostMedia(File media, String fileName) async {
    try {
      // Medyayı belirtilen path'e yükle
      final ref = _storage.ref().child("postMedias/$fileName");
      final uploadTask = ref.putFile(media);
      

      // Yükleme tamamlanana kadar bekle
      final snapshot = await uploadTask.whenComplete(() => print("yükleme tamamlandı"));
    
      
      // Yüklenen medyanın download URL'ini al ve döndür
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;

    } catch (e) {
      throw Exception('Media yükleme hatası: $e');
    }
  }
  Future<void> deletePostMedia(String mediaUrl) async {
    try {
      final ref = _storage.refFromURL(mediaUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Media silme hatası: $e');
    }
  }

  
}
