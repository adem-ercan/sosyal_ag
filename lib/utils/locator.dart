import 'package:get_it/get_it.dart';
import 'package:sosyal_ag/init.dart';
import 'package:sosyal_ag/model/user_model.dart';
import 'package:sosyal_ag/repositories/repository.dart';
import 'package:sosyal_ag/services/firebase/firebase_auth_service.dart';
import 'package:sosyal_ag/services/firebase/firebase_firestore_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {


  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => Repository());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => UserModel(userName: "userName", email: "email"));
  locator.registerLazySingleton(()=> Init());


  
  // locator.registerLazySingleton(() => FirestoreService());
  // locator.registerLazySingleton(() => NavigationService());
  // locator.registerLazySingleton(() => DialogService());
  // locator.registerLazySingleton(() => SnackbarService());
  // locator.registerLazySingleton(() => StorageService());
  // locator.registerLazySingleton(() => ThemeService());
  // locator.registerLazySingleton(() => UserService());
  // locator.registerLazySingleton(() => ConnectivityService());
  // locator.registerLazySingleton(() => FirebaseAnalyticsService());
  // locator.registerLazySingleton(() => FirebaseMessagingService());
  // locator.registerLazySingleton(() => FirebaseStorageService());
  // locator.registerLazySingleton(() => FirebasePerformanceService());
  // locator.registerLazySingleton(() => FirebaseCrashlyticsService());
  // locator.registerLazySingleton(() => FirebaseRemoteConfigService());
  // locator.registerLazySingleton(() => FirebaseInAppMessagingService());
  // locator.registerLazySingleton(() => FirebaseDynamicLinksService());
  // locator.registerLazySingleton(() => FirebaseAppCheckService());
  // locator.registerLazySingleton(() => FirebaseInstallationsService());
  // locator.registerLazySingleton(() => FirebasePredictionsService());
  // locator.registerLazySingleton(() => FirebaseMLCustomModelService());
  // locator.registerLazySingleton(() => FirebaseMLService());
  // locator.registerLazySingleton(() => FirebaseMLVisionService());
  // locator.registerLazySingleton(() => FirebaseMLNaturalLanguage
  //     .service()); // FirebaseMLNaturalLanguage is too long to be a class name
  // locator.registerLazySingleton(() => FirebaseMLLanguageIdentificationService());
  // locator.registerLazySingleton(() => FirebaseMLTranslateService());
  // locator.registerLazySingleton(() => FirebaseMLSmartReplyService());
  // locator.registerLazySingleton(() => FirebaseMLImageLabelerService());     
}
   