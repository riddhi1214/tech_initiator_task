import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_initiator_task/presentation/blocs/signup/signup_bloc.dart';
import 'package:tech_initiator_task/presentation/blocs/signup/signup_event.dart';
import 'package:tech_initiator_task/presentation/blocs/signup/signup_state.dart';
import 'login_screen.dart';
import 'post_screen.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => PostScreen()),
                  (route) => false,
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(controller: usernameController, decoration: InputDecoration(labelText: 'Username')),
              TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
              TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
              SizedBox(height: 20),
              BlocBuilder<SignupBloc, SignupState>(
                builder: (context, state) {
                  if (state is SignUpLoading) {
                    return CircularProgressIndicator();
                  }
                return  ElevatedButton(
                    onPressed: () {
                      context.read<SignupBloc>().add(SignupRequested(
                        usernameController.text,
                        emailController.text,
                        passwordController.text,
                      ));
                    },
                    child: Text("Sign Up"),
                  );
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

