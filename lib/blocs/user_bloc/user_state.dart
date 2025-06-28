
import 'package:sosyal_ag/models/user_model.dart';

abstract class UserState {
  const UserState();
}

// Başlangıç durumu
class UserInitial extends UserState {}

// Yükleme durumu
class UserLoading extends UserState {}

// Giriş başarılı
class SignInSuccess extends UserState {
  final UserModel user;
  
  const SignInSuccess(this.user);
}

// İşlem başarılı (genel)
class OperationSuccess extends UserState {}

// Veri getirme başarılı
class UserDataLoaded extends UserState {
  final UserModel user;
  
  const UserDataLoaded(this.user);
}

// Kullanıcı listesi getirme
class UsersListLoaded extends UserState {
  final List<UserModel> users;
  
  const UsersListLoaded(this.users);
}

// Hata durumu
class UserError extends UserState {
  final String message;
  
  const UserError(this.message);
}

// Auth state değişiklikleri için özel state
class AuthStateChanged extends UserState {
  final bool isAuthenticated;
  
  const AuthStateChanged(this.isAuthenticated);
}
// Kullanıcı verisi güncellendi
class UserDataUpdatedState extends UserState {
  final Map<String, dynamic> userData;
  
  const UserDataUpdatedState(this.userData);
}