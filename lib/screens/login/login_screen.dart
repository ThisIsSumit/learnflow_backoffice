import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:learnflow_backoffice/dto/login_information.dto.dart';
import 'package:learnflow_backoffice/screens/home/home_screen.dart';
import 'package:learnflow_backoffice/screens/login/widgets/login_elevated_button.dart';
import 'package:learnflow_backoffice/screens/login/widgets/login_form_card.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFA384), Color(0xFFFFD27A)],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: boxConstraints.maxHeight,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80, bottom: 80),
                    child: Column(
                      children: [
                        Text(
                          "Learn Flow",
                          style: GoogleFonts.lalezar().copyWith(
                            color: Colors.white,
                            fontSize: 48,
                          ),
                        ),
                        const SizedBox(height: 100),
                        const SizedBox(
                          width: 400,
                          child: MyLoginFormCard(),
                        ),
                        const SizedBox(height: 50),
                        MyLoginElevatedButton(
                          onPressed: () async {
                            final email = ref.watch(loginInputProvider)?.trim();
                            final password = ref.watch(passwordInputProvider);
                            if (email == null ||
                                email.isEmpty ||
                                password == null ||
                                password.isEmpty) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please enter email and password.",
                                  ),
                                ),
                              );
                              return;
                            }

                            final loginInformation = LoginInformation(
                              email: email,
                              password: password,
                            );
                            try {
                              final apiToken = await ref
                                  .watch(secureStorageProvider)
                                  .getApiToken();
                              final jwtResponse = await ref
                                  .read(apiServiceProvider(apiToken))
                                  .login(loginInformation);
                              final jwtToken = jwtResponse.jwt?.token;
                              if (jwtToken == null || jwtToken.isEmpty) {
                                const message =
                                    "Login failed. Please try again.";
                                print(jwtResponse);
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)),
                                );
                                return;
                              }

                              await ref
                                  .read(secureStorageProvider)
                                  .setApiToken(jwtToken);
                              await ref
                                  .read(secureStorageProvider)
                                  .setEmailPayload(
                                    jwtResponse.jwt?.payload?.email,
                                  );
                              await ref
                                  .read(secureStorageProvider)
                                  .setRefreshToken(jwtResponse.refreshToken);
                              SnackBar loginSuccessSnackbar = const SnackBar(
                                  content: Text("You are now logged in"));
                              if (!mounted) return;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(loginSuccessSnackbar);
                              if (!mounted) return;
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const HomeScreen();
                                  },
                                ),
                              );
                            } on DioException catch (e) {
                              debugPrint(e.toString());

                              String errorMessage =
                                  "Login failed. Please try again.";
                              if (e.response?.statusCode == 401) {
                                errorMessage = "Invalid credentials";
                              } else if (e.type ==
                                      DioExceptionType.connectionError ||
                                  e.type ==
                                      DioExceptionType.connectionTimeout ||
                                  e.type == DioExceptionType.receiveTimeout) {
                                errorMessage =
                                    "Network error: cannot reach server. Check API URL/CORS and backend status.";
                              }

                              final loginErrorSnackbar = SnackBar(
                                content: Text(errorMessage),
                              );
                              if (!mounted) return;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(loginErrorSnackbar);
                            } catch (e) {
                              debugPrint(e.toString());
                              final loginErrorSnackbar = const SnackBar(
                                content:
                                    Text("Login failed. Please try again."),
                              );
                              if (!mounted) return;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(loginErrorSnackbar);
                            }
                          },
                          child: const Text("Log in"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
