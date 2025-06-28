part of 'user_bloc.dart';

abstract class UserEvent {
  const UserEvent();
}

// Email/Şifre ile kullanıcı oluşturma
class CreateUserRequested extends UserEvent {
  final String email;
  final String password;
  final String userName;

  const CreateUserRequested(this.email, this.password, this.userName);
}

// Email/Şifre ile giriş
class SignInRequested extends UserEvent {
  final String email;
  final String password;

  const SignInRequested(this.email, this.password);
}

// Çıkış yap
class SignOutRequested extends UserEvent {}

// Aktif kullanıcı verilerini getir
class FetchCurrentUserData extends UserEvent {}

// ID ile kullanıcı getir
class FetchUserById extends UserEvent {
  final String userId;

  const FetchUserById(this.userId);
}

// Kullanıcı arama
class SearchUsers extends UserEvent {
  final String query;

  const SearchUsers(this.query);
}

// Takip isteği gönder
class SendFollowRequest extends UserEvent {
  final String targetUserId;

  const SendFollowRequest(this.targetUserId);
}

// Kullanıcı takip et
class FollowUser extends UserEvent {
  final String targetUserId;

  const FollowUser(this.targetUserId);
}

// Kullanıcı takibi bırak
class UnFollowUser extends UserEvent {
  final String targetUserId;

  const UnFollowUser(this.targetUserId);
}

// Meydan durumunu değiştir
class ToggleIsMeydan extends UserEvent {}

// Doğrulama durumunu değiştir
class ToggleVerificationStatus extends UserEvent {
  final bool newStatus;

  const ToggleVerificationStatus(this.newStatus);
}



class _AuthStateChangedEvent extends UserEvent {
  final bool isAuthenticated;

  const _AuthStateChangedEvent(this.isAuthenticated);
}

// Kullanıcı verisi güncellendiğinde kullanılacak event
class UserDataUpdated extends UserEvent {
  final Map<String, dynamic> userData;

  const UserDataUpdated(this.userData);
}

// Kullanıcı stream'ini başlatma event'i
class StartUserStream extends UserEvent {
  final String userId;

  const StartUserStream(this.userId);
}

// Kullanıcı stream'ini durdurma event'i
class StopUserStream extends UserEvent {
  final String userId;

  const StopUserStream(this.userId);
}