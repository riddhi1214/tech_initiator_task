import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_initiator_task/presentation/blocs/login/login_bloc.dart';
import 'package:tech_initiator_task/presentation/blocs/login/login_event.dart';
import 'package:tech_initiator_task/presentation/blocs/login/login_state.dart';
import 'package:tech_initiator_task/presentation/blocs/post/post_bloc.dart';
import 'package:tech_initiator_task/presentation/blocs/post/post_event.dart';
import 'package:tech_initiator_task/presentation/blocs/post/post_state.dart';
import 'package:tech_initiator_task/services/notification_handler.dart';

import 'login_screen.dart';

class PostScreen extends StatefulWidget {

  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  void initState() {
    super.initState();
    NotificationHandler.initialize(context);
  }
  final TextEditingController postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<LoginBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginUnauthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: postController,
                decoration: InputDecoration(labelText: "Write a post"),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<PostBloc>().add(AddPost(postController.text));
                  postController.clear();
                },
                child: Text("Post"),
              ),
              Expanded(
                child: BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    if (state is PostLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is PostLoaded) {
                      return ListView.builder(
                        itemCount: state.posts.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(state.posts[index]['message']),
                            subtitle: Text(state.posts[index]['username']),
                          );
                        },
                      );
                    }
                    return Center(child: Text("No posts yet"));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
