import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PasswordTextField extends ConsumerStatefulWidget {
  const PasswordTextField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController? controller;
  final Function(String)? onChanged;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PasswordTextFieldState();
}

class _PasswordTextFieldState extends ConsumerState<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: "Password",
        prefixIcon: const Icon(
          Icons.lock,
        ),
        suffixIcon: Container(
          clipBehavior: Clip.hardEdge,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.20),
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(30),
            ),
          ),
          height: 60,
          width: 60,
          child: InkWell(
            onHover: null,
            onTap: () => setState(() => _obscureText = !_obscureText),
            child: buildSuffixIcon(),
          ),
        ),
      ),
    );
  }

  Icon buildSuffixIcon() {
    if (_obscureText) {
      return Icon(
        Icons.visibility_off,
        color: Theme.of(context).colorScheme.outline,
      );
    } else {
      return Icon(
        Icons.visibility,
        color: Theme.of(context).colorScheme.primary,
      );
    }
  }
}
