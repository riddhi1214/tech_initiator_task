import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_initiator_task/presentation/blocs/login/login_bloc.dart';
import 'package:tech_initiator_task/presentation/blocs/login/login_event.dart';
import 'package:tech_initiator_task/presentation/blocs/login/login_state.dart';
import 'post_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController(text: "riddhi@gmail.com");
  final TextEditingController passwordController = TextEditingController(text: "Riddhi@123");

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginAuthenticated) {
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
              TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
              TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
              SizedBox(height: 20),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state is LoginLoading) {
                    return CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      context.read<LoginBloc>().add(LoginRequested(
                        emailController.text,
                        passwordController.text,
                      ));
                    },
                    child: Text("Login"),
                  );
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
