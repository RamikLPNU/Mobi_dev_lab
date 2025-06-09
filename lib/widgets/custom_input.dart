import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final bool isPassword;

  const CustomInput({
    required this.label,
    super.key,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
    );
  }
}
