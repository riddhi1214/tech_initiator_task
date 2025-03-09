import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  SignupBloc() : super(SignupInitial()) {
    on<SignupRequested>((event, emit) async {
      emit(SignUpLoading());
      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        await _fireStore.collection('users').doc(user.user!.uid).set({
          'username': event.username,
          'email': event.email,
        });
        emit(SignupSuccess());
      } catch (_) {
        emit(SignupFailure());
      }
    });
  }
}
