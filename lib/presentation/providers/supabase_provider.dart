import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider =
    StateProvider<SupabaseClient>((ref) => Supabase.instance.client);
