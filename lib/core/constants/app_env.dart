/// Runtime configuration. Values come from `--dart-define`, never from source.
///
/// Live providers stay off unless the matching `*_ENABLED` flag is true and
/// the required values are present. The demo build does not set them.
abstract final class AppEnv {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const useSupabase = bool.fromEnvironment('USE_SUPABASE');

  static const smilePartnerId = String.fromEnvironment('SMILE_PARTNER_ID');
  static const smileApiKey = String.fromEnvironment('SMILE_API_KEY');
  static const smileEnabled = bool.fromEnvironment('SMILE_ENABLED');

  static const darajaConsumerKey = String.fromEnvironment('DARAJA_CONSUMER_KEY');
  static const darajaConsumerSecret = String.fromEnvironment('DARAJA_CONSUMER_SECRET');
  static const darajaShortCode = String.fromEnvironment('DARAJA_SHORT_CODE');
  static const darajaPasskey = String.fromEnvironment('DARAJA_PASSKEY');
  static const darajaCallbackUrl = String.fromEnvironment('DARAJA_CALLBACK_URL');
  static const darajaEnabled = bool.fromEnvironment('DARAJA_ENABLED');

  static const baseRpcUrl = String.fromEnvironment('BASE_RPC_URL');
  static const chainContract = String.fromEnvironment(
    'CHAIN_CONTRACT_ADDRESS',
    defaultValue: '0x7a3F4c91bE28d0A61c4F9eB2',
  );

  static bool get supabaseCredentials =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static bool get hasSupabase => useSupabase && supabaseCredentials;

  static bool get smileReady =>
      smileEnabled && smilePartnerId.isNotEmpty && smileApiKey.isNotEmpty;

  static bool get darajaReady =>
      darajaEnabled &&
      darajaConsumerKey.isNotEmpty &&
      darajaConsumerSecret.isNotEmpty &&
      darajaShortCode.isNotEmpty &&
      darajaPasskey.isNotEmpty &&
      darajaCallbackUrl.isNotEmpty;

  static bool get baseReady => baseRpcUrl.isNotEmpty;
}
