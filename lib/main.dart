import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tech_initiator_task/presentation/blocs/login/login_bloc.dart';
import 'package:tech_initiator_task/presentation/blocs/login/login_event.dart';
import 'package:tech_initiator_task/presentation/blocs/login/login_state.dart';
import 'package:tech_initiator_task/presentation/blocs/post/post_bloc.dart';
import 'package:tech_initiator_task/presentation/blocs/post/post_event.dart';
import 'package:tech_initiator_task/presentation/blocs/signup/signup_bloc.dart';
import 'package:tech_initiator_task/presentation/screens/post_screen.dart';
import 'package:tech_initiator_task/presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp( const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignupBloc()),
        BlocProvider(create: (context) => LoginBloc()..add(CheckAuthStatus())),
        BlocProvider(create: (context) => PostBloc()..add(LoadPosts())),
      ],
      child: MaterialApp(
        home: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginAuthenticated) {
              return PostScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
