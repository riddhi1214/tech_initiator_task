abstract class SignupEvent {}

class SignupRequested extends SignupEvent {
  final String username, email, password;
  SignupRequested(this.username, this.email, this.password);
}
