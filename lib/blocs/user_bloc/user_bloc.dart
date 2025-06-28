import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sosyal_ag/blocs/user_bloc/user_state.dart';
import 'package:sosyal_ag/models/user_model.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/utils/locator.dart';

part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final Repository _repository = locator<Repository>();
  StreamSubscription? _authSubscription;
  Map<String, StreamSubscription> _userSubscriptions = {};

  UserBloc() : super(UserInitial()) {
    // Auth state değişikliklerini dinle
    _authSubscription = _repository.authStateChanges().listen((isAuthenticated) {
      add(_AuthStateChangedEvent(isAuthenticated));
    });

    on<CreateUserRequested>(_createUser);
    on<SignInRequested>(_signIn);
    on<SignOutRequested>(_signOut);
    on<FetchCurrentUserData>(_getCurrentUser);
    on<FetchUserById>(_getUserById);
    on<SearchUsers>(_searchUsers);
    on<SendFollowRequest>(_sendFollowRequest);
    on<FollowUser>(_followUser);
    on<UnFollowUser>(_unFollowUser);
    on<ToggleIsMeydan>(_toggleIsMeydan);
    on<ToggleVerificationStatus>(_toggleVerification);
    on<_AuthStateChangedEvent>(_onAuthChanged);
    on<StartUserStream>(_startUserStream);
    on<StopUserStream>(_stopUserStream);
  }

  void _onAuthChanged(_AuthStateChangedEvent event, Emitter<UserState> emit) {
    emit(AuthStateChanged(event.isAuthenticated));
  }

  Future<void> _createUser(
    CreateUserRequested event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      await _repository.createUserWithEmailAndPassword(
        event.email,
        event.password,
        event.userName,
      );
      emit(OperationSuccess());
    } catch (e) {
      emit(UserError("Kullanıcı oluşturma hatası: $e"));
    }
  }

  Future<void> _signIn(
    SignInRequested event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      final user = await _repository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      if (user != null) {
        emit(SignInSuccess(user));
      } else {
        emit(const UserError("Kullanıcı bulunamadı"));
      }
    } catch (e) {
      emit(UserError("Giriş hatası: $e"));
    }
  }

  Future<void> _signOut(
    SignOutRequested event,
    Emitter<UserState> emit,
  ) async {
    try {
      await _repository.signOut();
      emit(OperationSuccess());
    } catch (e) {
      emit(UserError("Çıkış yapma hatası: $e"));
    }
  }

  Future<void> _getCurrentUser(
    FetchCurrentUserData event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      final user = await _repository.getCurrentUserAllData();
      if (user != null) {
        emit(UserDataLoaded(user));
      } else {
        emit(const UserError("Kullanıcı verisi alınamadı"));
      }
    } catch (e) {
      emit(UserError("Kullanıcı verisi getirme hatası: $e"));
    }
  }

  Future<void> _getUserById(
    FetchUserById event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      final user = await _repository.getUserDataById(event.userId);
      if (user != null) {
        emit(UserDataLoaded(user));
      } else {
        emit(const UserError("Kullanıcı bulunamadı"));
      }
    } catch (e) {
      emit(UserError("Kullanıcı getirme hatası: $e"));
    }
  }

  Future<void> _searchUsers(
    SearchUsers event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      final users = await _repository.searchUsers(event.query);
      emit(UsersListLoaded(users.whereType<UserModel>().toList()));
    } catch (e) {
      emit(UserError("Arama hatası: $e"));
    }
  }

  Future<void> _sendFollowRequest(
    SendFollowRequest event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      await _repository.followRequest(event.targetUserId);
      emit(OperationSuccess());
    } catch (e) {
      emit(UserError("Takip isteği gönderme hatası: $e"));
    }
  }

  Future<void> _followUser(
    FollowUser event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      await _repository.followUser(event.targetUserId);
      emit(OperationSuccess());
    } catch (e) {
      emit(UserError("Takip etme hatası: $e"));
    }
  }

  Future<void> _unFollowUser(
    UnFollowUser event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      await _repository.unFollowUser(event.targetUserId);
      emit(OperationSuccess());
    } catch (e) {
      emit(UserError("Takibi bırakma hatası: $e"));
    }
  }

  Future<void> _toggleIsMeydan(
    ToggleIsMeydan event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      await _repository.toggleIsMeydan();
      emit(OperationSuccess());
    } catch (e) {
      emit(UserError("Meydan durumu değiştirme hatası: $e"));
    }
  }

  Future<void> _toggleVerification(
    ToggleVerificationStatus event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(UserLoading());
      await _repository.toggleUserVerificationStatus(event.newStatus);
      emit(OperationSuccess());
    } catch (e) {
      emit(UserError("Doğrulama durumu değiştirme hatası: $e"));
    }
  }

  Future<void> _startUserStream(
    StartUserStream event,
    Emitter<UserState> emit,
  ) async {
    if (_userSubscriptions.containsKey(event.userId)) return;

    final stream = _repository.getUserByIdStream(event.userId);
    _userSubscriptions[event.userId] = stream.listen((userData) {
      if (userData != null) {
        add(UserDataUpdated(userData));
      }
    });
  }

  Future<void> _stopUserStream(
    StopUserStream event,
    Emitter<UserState> emit,
  ) async {
    final subscription = _userSubscriptions.remove(event.userId);
    await subscription?.cancel();
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    // Tüm kullanıcı stream'lerini iptal et
    for (var subscription in _userSubscriptions.values) {
      subscription.cancel();
    }
    _userSubscriptions.clear();
    return super.close();
  }
}

// Private event for internal auth state changes
