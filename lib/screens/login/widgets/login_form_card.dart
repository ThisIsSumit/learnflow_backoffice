import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:learnflow_backoffice/screens/login/widgets/password_text_field.dart';

final loginInputProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});

final passwordInputProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});

class MyLoginFormCard extends ConsumerWidget {
  const MyLoginFormCard({super.key});

  get _authFormKey => GlobalKey();
  get _loginController => TextEditingController();
  get _passwordController => TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: _authFormKey,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _loginController,
                decoration: const InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
                onChanged: (value) {
                  ref.watch(loginInputProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 20),
              PasswordTextField(
                controller: _passwordController,
                onChanged: (value) {
                  ref.watch(passwordInputProvider.notifier).state = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
