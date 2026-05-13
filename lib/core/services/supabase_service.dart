import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://fxjwolhudvawzcihfpxw.supabase.co',
      anonKey: 'sb_publishable_u5n0GyF1C7RJLajA-1nAPA_dJ9qEbK7',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
