import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.onChanged,
    required this.prefixIcon,
    required this.typeText,
    this.readOnly,
    this.errorText,
  });

  final TextEditingController controller;
  final String labelText;
  final void Function() onChanged;
  final IconData prefixIcon;
  final TextInputType typeText;
  final String? errorText;
  final bool? readOnly;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        readOnly: widget.readOnly ?? false,
        keyboardType: widget.typeText,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        controller: widget.controller,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white30,
            prefixIcon: Icon(
              widget.prefixIcon,
              color: Colors.white,
            ),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(color: Colors.white, width: 1.0)),
            disabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(color: Colors.white, width: 1.0)),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(color: Colors.white, width: 1.0)),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(color: Colors.white, width: 1.0)),
            label: Text(widget.labelText),
            labelStyle: const TextStyle(color: Colors.white),
            focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(color: Colors.red, width: 1.0)),
            errorStyle: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
            errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(color: Colors.red, width: 1.0)),
            errorText: widget.errorText),
        onChanged: (_) {
          widget.onChanged();
        });
  }
}
