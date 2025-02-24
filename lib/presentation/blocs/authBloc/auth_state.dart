part of 'auth_bloc.dart';

abstract class AuthState {}

final class AuthInitial extends AuthState {}

final class TogglePasswordState extends AuthState {
  final bool togglePassword;
  TogglePasswordState({required this.togglePassword});
}

final class AuthScreenLoadingState extends AuthState {}
final class AuthScreenSuccessState extends AuthState {}
final class AuthScreenFailedState extends AuthState {
  final String msg;
  AuthScreenFailedState({required this.msg});
}
