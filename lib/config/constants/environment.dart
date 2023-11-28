import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? 'nourl';
  static String supabaseKey = dotenv.env['SUPABASE_KEY'] ?? 'nokey';
  static String googleApiKey = dotenv.env['GOOGLE_API_KEY'] ?? 'nokey';
}
