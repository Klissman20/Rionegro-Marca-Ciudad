import 'package:flutter/material.dart';

class PasswordFieldBox extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String? errorText;
  const PasswordFieldBox(
      {super.key, required this.controller, this.onChanged, this.errorText});

  @override
  State<PasswordFieldBox> createState() => _PasswordFieldBoxState();
}

class _PasswordFieldBoxState extends State<PasswordFieldBox> {
  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white30,
      prefixIcon: const Icon(
        Icons.password_outlined,
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
      label: const Text('Password'),
      labelStyle: const TextStyle(color: Colors.white),
      focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(color: Colors.red, width: 1.0)),
      errorStyle: const TextStyle(
          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(color: Colors.red, width: 1.0)),
      suffixIcon: IconButton(
        icon: Icon(
          _passwordVisible ? Icons.visibility_off : Icons.visibility,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            _passwordVisible = !_passwordVisible;
          });
        },
      ),
    );

    return TextFormField(
      showCursor: true,
      cursorColor: Colors.white,
      controller: widget.controller,
      obscureText: !_passwordVisible,
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: TextInputType.visiblePassword,
      style: const TextStyle(color: Colors.white),
      decoration: inputDecoration,
      onChanged: widget.onChanged,
    );
  }
}
