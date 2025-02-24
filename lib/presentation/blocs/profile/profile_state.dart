part of 'profile_cubit.dart';


class ProfileState {
  final ProfileStatus status;
  final AuthResponse? authResponse;
  final String? errorMessage;

  ProfileState({
    this.status = ProfileStatus.initial,
    this.authResponse,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    AuthResponse? authResponse,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      authResponse: authResponse ?? this.authResponse,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
