# BarakahShares;

**BarakahShares – Halal Equity Crowd** is an AI-powered, Shariah-conscious fractional equity crowdfunding platform designed to connect vetted Kenyan SMEs seeking growth capital with smaller investors who want transparent access to real-business ownership.

Instead of relying on conventional interest-based financing, participating businesses raise expansion capital by offering agreed ownership opportunities to investors through a Musharakah-inspired profit-and-loss-sharing model. Investors can discover vetted businesses, review their financial and compliance information, participate from accessible amounts such as KSh 5,000 or KSh 10,000 through M-Pesa, receive digital ownership records, and track business performance and eligible profit distributions from the BarakahShares mobile app.

## The Problem

Many young Muslims have small amounts of savings but cannot individually access larger business opportunities. At the same time, established SMEs may need growth capital but prefer financing structures that avoid interest-based borrowing.

Informal investment arrangements can also suffer from limited transparency, weak record keeping and difficulty verifying how investor funds are used.

BarakahShares aims to bridge this gap by creating a transparent digital marketplace connecting vetted businesses seeking expansion capital with smaller investors.

## How BarakahShares Works

### 1. Business Onboarding

Existing businesses apply to raise growth capital through BarakahShares.

The platform reviews information such as:

- Business registration and permits
- KRA documentation
- Business-owner identity
- Historical financial information
- M-Pesa Till/payment records where applicable
- Audited or reviewed financial documents
- Business activity and use of funds
- Shariah-screening information

Approved businesses can then create fundraising campaigns.

### 2. Discover Businesses

Investors use the Flutter mobile application to explore approved opportunities.

A campaign can display information such as:

- Business description
- Capital required
- Funding progress
- Proposed ownership structure
- Historical financial information
- Intended use of funds
- Relevant documents
- Risk disclosures
- Shariah-review status

### 3. Invest Through M-Pesa

Investors select an amount and initiate payment using the Safaricom Daraja API.

For the MVP, M-Pesa sandbox transactions and simulated settlement are used.

Once payment is confirmed, the BarakahShares backend updates the internal financial ledger and records the relevant campaign/ownership information.

### 4. Blockchain-Backed Ownership & Audit Trail

BarakahShares uses Solidity smart contracts deployed on Base L2 to create tamper-evident records of important events such as:

- Campaign status
- Contribution records
- Ownership units
- Approved distribution records

Investors can view blockchain transaction references through BaseScan.

Sensitive personal and business information is never stored directly on the public blockchain.

### 5. Document Verification

Confidential documents are stored securely in private storage.

Approved documents can also generate cryptographic fingerprints, with IPFS/Pinata content identifiers and blockchain records helping verify that approved evidence has not been silently altered.

### 6. Profit & Loss Sharing

Businesses periodically submit financial information and supporting evidence.

The backend calculates financial results according to the approved business and investment rules.

Where distributable profit exists, each investor's allocation is calculated according to the agreed ownership/profit-sharing structure.

If the business performs poorly or incurs a genuine loss, investors are not promised a fixed guaranteed return.

### 7. Barakah AI&#x20;

Barakah AI helps make complex investment information easier to understand.

Investors can ask questions such as:

- "Explain this business to me."
- "What are the major risks?"
- "What will my money be used for?"
- "Summarize this month's performance."
- "Why did expenses increase?"
- "Explain my profit allocation."
- "Explain the Musharakah structure in simple terms."

The AI uses authorized BarakahShares information to provide explanations and summaries. It does not make authoritative financial calculations, move investor funds or independently determine Shariah compliance.

## Technology Stack

### Mobile Application

**Flutter + Dart + Riverpod + GoRouter + Dio + Flutter Secure Storage + Supabase Flutter**

Used by investors and business owners for onboarding, discovering opportunities, participating in campaigns, viewing ownership records and monitoring performance.

### Web Administration

**Next.js + TypeScript + Tailwind CSS + shadcn/ui**

Used by administrators, verification officers, accountants and Shariah reviewers for business onboarding, document review, campaign monitoring and audit activities.

### Backend

**Node.js + TypeScript + NestJS**

Provides REST APIs and manages business logic, KYC status, campaign rules, payment confirmations, ownership records, financial ledgers, distributions, notifications and integrations.

### Database & Authentication

**PostgreSQL + Supabase Auth + Row Level Security + Realtime**

Stores users, businesses, campaigns, ownership records, transactions, ledgers and application data.

### Blockchain

**Solidity + Base L2 + OpenZeppelin + Foundry**

Provides smart contracts for campaign states, contribution records, ownership units and approved distribution records.

### Blockchain Integration

**Viem + BaseScan**

Connects the backend to Base and provides blockchain transaction verification.

### Payments

**Safaricom M-Pesa Daraja API + Kotani Pay + Internal Ledger**

Supports M-Pesa payment flows, payout infrastructure where applicable, and auditable financial records. The hackathon MVP uses sandbox and simulated distributions.

### Identity Verification

**Smile ID**

Provides KYC and identity verification for investors and business owners.

### Storage & Document Integrity

**Supabase Private Storage + IPFS/Pinata**

Sensitive documents remain private while cryptographic fingerprints/content identifiers can support document-integrity verification.

### Security

**RBAC + Supabase RLS + Encryption + MFA + Rate Limiting + Secure Secret Management + Audit Logs**

### Monitoring

**Sentry + Structured Logging**

### Testing

**Flutter Tests + NestJS/API Tests + Foundry Smart Contract Tests**

### DevOps

**GitHub + GitHub Actions + Docker**

## Core Users

### Investor

Discovers approved businesses, participates in fundraising opportunities, monitors ownership and business performance, receives applicable distributions and uses Barakah AI to understand investment information.

### Business Owner

Applies for funding, submits business documentation, creates approved campaigns, receives expansion capital and provides ongoing financial/business reporting.

### Platform Administrator

Manages users, campaigns, compliance workflows and system operations.

### Verification / Finance Team

Reviews business documentation, payments, financial information and supporting evidence.

### Shariah Reviewer

Reviews the proposed business activities and investment structures according to the platform's established Shariah-review process.

## Business Model

BarakahShares can generate revenue through clearly disclosed platform services such as:

- Business listing/fundraising fees
- Platform administration fees
- Appropriately structured agency/service fees
- Premium business reporting and technology services

Any real-world fee, investment and profit-sharing structure would require appropriate legal, regulatory and Shariah review before production deployment.

## Vision

BarakahShares aims to make participation in real businesses more accessible, transparent and understandable for smaller investors while helping established SMEs access alternative growth capital.

The long-term vision is to create infrastructure where technology strengthens **Amanah (trust)** through transparent records, verifiable evidence, responsible AI and accountable business ownership.

## MVP Disclaimer

BarakahShares is currently a prototype/hackathon project.

Payment flows, investment distributions and blockchain interactions may use sandbox environments, test networks and simulated transactions. The project does not represent a live investment offering, guaranteed investment return, Shariah certification or regulatory authorization.

