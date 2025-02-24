import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test/app.dart';
import 'package:machine_test/core/utils/routes/app_routes.dart';
import 'package:machine_test/data/models/auth_response_model.dart';
import 'package:machine_test/data/repositories/auth_repository_local.dart';
import 'package:machine_test/data/repositories/auth_repository_remote.dart';
import 'package:machine_test/domain/entities/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryRemote authRemoteRepository;
  final AuthRepositoryLocal authLocalRepository;

  AuthBloc({required this.authRemoteRepository, required this.authLocalRepository}) : super(AuthInitial()) {
    on<TogglePasswordEvent>(_togglePasswordEvent);
    on<SubmitLoginEvent>(_submitLoginEvent);
  }
  Future<void> _togglePasswordEvent(TogglePasswordEvent event, Emitter<AuthState> emit) async {
    print("=======");
    emit(TogglePasswordState(togglePassword: !event.togglePassword));
  }
  Future<void> _submitLoginEvent(SubmitLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthScreenLoadingState());
    AuthDataWithUserName authData = AuthDataWithUserName(username: event.username, password: event.password);
    Map<String, dynamic> authInfo = authData.toJson();
    try {
      var resource = await authRemoteRepository.login(authInfo);
      AuthState loginScreenState = await validateAuthResponseToState(resource);
      emit(loginScreenState);
    } catch (err) {
      emit(AuthScreenSuccessState()); // TODO SHOW ERROR
      rethrow;
    }
  }

  Future<AuthState> validateAuthResponseToState(response) async {
    return await response.fold(
      (l) async {
        return AuthScreenFailedState(msg: "Invalid User Name or Password.");
      },
      (r) async {
        try {
          AuthResponse authResponse = AuthResponse.fromJson(r);
          if (authResponse.accessToken != null) {
            await _saveAuthData(authResponse);
            await authLocalRepository.saveToken(token: authResponse.accessToken);
            navigatorKey.currentState?.pushNamedAndRemoveUntil(
              RouteNameString.home,
              (route) => false,
            );
            return AuthScreenSuccessState();
          } else {
            return AuthScreenFailedState(msg: 'Invalid UserName or Password.');
          }
        } catch (err) {
          rethrow;
        }
      },
    );
  }

  Future<void> _saveAuthData(AuthResponse authResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authResponse', jsonEncode(authResponse.toJson()));
  }
}
