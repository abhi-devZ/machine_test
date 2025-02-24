import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test/data/models/auth_response_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

part 'profile_state.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? authData = prefs.getString('authResponse');

      if (authData != null) {
        final authResponse = AuthResponse.fromJson(jsonDecode(authData));
        emit(state.copyWith(
          status: ProfileStatus.loaded,
          authResponse: authResponse,
        ));
      } else {
        emit(state.copyWith(
          status: ProfileStatus.error,
          errorMessage: 'No authentication data found',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'Failed to load profile: ${e.toString()}',
      ));
    }
  }
}
