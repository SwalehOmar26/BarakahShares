import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/app_env.dart';

/// Initializes Supabase only when dart-define values are present.
class SupabaseGateway {
  const SupabaseGateway();

  bool get isConfigured => AppEnv.supabaseCredentials;

  Future<void> initialize() async {
    if (!isConfigured || _initialized) return;
    await Supabase.initialize(
      url: AppEnv.supabaseUrl,
      publishableKey: AppEnv.supabaseAnonKey,
    );
    _initialized = true;
  }

  static bool _initialized = false;
}
