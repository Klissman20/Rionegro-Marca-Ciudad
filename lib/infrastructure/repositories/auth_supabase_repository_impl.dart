import 'package:flutter/widgets.dart';
import 'package:rionegro_marca_ciudad/domain/datasources/auth_supabase_datasource.dart';
import 'package:rionegro_marca_ciudad/domain/repositories/auth_supabase_repository.dart';

class AuthSupabaseRepositoryImpl extends AuthSupabaseRepository {
  final AuthSupabaseDataSource datasource;

  AuthSupabaseRepositoryImpl(this.datasource);

  @override
  Future<Map<String, dynamic>> signIn(
      {required String email, required String password}) {
    return datasource.signIn(email: email, password: password);
  }

  @override
  Future<Map<String, dynamic>> signUp(
      {required String email, required String password}) {
    return datasource.signUp(email: email, password: password);
  }

  @override
  Future<void> signOut() {
    return datasource.signOut();
  }

  @override
  Future<Map<String, dynamic>> continueWithGoogle() {
    return datasource.continueWithGoogle();
  }

  @override
  Future<Map<String, dynamic>> continueWithApple(BuildContext context) {
    return datasource.continueWithApple(context);
  }
}
