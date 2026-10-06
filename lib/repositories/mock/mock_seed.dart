import '../../core/constants/demo_account.dart';
import '../../models/blockchain_transaction.dart';
import '../../models/business.dart';
import '../../models/enums.dart';
import '../../models/investment.dart';
import '../../models/investor.dart';
import '../../models/monthly_point.dart';
import '../../models/profit_distribution.dart';
import '../../models/receipt.dart';
import '../../models/records.dart';
import '../../models/share_certificate.dart';

abstract final class ChainDemo {
  static const network = 'Base Sepolia Testnet';
  static const contract = '0x7a3F4c91bE28d0A61c4F9eB2';
  static const contractShort = '0x7a3F...9eB2';
  static const status = 'Demo Contract';
}

abstract final class MockSeed {
  static const investor = Investor(
    id: DemoAccount.investorId,
    name: DemoAccount.name,
    phone: DemoAccount.phone,
    role: UserRole.youthInvestor,
    kycStatus: KycStatus.verified,
  );

  static const dividendHistory = [600, 750, 800, 700, 650, 700];

  static List<Business> businesses() => [
    Business(
      id: 'al-yusra',
      name: 'Al-Yusra Restaurant',
      location: 'Eastleigh, Nairobi',
      category: 'Dining',
      summary: 'Operating halal restaurant raising a minority equity stake.',
      overview: 'Al-Yusra is an operating restaurant in Eastleigh serving a halal menu to a dense trading neighbourhood. The campaign offers 40% of the equity so the business can refit the dining room and add seating. Day-to-day control stays with the owner.',
      whyThisBusiness: 'The outlet already trades, holds a halal certificate, and has an audited sales trail. Investors share in profit only. A month with no distributable profit pays nothing.',
      fundingPurpose: 'Dining-room refit, additional seating, and working capital for inventory. Drawdowns are matched to approved expense categories.',
      ownerName: 'Ahmed',
      ownerVerified: true,
      monthlyProfitKes: 412000,
      illustrativePerShareKes: 800,
      artworkKey: 'dining',
      shariahApproved: true,
      audited: true,
      halalCertified: true,
      cmaVerified: true,
      campaign: const Campaign(
        id: 'camp-alyusra',
        businessId: 'al-yusra',
        targetKes: 2000000,
        sharePriceKes: 10000,
        totalShares: 200,
        filledShares: 132,
        equityOfferedPercent: 40,
        investorPoolPercent: 40,
        status: CampaignStatus.funding,
      ),
      trend: _trend(
        const [360000, 380000, 400000, 385000, 420000, 400000],
        const [460000, 480000, 510000, 490000, 530000, 500000],
      ),
    ),
    Business(
      id: 'amani-abaya',
      name: 'Amani Abaya Shop',
      location: 'South C, Nairobi',
      category: 'Retail',
      summary: 'Halal modest-wear retailer funding inventory for peak season.',
      overview: 'Amani Abaya Shop sells ready-to-wear modest clothing from South C. The raise funds a seasonal inventory purchase. Investors hold equity and share profit. This is not a stock loan.',
      whyThisBusiness: 'Repeat retail trade, a verified halal supply note, and an audit pack are on file. Distributions follow approved profit, and can be zero.',
      fundingPurpose: 'Seasonal inventory and a small shop refit. Supplier invoices stay in the private evidence file.',
      ownerName: 'Fatuma Noor',
      ownerVerified: true,
      monthlyProfitKes: 150000,
      illustrativePerShareKes: 550,
      artworkKey: 'retail',
      shariahApproved: true,
      audited: true,
      halalCertified: true,
      cmaVerified: true,
      campaign: const Campaign(
        id: 'camp-amani',
        businessId: 'amani-abaya',
        targetKes: 600000,
        sharePriceKes: 10000,
        totalShares: 60,
        filledShares: 36,
        equityOfferedPercent: 30,
        investorPoolPercent: 40,
        status: CampaignStatus.funding,
      ),
      trend: _trend(
        const [90000, 110000, 120000, 105000, 140000, 82500],
        const [160000, 180000, 190000, 170000, 210000, 120000],
      ),
    ),
    Business(
      id: 'ruai-poultry',
      name: 'Ruai Halal Poultry Farm',
      location: 'Ruai, Nairobi',
      category: 'Agriculture',
      summary: 'Halal poultry farm expanding the flock under an audited cycle.',
      overview: 'Ruai Halal Poultry Farm currently keeps 2,000 birds and is raising capital toward a 5,000-bird operating target. Equity holders share in profit from completed cycles.',
      whyThisBusiness: 'The farm has a halal process note and an audit of the current flock cycle. Expansion risk sits with the business, and investors are not lenders.',
      fundingPurpose: 'Housing, feed working capital, and chicks for the next cycle. Feed and licensing receipts are filed as private evidence.',
      ownerName: 'Ibrahim Otieno',
      ownerVerified: true,
      monthlyProfitKes: 180000,
      illustrativePerShareKes: 800,
      artworkKey: 'agriculture',
      operatingNote: '2,000 birds today · 5,000 bird target',
      shariahApproved: true,
      audited: true,
      halalCertified: true,
      cmaVerified: true,
      campaign: const Campaign(
        id: 'camp-ruai',
        businessId: 'ruai-poultry',
        targetKes: 1250000,
        sharePriceKes: 10000,
        totalShares: 125,
        filledShares: 50,
        equityOfferedPercent: 35,
        investorPoolPercent: 40,
        status: CampaignStatus.funding,
      ),
      trend: _trend(
        const [140000, 155000, 160000, 170000, 190000, 250000],
        const [220000, 240000, 250000, 260000, 290000, 320000],
      ),
    ),
    Business(
      id: 'halal-logistics',
      name: 'Halal Logistics',
      location: 'Eastleigh → Garissa',
      category: 'Logistics',
      summary: 'Corridor haulage for halal goods. The raise has not opened.',
      overview: 'Halal Logistics moves goods on the Eastleigh to Garissa corridor. The campaign is marked funding soon while the audit pack is completed. No shares are offered yet.',
      whyThisBusiness: 'The route serves halal traders who already pay for scheduled trips. An illustrative distribution will be published only after the audit is verified.',
      fundingPurpose: 'A second vehicle deposit and route working capital, once the campaign opens.',
      ownerName: 'Yusuf Abdi',
      ownerVerified: true,
      monthlyProfitKes: 96000,
      artworkKey: 'logistics',
      shariahApproved: true,
      audited: false,
      halalCertified: true,
      cmaVerified: false,
      campaign: const Campaign(
        id: 'camp-logistics',
        businessId: 'halal-logistics',
        targetKes: 900000,
        sharePriceKes: 10000,
        totalShares: 90,
        filledShares: 0,
        equityOfferedPercent: 25,
        investorPoolPercent: 40,
        status: CampaignStatus.fundingSoon,
      ),
      trend: _trend(
        const [70000, 80000, 84000, 90000, 88000, 96000],
        const [140000, 150000, 155000, 160000, 158000, 170000],
      ),
    ),
  ];

  static List<Investment> investments() => [
    Investment(
      id: 'inv-alyusra',
      investorId: investor.id,
      businessId: 'al-yusra',
      businessName: 'Al-Yusra Restaurant',
      amountKes: 10000,
      shareCount: 1,
      ownershipPercent: 0.5,
      certificateCode: 'BARAKAH-SHARE-0088',
      illustrativeMonthlyKes: 800,
      investedAt: DateTime.utc(2026, 9, 12),
      status: 'Active',
      txHash: '0x7a3f91c0b21e4d88aa01c4e29b7d10aa88c31e02',
    ),
    Investment(
      id: 'inv-amani',
      investorId: investor.id,
      businessId: 'amani-abaya',
      businessName: 'Amani Abaya Shop',
      amountKes: 20000,
      shareCount: 2,
      ownershipPercent: 3.3333333333,
      certificateCode: 'BARAKAH-SHARE-0114',
      illustrativeMonthlyKes: 1100,
      investedAt: DateTime.utc(2026, 8, 2),
      status: 'Active',
      txHash: '0x44ab9012cc7819aa0012ff33ab9012887710cd12',
    ),
    Investment(
      id: 'inv-ruai',
      investorId: investor.id,
      businessId: 'ruai-poultry',
      businessName: 'Ruai Halal Poultry Farm',
      amountKes: 20000,
      shareCount: 2,
      ownershipPercent: 1.6,
      certificateCode: 'BARAKAH-SHARE-0142',
      illustrativeMonthlyKes: 1600,
      investedAt: DateTime.utc(2026, 7, 18),
      status: 'Active',
      txHash: '0x55cd1288aa019922bb7710ee34aa12887710ab34',
    ),
  ];

  static List<ShareCertificate> certificates() => [
    ShareCertificate(
      code: 'BARAKAH-SHARE-0088',
      investmentId: 'inv-alyusra',
      investorName: investor.name,
      businessId: 'al-yusra',
      businessName: 'Al-Yusra Restaurant',
      investmentKes: 10000,
      ownershipPercent: 0.5,
      issuedAt: DateTime.utc(2026, 9, 12),
      status: 'Verified',
    ),
    ShareCertificate(
      code: 'BARAKAH-SHARE-0114',
      investmentId: 'inv-amani',
      investorName: investor.name,
      businessId: 'amani-abaya',
      businessName: 'Amani Abaya Shop',
      investmentKes: 20000,
      ownershipPercent: 3.3333333333,
      issuedAt: DateTime.utc(2026, 8, 2),
      status: 'Verified',
    ),
    ShareCertificate(
      code: 'BARAKAH-SHARE-0142',
      investmentId: 'inv-ruai',
      investorName: investor.name,
      businessId: 'ruai-poultry',
      businessName: 'Ruai Halal Poultry Farm',
      investmentKes: 20000,
      ownershipPercent: 1.6,
      issuedAt: DateTime.utc(2026, 7, 18),
      status: 'Verified',
    ),
  ];

  static List<ProfitDistribution> profits() => const [
    ProfitDistribution(
      id: 'profit-alyusra',
      businessId: 'al-yusra',
      periodLabel: 'June 2026',
      grossSalesKes: 500000,
      expensesKes: 100000,
      ownerPercent: 60,
      investorPoolPercent: 40,
      sharesOwned: 1,
      totalShares: 200,
      status: DistributionStatus.pending,
    ),
    ProfitDistribution(
      id: 'profit-amani',
      businessId: 'amani-abaya',
      periodLabel: 'June 2026',
      grossSalesKes: 120000,
      expensesKes: 37500,
      ownerPercent: 60,
      investorPoolPercent: 40,
      sharesOwned: 2,
      totalShares: 60,
      status: DistributionStatus.disbursed,
    ),
    ProfitDistribution(
      id: 'profit-ruai',
      businessId: 'ruai-poultry',
      periodLabel: 'June 2026',
      grossSalesKes: 320000,
      expensesKes: 70000,
      ownerPercent: 60,
      investorPoolPercent: 40,
      sharesOwned: 2,
      totalShares: 125,
      status: DistributionStatus.disbursed,
    ),
  ];

  static List<Receipt> receipts() => [
    _receipt(
      'rc-rent',
      'al-yusra',
      'Rent',
      'Premises',
      60000,
      DateTime.utc(2026, 6, 2),
      'QmYusraRent8f3a21c9b71',
      'a3f1c9e21b0044aa9812cc771090ab12ef44556677889900aabbccddeeff0011',
    ),
    _receipt(
      'rc-stock',
      'al-yusra',
      'Stock',
      'Inventory',
      80000,
      DateTime.utc(2026, 6, 8),
      'QmYusraStock4b91e20aa12',
      'b41d88aa0912cc3400ef12ab77889910aabbccdd11223344556677889900ab12',
    ),
    _receipt(
      'rc-licence',
      'al-yusra',
      'Licensing',
      'Licensing',
      10000,
      DateTime.utc(2026, 6, 14),
      'QmYusraLicense77c31a90',
      'c55e12ab90ff44120098aa7711bb22cc33dd44ee55ff66778899aabbccddeeff',
    ),
    _receipt(
      'rc-amani',
      'amani-abaya',
      'Stock',
      'Inventory',
      45000,
      DateTime.utc(2026, 6, 11),
      'QmAmaniStock91aa2201',
      'd66f23bc11aa55231109bb8822cc33dd44ee55ff66778899aabbccddeeff0012',
    ),
    _receipt(
      'rc-ruai',
      'ruai-poultry',
      'Feed',
      'Operations',
      70000,
      DateTime.utc(2026, 6, 18),
      'QmRuaiFeed33bb7712aa',
      'e77a34cd22bb66342210cc9933dd44ee55ff66778899aabbccddeeff00123456',
    ),
  ];

  static List<BusinessDocument> documents() => [
    _doc(
      'doc-permit',
      'al-yusra',
      'Business Permit',
      DateTime.utc(2026, 1, 15),
      'QmYusraPermit11aa90',
      '1111aa22bb33cc44dd55ee66ff77889900aabbccddeeff112233445566778899',
    ),
    _doc(
      'doc-kra',
      'al-yusra',
      'KRA Compliance',
      DateTime.utc(2026, 3, 2),
      'QmYusraKra22bb81',
      '2222bb33cc44dd55ee66ff77889900aabbccddeeff11223344556677889900aa',
    ),
    _doc(
      'doc-halal',
      'al-yusra',
      'Halal Certificate',
      DateTime.utc(2026, 2, 20),
      'QmYusraHalal33cc72',
      '3333cc44dd55ee66ff77889900aabbccddeeff11223344556677889900aabb11',
    ),
    _doc(
      'doc-mpesa',
      'al-yusra',
      '6-Month M-Pesa Till Statement',
      DateTime.utc(2026, 6, 30),
      'QmYusraMpesa44dd63',
      '4444dd55ee66ff77889900aabbccddeeff11223344556677889900aabbcc22',
    ),
    _doc(
      'doc-audit',
      'al-yusra',
      'Audit Report',
      DateTime.utc(2026, 7, 8),
      'QmYusraAudit55ee54',
      '5555ee66ff77889900aabbccddeeff11223344556677889900aabbccddee33',
    ),
    _doc(
      'doc-amani-permit',
      'amani-abaya',
      'Business Permit',
      DateTime.utc(2026, 2, 1),
      'QmAmaniPermit66',
      '6666ff77889900aabbccddeeff11223344556677889900aabbccddeeff4455',
    ),
    _doc(
      'doc-amani-halal',
      'amani-abaya',
      'Halal Certificate',
      DateTime.utc(2026, 2, 11),
      'QmAmaniHalal77',
      '7777889900aabbccddeeff11223344556677889900aabbccddeeff55667788',
    ),
    _doc(
      'doc-ruai-permit',
      'ruai-poultry',
      'Business Permit',
      DateTime.utc(2026, 1, 9),
      'QmRuaiPermit88',
      '88889900aabbccddeeff11223344556677889900aabbccddeeff66778899aa',
    ),
    _doc(
      'doc-ruai-halal',
      'ruai-poultry',
      'Halal Certificate',
      DateTime.utc(2026, 3, 4),
      'QmRuaiHalal99',
      '999900aabbccddeeff11223344556677889900aabbccddeeff77889900aabbcc',
    ),
    _doc(
      'doc-log-halal',
      'halal-logistics',
      'Halal Certificate',
      DateTime.utc(2026, 4, 12),
      'QmLogHalal10',
      'aaaa00bbccddeeff11223344556677889900aabbccddeeff889900aabbccddee',
    ),
  ];

  static List<BlockchainTransaction> transactions() => [
    BlockchainTransaction(
      id: 'tx-invest-alyusra',
      businessId: 'al-yusra',
      type: ChainTxType.investment,
      title: 'Investment',
      amountKes: 10000,
      date: DateTime.utc(2026, 9, 12),
      status: 'Confirmed',
      txHash: '0x7a3f91c0b21e4d88aa01c4e29b7d10aa88c31e02',
    ),
    BlockchainTransaction(
      id: 'tx-div-alyusra',
      businessId: 'al-yusra',
      type: ChainTxType.dividend,
      title: 'Dividend Distribution',
      amountKes: 800,
      date: DateTime.utc(2026, 9, 30),
      status: 'Confirmed',
      txHash: '0x91ab44e21890cc7712ab3490dd18ac771092ab31',
    ),
    BlockchainTransaction(
      id: 'tx-hash-alyusra',
      businessId: 'al-yusra',
      type: ChainTxType.receiptHash,
      title: 'Receipt Hash Anchored',
      date: DateTime.utc(2026, 6, 30),
      status: 'Confirmed',
      txHash: '0xabcd12ef445090aa7812cc3490ab12ef7781aa09',
      anchoredHash:
          'abc1239f4c21e88a01bb77c0d4e219ab44f0c1d2a8e77b901234abcd5678ef01',
    ),
    BlockchainTransaction(
      id: 'tx-invest-amani',
      businessId: 'amani-abaya',
      type: ChainTxType.investment,
      title: 'Investment',
      amountKes: 20000,
      date: DateTime.utc(2026, 8, 2),
      status: 'Confirmed',
      txHash: '0x44ab9012cc7819aa0012ff33ab9012887710cd12',
    ),
    BlockchainTransaction(
      id: 'tx-invest-ruai',
      businessId: 'ruai-poultry',
      type: ChainTxType.investment,
      title: 'Investment',
      amountKes: 20000,
      date: DateTime.utc(2026, 7, 18),
      status: 'Confirmed',
      txHash: '0x55cd1288aa019922bb7710ee34aa12887710ab34',
    ),
  ];

  static List<ActivityItem> activities() => [
    ActivityItem(
      id: 'act-1',
      kind: ActivityKind.dividend,
      title: 'Dividend received',
      subtitle: 'Al-Yusra Restaurant · illustrative KES 800',
      date: DateTime.utc(2026, 9, 30),
      businessId: 'al-yusra',
    ),
    ActivityItem(
      id: 'act-2',
      kind: ActivityKind.certificate,
      title: 'Certificate issued',
      subtitle: 'BARAKAH-SHARE-0088',
      date: DateTime.utc(2026, 9, 12),
      businessId: 'al-yusra',
    ),
    ActivityItem(
      id: 'act-3',
      kind: ActivityKind.investment,
      title: 'Investment successful',
      subtitle: 'Al-Yusra Restaurant · KES 10,000',
      date: DateTime.utc(2026, 9, 12),
      businessId: 'al-yusra',
    ),
    ActivityItem(
      id: 'act-4',
      kind: ActivityKind.investment,
      title: 'Investment successful',
      subtitle: 'Amani Abaya Shop · KES 20,000',
      date: DateTime.utc(2026, 8, 2),
      businessId: 'amani-abaya',
    ),
  ];

  static List<MonthlyPoint> _trend(List<int> profit, List<int> sales) {
    const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    return [
      for (var i = 0; i < labels.length; i++)
        MonthlyPoint(label: labels[i], primary: profit[i], secondary: sales[i]),
    ];
  }

  static Receipt _receipt(
    String id,
    String businessId,
    String title,
    String category,
    int amount,
    DateTime date,
    String cid,
    String hash,
  ) {
    return Receipt(
      id: id,
      businessId: businessId,
      title: title,
      category: category,
      amountKes: amount,
      date: date,
      status: VerificationStatus.verified,
      ipfsCid: cid,
      sha256: hash,
    );
  }

  static BusinessDocument _doc(
    String id,
    String businessId,
    String title,
    DateTime date,
    String cid,
    String hash,
  ) {
    return BusinessDocument(
      id: id,
      businessId: businessId,
      title: title,
      status: VerificationStatus.verified,
      ipfsCid: cid,
      sha256: hash,
      issuedOn: date,
    );
  }
}
