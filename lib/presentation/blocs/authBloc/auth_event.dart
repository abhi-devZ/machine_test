part of 'auth_bloc.dart';

abstract class AuthEvent {}

class TogglePasswordEvent extends AuthEvent {
  final bool togglePassword;

  TogglePasswordEvent({required this.togglePassword});
}

class SubmitLoginEvent extends AuthEvent {
  final String username;
  final String password;

  SubmitLoginEvent({required this.username, required this.password});
}
