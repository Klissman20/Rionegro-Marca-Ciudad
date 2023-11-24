import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rionegro_marca_ciudad/infrastructure/datasources/auth_firebase_datasource_impl.dart';
import 'package:rionegro_marca_ciudad/infrastructure/repositories/auth_firebase_repository_impl.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/supabase_provider.dart';

//repositorio inmutable
final authRepositoryProvider = Provider((ref) {
  final _supabaseAuth = ref.watch(supabaseProvider);
  return AuthSupabaseRepositoryImpl(AuthFirebaseDataSourceImpl(_supabaseAuth));
});
