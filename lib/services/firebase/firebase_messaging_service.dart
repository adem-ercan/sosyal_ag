
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sosyal_ag/models/post_model.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Initialize Firebase Messaging
  Future<void> initialize() async {
    // Configure default notification channel for Android
    // This is required for notifications to be displayed when the app is in the background or closed
    // Do this in a microtask to avoid blocking the main thread
    Future.microtask(() => _configureDefaultNotificationChannel());

    // Request permission for notifications - this is critical and needs to be done synchronously
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission for notifications');

      // Set foreground notification presentation options - critical for proper notification display
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Get FCM token - defer this to avoid blocking the main thread
      Future.microtask(() async {
        String? token = await _firebaseMessaging.getToken();
        if (token != null) {
          print('FCM Token: $token'); // Print token for debugging
          await saveFcmToken(token);
        }
      });

      // Listen for token refresh - this is an event listener and doesn't block
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        print('FCM Token refreshed: $newToken'); // Print refreshed token for debugging
        saveFcmToken(newToken);
      });

      // Handle foreground messages - this is an event listener and doesn't block
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification}');
          // The notification will be displayed automatically by the system
        }
      });

      // Handle notification tap when app is in background or terminated
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A notification was tapped and the app was opened!');
        print('Message data: ${message.data}');
      });

      // Check if the app was opened from a notification - defer this to avoid blocking
      Future.microtask(() async {
        RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
        if (initialMessage != null) {
          print('App was opened from a terminated state by tapping on a notification');
          print('Initial message data: ${initialMessage.data}');
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // Configure default notification channel for Android
  Future<void> _configureDefaultNotificationChannel() async {
    // This is only needed for Android
    // For iOS, the notification settings are configured in the app settings
    try {
      // Check if platform is Android (this is a simplified check, in a real app you'd use Platform.isAndroid)
      const bool isAndroid = true; // Simplified for this example
      if (isAndroid) {
        print('Configuring default notification channel for Android');
        // The actual channel configuration would be done here
        // This typically involves using a plugin like flutter_local_notifications
        // For this example, we'll just print a message
      }
    } catch (e) {
      print('Error configuring default notification channel: $e');
    }
  }

  // Save FCM token to Firestore
  Future<void> saveFcmToken(String token) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Use set with merge option instead of update to handle cases where the document might not exist yet
        // This is more efficient as it doesn't require a read before write
        await _firestore.collection('users').doc(currentUser.uid).set({
          'fcmToken': token,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      // Log error but don't fail the app initialization
      print('Error saving FCM token: $e');
    }
  }

  // This method is now deprecated as notifications are handled by Firebase Cloud Functions
  // Kept for backward compatibility but will not actually send notifications
  Future<void> sendNewPostNotification(PostModel post, String authorUserName) async {
    // This method is intentionally empty as notifications are now handled by Firebase Cloud Functions
    // The sendNewPostNotification Cloud Function will automatically send notifications to followers
    // when a new post document is created in Firestore
    print('Post notification will be handled by Firebase Cloud Functions');
  }

  // Send FCM message using Firebase Cloud Messaging HTTP v1 API
  Future<void> _sendFcmMessage({
    required List<String> tokens,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    // IMPORTANT SECURITY NOTE:
    // Sending FCM messages directly from a client app is NOT recommended for security reasons.
    // The proper approach is to use Firebase Cloud Functions or a server-side implementation.
    // Including the server key in client-side code is a security risk.
    //
    // For a production app, you should:
    // 1. Create a Cloud Function or server endpoint that sends FCM messages
    // 2. Call that endpoint from your app instead of directly using the FCM API
    // 3. Keep your server key secure on the server side
    //
    // This implementation is for demonstration purposes only and should be replaced
    // with a proper server-side implementation in a production environment.

    print('Would send notification to ${tokens.length} devices with:');
    print('Title: $title');
    print('Body: $body');

    // For testing purposes, you can use Firebase console to send test notifications
    // to verify that your app can receive and display notifications properly.
    // Go to Firebase Console > Your Project > Messaging > Send your first message
  }
}
