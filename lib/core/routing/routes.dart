abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const kyc = '/kyc';
  static const home = '/home';
  static const discover = '/discover';
  static const portfolio = '/portfolio';
  static const activity = '/activity';
  static const profile = '/profile';
  static const zakat = '/zakat';
  static const success = '/success';
  static const scan = '/scan';
  static const integrations = '/integrations';

  static String business(String id) => '/business/$id';
  static String invest(String id) => '/invest/$id';
  static String holding(String id) => '/portfolio/$id';
  static String receipts(String id) => '/receipts/$id';
  static String profit(String id) => '/profit/$id';
  static String chain(String id) => '/blockchain/$id';
  static String info(String page) => '/info/$page';
}
