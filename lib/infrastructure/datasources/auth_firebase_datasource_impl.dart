import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rionegro_marca_ciudad/domain/datasources/auth_firebase_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthSupabaseDataSourceImpl extends AuthSupabaseDataSource {
  final SupabaseClient _supabaseAuth;

  AuthSupabaseDataSourceImpl(this._supabaseAuth);

  @override
  Future<Map<String, dynamic>> signUp(
      {required String email, required String password}) async {
    try {
      final response =
          await _supabaseAuth.auth.signUp(email: email, password: password);
      return {
        'user': (response.user),
        'state': 'ok',
      };
    } on Exception catch (e) {
      return {'user': null, 'state': 'failed', 'error': e};
    }
  }

  @override
  Future<Map<String, dynamic>> signIn(
      {required String email, required String password}) async {
    try {
      final response = await _supabaseAuth.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return {'user': (response.user), 'state': 'ok'};
    } on Exception catch (e) {
      return {'user': null, 'state': 'failed', 'error': e};
    }
  }

  @override
  Future<void> signOut() async {
    await _supabaseAuth.auth.signOut();
  }

  @override
  Future<Map<String, dynamic>> continueWithGoogle() async {
    GoogleSignIn googleSignIn;
    if (Platform.isAndroid) {
      googleSignIn = GoogleSignIn(
          clientId:
              '438793405537-5tdud4ccocq06nl55becsij4768gdtti.apps.googleusercontent.com',
          serverClientId:
              '438793405537-gbp3g4mpivm763nq8k5jhrc6hckrn6f5.apps.googleusercontent.com');
    } else {
      googleSignIn = GoogleSignIn(
          clientId:
              '438793405537-7sv41nd3qpd04adhop3q7pjefl0eovm9.apps.googleusercontent.com',
          serverClientId:
              '438793405537-gbp3g4mpivm763nq8k5jhrc6hckrn6f5.apps.googleusercontent.com');
    }

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }
    try {
      final response = await _supabaseAuth.auth.signInWithIdToken(
          provider: Provider.google,
          idToken: idToken,
          accessToken: accessToken);

      return {'user': (googleUser), 'state': 'ok', 'uid': (response.user!.id)};
    } on Exception catch (e) {
      return {'user': null, 'state': 'failed', 'error': e};
    }
  }

  @override
  Future<Map<String, dynamic>> continueWithApple(BuildContext context) async {
    if (Platform.isIOS) {
      try {
        final response = await _supabaseAuth.auth.signInWithApple();
        return {'user': (response.user), 'state': 'ok'};
      } on Exception catch (e) {
        return {'user': null, 'state': 'failed', 'error': e};
      }
    }
    if (Platform.isAndroid) {
      try {
        await _supabaseAuth.auth.signInWithOAuth(Provider.apple,
            context: context,
            redirectTo: 'rionegro.turismo://login-callback/login');

        final session = _supabaseAuth.auth.currentSession;

        if (session != null) return {'user': session.user, 'state': 'ok'};

        return {'user': 'apple', 'state': 'failed'};
      } on Exception catch (e) {
        return {'user': null, 'state': 'failed', 'error': e};
      }
    }
    throw Exception('Platform not supported');
  }
}
