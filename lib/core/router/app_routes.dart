abstract final class AppRoutes {
  static const splash = '/splash';
  static const landing = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const discover = '/discover';
  static const portfolio = '/portfolio';
  static const profile = '/profile';
  static const kyc = '/kyc';
  static const zakat = '/zakat';
  static const blockchain = '/blockchain';
  static const assistant = '/assistant';
  static const notifications = '/notifications';
  static const settings = '/settings';
  static const help = '/help';
  static const history = '/history';
  static const certificates = '/certificates';
  static const scan = '/scan';

  static String business(String id) => '/business/$id';
  static String invest(String id) => '/business/$id/invest';
  static String pay(
    String id, {
    required double amount,
    required String phone,
  }) {
    return '/business/$id/pay?amount=$amount&phone=${Uri.encodeQueryComponent(phone)}';
  }

  static String receipts(String id) => '/business/$id/receipts';
  static String profit(String id) => '/business/$id/profit';
  static String document(String id) => '/documents/$id';
  static String certificate(String id) => '/certificates/$id';
  static String success(String reference) => '/investment-success/$reference';
}
