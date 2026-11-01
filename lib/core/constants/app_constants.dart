import 'package:flutter/material.dart';

abstract final class AppConstants {
  static const appName = 'BarakahShares';
  static const subtitle = 'HALAL EQUITY CROWD';
  static const tagline = 'Invest • Grow • Share the Barakah';
  static const splashHold = Duration(seconds: 3);
  static const demoPhone = '0712345678';
  static const demoEmail = 'amina@barakahshares.app';
  static const demoPassword = 'Barakah1';
  static const tokenKey = 'auth_token';
  static const sessionKey = 'session_user';
  static const accountsKey = 'demo_accounts';
  static const illustrativeNisabKes = 95000.0;
  static const sharePriceKes = 100.0;

  static const disclaimerReturns =
      'Returns are variable and are not guaranteed. Figures on this screen are illustrative.';
  static const disclaimerCertificate =
      'Demonstration certificate — not legally issued equity.';
  static const disclaimerMarketplace =
      'Opportunity data is illustrative and is not an offer of securities.';
  static const disclaimerAi =
      'Demonstration assistant. It cannot guarantee returns, approve a payment, or issue a Shariah ruling.';
}

abstract final class WidgetKeys {
  static const demoLogin = Key('demo-login-button');
  static const loginPhone = Key('login-phone');
  static const loginEmail = Key('login-email');
  static const loginPassword = Key('login-password');
  static const loginSubmit = Key('login-submit');
  static const registerName = Key('register-name');
  static const registerPhone = Key('register-phone');
  static const registerEmail = Key('register-email');
  static const registerPassword = Key('register-password');
  static const registerConfirm = Key('register-confirm');
  static const registerTerms = Key('register-terms');
  static const registerSubmit = Key('register-submit');
  static const totalInvestment = Key('total-investment');
  static const totalShares = Key('total-shares');
  static const totalBusinesses = Key('total-businesses');
  static const activeCampaigns = Key('active-campaigns');
  static const amount5000 = Key('amount-5000');
  static const investTerms = Key('invest-terms');
  static const investSubmit = Key('invest-submit');
  static const paySuccess = Key('pay-success');
  static const payFail = Key('pay-fail');
  static const payCancel = Key('pay-cancel');
  static const payBack = Key('pay-back');
  static const successHeading = Key('success-heading');
}
