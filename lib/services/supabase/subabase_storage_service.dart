/* import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<String?> uploadFile({
    required String bucketName,
    required String filePath,
    required File file,
  }) async {
    try {
      await _supabaseClient
          .storage
          .from(bucketName)
          .upload(filePath, file);
      
      final String fileUrl = _supabaseClient
          .storage
          .from(bucketName)
          .getPublicUrl(filePath);
      
      return fileUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<bool> deleteFile({
    required String bucketName,
    required String filePath,
  }) async {
    try {
      await _supabaseClient
          .storage
          .from(bucketName)
          .remove([filePath]);
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  String? getFileUrl({
    required String bucketName,
    required String filePath,
  }) {
    try {
      return _supabaseClient
          .storage
          .from(bucketName)
          .getPublicUrl(filePath);
    } catch (e) {
      print('Error getting file URL: $e');
      return null;
    }
  }
} */
