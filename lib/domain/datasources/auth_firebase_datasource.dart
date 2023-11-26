import 'package:flutter/widgets.dart';

abstract class AuthSupabaseDataSource {
  Future<Map<String, dynamic>> signUp(
      {required String email, required String password});

  Future<Map<String, dynamic>> signIn(
      {required String email, required String password});

  Future<void> signOut();

  Future<Map<String, dynamic>> continueWithGoogle();

  Future<Map<String, dynamic>> continueWithApple(BuildContext context);
}
