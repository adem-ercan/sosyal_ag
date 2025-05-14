import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<AuthResponse?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      print('Kayıt olma hatası: $e');
      return null;
    }
  }

  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      print('Giriş hatası: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      print('Çıkış hatası: $e');
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
      return true;
    } catch (e) {
      print('Şifre sıfırlama hatası: $e');
      return false;
    }
  }

  User? get currentUser => _supabaseClient.auth.currentUser;

  bool get isAuthenticated => _supabaseClient.auth.currentUser != null;

  Stream<AuthState> get authStateChanges => 
      _supabaseClient.auth.onAuthStateChange;
}
