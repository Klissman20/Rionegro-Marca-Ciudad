import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rionegro_marca_ciudad/infrastructure/datasources/event_datasource_impl.dart';
import 'package:rionegro_marca_ciudad/presentation/providers/supabase_provider.dart';

final eventRepositoryProvider = Provider((ref) {
  final supabaseClient = ref.watch(supabaseProvider);
  return EventDataSourceImpl(supabaseClient);
});
