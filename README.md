# BarakahShares — Halal Equity Crowd

Youth-investor mobile app for discovering vetted halal businesses, buying a fractional equity stake, and following ownership, evidence, and profit distributions.

This repository is the **mobile application only**. Payments, KYC, blockchain writes, and document storage are mocked behind service interfaces so a later phase can connect real providers without rebuilding the UI.

## Features

- Splash, login, registration, and demo KYC
- Investor home with portfolio value, dividend history, holdings, and activity
- Discover screen with search and filters for vetted businesses
- Business detail: overview, financial trend, private evidence, campaign progress
- Investment confirmation with a simulated M-PESA STK push
- Success confirmation, portfolio, and a QR share certificate
- Receipts and mock fingerprint verification
- Profit allocation with an illustrative distribution
- Zakat calculator (informational, not a ruling)
- Profile, security preferences, and legal notes
- Blockchain verification screen for the demo Base Sepolia contract
- Light and dark themes

Distributions are described as illustrative. The interface does not promise a return, and it treats the product as equity and profit-sharing rather than a loan or interest.

## Tech stack

- Flutter and Dart
- Riverpod for state
- GoRouter for navigation
- Dio, reserved for later HTTP APIs
- Supabase Flutter, initialized only when dart-define values are present
- Flutter Secure Storage for a demo session token
- fl_chart, qr_flutter, mobile_scanner, intl, Google Fonts

## Architecture

Feature-first UI with shared models, repository interfaces, and Riverpod providers.

```
lib/
  app.dart
  main.dart
  core/            theme, routing, widgets, env, formatters
  models/          immutable domain models
  repositories/    service interfaces
  repositories/mock/   in-memory demo data and adapters
  providers/       Riverpod providers
  features/        one folder per screen group
```

Widgets talk to providers. Providers talk to repositories. Mock repositories talk to a single in-memory `DemoDatabase`. Replacing a mock with a live adapter means implementing the same interface and overriding the provider.

## Install and run

Install the Flutter SDK (this project was built with Flutter 3.47 / Dart 3.13), then:

```bash
flutter pub get
flutter run
```

On a phone or emulator:

```bash
flutter run -d android
flutter run -d ios
```

Chrome is useful for a layout pass. Certificate scanning needs a device camera; the scan screen also accepts a certificate code by hand.

## Tests

```bash
flutter analyze
flutter test
```

Widget tests cover login, discover, business details, the investment flow, portfolio, profit allocation, and the share certificate.

Unit tests cover:

- KES 10,000 / KES 2,000,000 = 0.5% ownership
- KES 400,000 × 40% = KES 160,000 investor pool
- KES 160,000 / 200 shares = KES 800
- KES 50,000 × 2.5% = KES 1,250 zakat
- Campaign progress of 132 / 200 shares

## Demo account

This is a demonstration login, not a production credential.

| Field | Value |
| --- | --- |
| Phone | +254700000000 |
| Password | Demo1234 |
| Name | Abdullahi Hassan |
| KYC | Verified |
| Portfolio | KES 50,000 |
| Dividends recorded | KES 4,200 |
| Active businesses | 3 |

You can also create an account. That path starts at demo KYC and does not call Smile ID.

## Mock integrations

| Area | What the demo does | Later adapter |
| --- | --- | --- |
| Auth | In-memory accounts and a session token | Supabase Auth |
| KYC | Status transitions labelled Demo KYC | Smile ID |
| Businesses, portfolio, profits, certificates | Local seed data | Supabase |
| Payment | Simulated STK push, labelled Demo Escrow Contract | Daraja API |
| Documents | Private preview plus a hash comparison | Private storage and IPFS pinning |
| Blockchain | Sample Base Sepolia hashes | Viem / Base / contract calls |
| Zakat and waqf | Local calculation and a confirmation dialog | A real disbursement flow, with Shariah review |

No M-PESA charge, Smile ID check, IPFS upload, or chain transaction is sent.

## Environment variables

Secrets are not stored in source. Pass the public Supabase values at run time:

```bash
flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLISHABLE_KEY
```

If either value is empty, the app skips `Supabase.initialize` and keeps using the mock repositories. See `.env.example` for the variable names.

## Navigation

Authenticated tabs: Home, Discover, Portfolio, Activity, Profile.

Detail routes include `/business/:id`, `/invest/:id`, `/portfolio/:id`, `/receipts/:id`, `/profit/:id`, `/blockchain/:id`, `/zakat`, `/kyc`, and `/success`.

Suggested demo path: splash, login, home, discover, Al-Yusra Restaurant, invest, simulated M-PESA, success, portfolio, certificate, receipts, profit, blockchain, zakat, profile.

## Deployment preparation

- Set a real application id before store release (`com.barakahshares` is the current placeholder).
- Supply Supabase URL and publishable key with `--dart-define` or your CI secret store.
- Replace each mock in `lib/repositories/mock/` with a live implementation of the matching interface.
- Keep identity documents, selfies, KRA records, and private statements off public chains. Anchor a hash only.
- Add store listings, privacy policy hosting, and a regulated offer process before any public raise.
- Camera permission is declared for certificate QR scanning.

## Security notes

- Demo password lives in `lib/core/constants/demo_account.dart` only so reviewers can sign in. Do not reuse it in production.
- The session token written to secure storage is an opaque demo id, not a password.
- Private document sheets say the file is withheld. The blockchain screen shows a fingerprint and a demo transaction hash.
- Risk copy is fixed in `lib/core/constants/app_copy.dart`: investments can return nothing when a business has no distributable profit.

## Phase 2 — review console and provider gates

The admin app lives in `admin/`. It is a compliance console for the same demo campaigns: businesses, KYC, investments, evidence fingerprints, profit splits, and chain records.

```bash
cd admin
npm install
npm run dev
```

Open http://localhost:3000/login.

| Field | Value |
| --- | --- |
| Email | reviewer@barakahshares.test |
| Password | Demo1234 |

Review actions update the browser session only. They do not call Smile ID, Daraja, or a chain.

The phone app keeps the mock path unless you opt in with `--dart-define`. See `.env.example`.

| Flag | Effect |
| --- | --- |
| `USE_SUPABASE` plus URL and anon key | Initializes Supabase. Table shape is in `supabase/migrations/0001_core.sql`. |
| `SMILE_ENABLED` plus partner id and API key | Selects the Smile ID adapter, which still refuses to upload an ID or selfie from this app. |
| `DARAJA_ENABLED` plus consumer key, secret, short code, passkey, and callback URL | Sends a sandbox STK push instead of the simulated one. |
| `BASE_RPC_URL` | Enables a read-only Base JSON-RPC client. The app has no signing key. |

Profile → Integrations shows whether those values are present. Identity images and private statements are not columns in the SQL schema.
