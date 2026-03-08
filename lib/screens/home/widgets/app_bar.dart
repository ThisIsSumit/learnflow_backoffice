import 'package:flutter/material.dart';
import 'package:learnflow_backoffice/screens/home/widgets/app_bar_user_button.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key, required this.subScreen});

  final String subScreen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subScreen,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const MyAppBarUserButton(),
        ],
      ),
    );
  }
}
