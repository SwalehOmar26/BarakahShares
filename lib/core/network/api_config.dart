/// Backend connection settings.
///
/// Pass values at build time. Do not place secrets in source:
/// `--dart-define=API_BASE_URL=https://api.example.com`
/// `--dart-define=USE_REMOTE_API=true`
/// `--dart-define=CONTRACT_ADDRESS=0x...`
abstract final class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  static const useRemoteApi = bool.fromEnvironment('USE_REMOTE_API');

  static const contractAddress = String.fromEnvironment('CONTRACT_ADDRESS');

  static const chainName = 'Base Sepolia Testnet';

  static const baseScanTxPrefix = 'https://sepolia.basescan.org/tx/';

  static const baseScanAddressPrefix = 'https://sepolia.basescan.org/address/';

  static bool get hasContract => contractAddress.trim().isNotEmpty;
}
