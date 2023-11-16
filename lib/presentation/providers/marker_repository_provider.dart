import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rionegro_marca_ciudad/infrastructure/datasources/marker_datasource_impl.dart';
import 'package:rionegro_marca_ciudad/infrastructure/repositories/marker_repository_impl.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/supabase_provider.dart';

final markerRepositoryProvider = Provider((ref) {
  final supabaseClient = ref.watch(supabaseProvider);
  return MarkerRepositoryImpl(
      datasource: MarkerDatasourceImpl(supabaseClient: supabaseClient));
});
