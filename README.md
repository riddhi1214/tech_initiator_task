# Tech Initiator Task - Flutter Social Media App

This Flutter app is a simple social media-like platform where users can sign up, log in, and post messages. It uses Firebase for authentication, Firestore for database management, Firebase Cloud Messaging (FCM) for push notifications, and Bloc for state management.

## Features
- User authentication (Sign up, Login, Logout)
- Create and display posts in real-time
- Firebase Cloud Messaging (FCM) for push notifications
- Bloc pattern for state management

## Prerequisites
Before running the app, make sure you have the following installed:
- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Firebase CLI: [Install Firebase CLI](https://firebase.google.com/docs/cli)
- Node.js (for Firebase functions): [Install Node.js](https://nodejs.org/)

## Setup Instructions

### 1. Clone the repository
```sh
git clone https://github.com/yourusername/tech_initiator_task.git
cd tech_initiator_task
```

### 2. Install dependencies
```sh
flutter pub get
```

### 3. Configure Firebase
1. Create a Firebase project from the [Firebase Console](https://console.firebase.google.com/).
2. Enable **Authentication** (Email & Password).
3. Set up **Cloud Firestore** with a "posts" collection.
4. Enable **Firebase Cloud Messaging (FCM)**.

#### Add Firebase to Flutter
1. Download the `google-services.json` file for Android and place it in:
   ```
   android/app/google-services.json
   ```
2. Download the `GoogleService-Info.plist` file for iOS and place it in:
   ```
   ios/Runner/GoogleService-Info.plist
   ```

### 4. Configure Firebase Cloud Functions (for notifications)
1. Navigate to the `functions` directory:
   ```sh
   cd functions
   ```
2. Install dependencies:
   ```sh
   npm install
   ```
3. Deploy Firebase functions:
   ```sh
   firebase deploy --only functions
   ```

### 5. Run the App
To launch the app, run:
```sh
flutter run
```

## Firebase Firestore Database Structure
```
users (Collection)
  - {userId} (Document)
    - username: String
    - email: String
    - fcmToken: String

posts (Collection)
  - {postId} (Document)
    - message: String
    - username: String
    - timestamp: Timestamp
```

## Firebase Cloud Messaging (FCM)
To receive notifications:
1. Request permission in the app:
   ```dart
   FirebaseMessaging.instance.requestPermission();
   ```
2. Save the FCM token in Firestore.

## Local Notification Support
The app uses `flutter_local_notifications` for displaying notifications when the app is in the foreground.

## Troubleshooting
- If Firebase isn't working, ensure you have correctly placed the `google-services.json` and `GoogleService-Info.plist` files.
- Run `flutter clean` if you experience any build issues.
- Ensure Firebase CLI is logged in with `firebase login`.

