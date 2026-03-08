import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:learnflow_backoffice/screens/login/login_screen.dart';
import 'package:learnflow_backoffice/services/api/api_service.dart';
import 'package:learnflow_backoffice/services/authentication/secure_storage.dart';

class LogoutAlertDialog extends ConsumerStatefulWidget {
  const LogoutAlertDialog({super.key});

  @override
  ConsumerState<LogoutAlertDialog> createState() => _LogoutAlertDialogState();
}

class _LogoutAlertDialogState extends ConsumerState<LogoutAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Log out?'),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () async {
            var apiLogoutFailed = false;
            try {
              final apiToken =
                  await ref.read(secureStorageProvider).getApiToken();
              if (apiToken != null && apiToken.isNotEmpty) {
                await ref.read(apiServiceProvider(apiToken)).logout();
              }
            } catch (_) {
              apiLogoutFailed = true;
            } finally {
              await ref.read(secureStorageProvider).deleteJwt();
              if (!mounted) return;
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    apiLogoutFailed
                        ? 'Logged out locally. Server logout failed.'
                        : 'You have been logged out.',
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
