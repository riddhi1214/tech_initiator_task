import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LoginBloc() : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        await _auth.signInWithEmailAndPassword(email: event.email, password: event.password);
        emit(LoginAuthenticated());
      } catch (_) {
        emit(LoginUnauthenticated());
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(LoginLoading());
      await _auth.signOut();
      emit(LoginUnauthenticated());
    });

    on<CheckAuthStatus>((event, emit) {
      if (_auth.currentUser != null) {
        emit(LoginAuthenticated());
      } else {
        emit(LoginUnauthenticated());
      }
    });
  }
}
