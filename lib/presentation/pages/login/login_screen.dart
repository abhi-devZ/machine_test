import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test/core/network/api_service.dart';
import 'package:machine_test/core/network/dio_factory.dart';
import 'package:machine_test/data/repositories/auth_repository_local.dart';
import 'package:machine_test/data/repositories/auth_repository_remote.dart';
import 'package:machine_test/di/injectionContainer.dart';
import 'package:machine_test/presentation/blocs/authBloc/auth_bloc.dart';
import 'package:machine_test/presentation/blocs/authBloc/auth_bloc.dart';
import 'package:machine_test/presentation/widgets/alert_window.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  FocusNode userNameFieldFocusNode = FocusNode();
  FocusNode passwordFieldFocusNode = FocusNode();

  bool togglePassword = false;
  bool isButtonEnable = true;
  bool isLoading = false;
  AuthBloc bloc = AuthBloc(
    authRemoteRepository: il<AuthRepositoryRemote>(),
    authLocalRepository: il<AuthRepositoryLocal>(),
  );

  @override
  void initState() {
    super.initState();
    _userNameTextController.text = "emilys";
    _passwordTextController.text = "emilyspass";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadows: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.5),
                blurRadius: 12,
                offset: const Offset(1, 0),
                spreadRadius: 0,
              )
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          child: BlocConsumer(
            bloc: bloc,
            listener: (context, state) {
              isLoading = false;
              if (state is AuthScreenLoadingState) {
                isLoading = true;
              } else if (state is TogglePasswordState) {
                togglePassword = state.togglePassword;
              } else if (state is AuthScreenFailedState) {
                showAlert(
                  "Info",
                  state.msg,
                  context,
                  [
                    TextButton(
                      onPressed: () {},
                      child: const Text('OK'),
                    ),
                  ],
                );
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  _headingBuilder(),
                  _inputTextBuilder(false),
                  _inputTextBuilder(true),
                  _loginButtonBuilder(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _headingBuilder() {
    return Text(
      "Login",
      style: TextStyle(
        color: Colors.black87,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.32,
      ),
    );
  }

  Widget _inputTextBuilder(isPassword) {
    TextEditingController controller = isPassword ? _passwordTextController : _userNameTextController;
    return TextFormField(
      key: isPassword ? const Key("passwordField") : const Key("emailField"),
      controller: controller,
      focusNode: isPassword ? userNameFieldFocusNode : passwordFieldFocusNode,
      autocorrect: false,
      enabled: true,
      //TODO based on state
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        fillColor: const Color(0xFFF3F5F3),
        filled: true,
        hintText: isPassword ? "Password" : "User Name",
        hintStyle: TextStyle(
          color: const Color(0xFF6D6F6D),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFF3F5F3),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF64B326)),
          borderRadius: BorderRadius.circular(16),
        ),
        alignLabelWithHint: true,
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(16),
        ),
        suffixIcon: (isPassword && _passwordTextController.text.isNotEmpty)
            ? GestureDetector(
                onTap: () {
                  // toggle password
                },
                child: togglePassword
                    ? Icon(
                        Icons.visibility_off,
                        color: Theme.of(context).iconTheme.color,
                      )
                    : Icon(
                        Icons.visibility,
                        color: Theme.of(context).iconTheme.color,
                      ),
              )
            : null,
      ),
      cursorWidth: 1.0,
      style: TextStyle(
        color: const Color(0xFF0E1905),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      obscureText: isPassword ? togglePassword : false,
      cursorRadius: Radius.circular(50.0),
      keyboardType: isPassword ? null : TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
    );
  }

  Widget _loginButtonBuilder() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ElevatedButton(
        key: const Key("LoginFormSubmit"),
        onPressed: () {
          bloc.add(
            SubmitLoginEvent(
              username: _userNameTextController.text,
              password: _passwordTextController.text,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.sizeOf(context).width, 56),
            backgroundColor: isButtonEnable ? const Color(0xFF64B326) : const Color(0xFFD8F2C4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadowColor: Colors.transparent),
        child: isLoading
            ? CircularProgressIndicator(
                color: const Color(0xFFB4E68C),
                strokeWidth: 1.5,
              )
            : Text(
                "Log in",
                style: TextStyle(
                  fontFeatures: const [FontFeature.enable('smcp')],
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.32,
                ),
              ),
      ),
    );
  }
}
