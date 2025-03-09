import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_initiator_task/presentation/blocs/post/post_event.dart';
import 'package:tech_initiator_task/presentation/blocs/post/post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  PostBloc() : super(PostInitial()) {
    saveFCMToken();
    on<LoadPosts>((event, emit) async {
      emit(PostLoading());
      try {
        _fireStore.collection('posts').orderBy('timestamp', descending: true).snapshots().listen((snapshot) {
          List<Map<String, dynamic>> posts = snapshot.docs.map((doc) => doc.data()).toList();
          add(PostUpdated(posts));
        });
      } catch (e) {
        emit(PostError());
      }
    });

    on<PostUpdated>((event, emit) {
      emit(PostLoaded(event.posts));
    });

    on<AddPost>((event, emit) async {
      try {
        String? userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          DocumentSnapshot userDoc = await _fireStore.collection('users').doc(userId).get();
          String username = userDoc.exists ? userDoc['username'] : '';

          await _fireStore.collection('posts').add({
            'message': event.message,
            'username': username,
            'timestamp': FieldValue.serverTimestamp(),
          });
          add(LoadPosts());
        } else {
          emit(PostError());
        }
      } catch (e) {
        emit(PostError());
      }
    });
  }

  void saveFCMToken() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    String? token = await FirebaseMessaging.instance.getToken();

    if (userId != null && token != null) {
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': token,
      });
    }
  }

}