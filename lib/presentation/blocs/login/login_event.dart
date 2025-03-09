abstract class LoginEvent {}

class LoginRequested extends LoginEvent {
  final String email, password;
  LoginRequested(this.email, this.password);
}
class LogoutRequested extends LoginEvent {}
class CheckAuthStatus extends LoginEvent {}
