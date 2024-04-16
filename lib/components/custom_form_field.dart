import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final double height;
  final RegExp? validationRegex;
  final bool obscureText;
  final void Function(String?) onSaved;

  const CustomFormField({
    super.key,
    required this.label,
    required this.height,
    required this.onSaved,
    this.validationRegex,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        onSaved: onSaved,
        obscureText: obscureText,
        validator: (value) {
          if (validationRegex == null) {
            return null;
          }
          if (value != null && validationRegex!.hasMatch(value)) {
            return null;
          }
          return "Enter a valid ${label.toLowerCase()}";
        },
        decoration: InputDecoration(
          hintText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
