export type ReviewMark = "pending" | "verified" | "failed";
export type CampaignStatus = "funding" | "funding_soon" | "funded";
export type KycStatus = "not_started" | "pending" | "verified" | "failed";
export type DistributionStatus = "pending" | "disbursed";

export type Business = {
  id: string;
  name: string;
  location: string;
  owner: string;
  category: string;
  summary: string;
  monthlyProfitKes: number;
  targetKes: number;
  sharePriceKes: number;
  totalShares: number;
  filledShares: number;
  equityOffered: number;
  investorPool: number;
  status: CampaignStatus;
  shariah: ReviewMark;
  audit: ReviewMark;
  halal: ReviewMark;
  cma: ReviewMark;
};

export type KycCase = {
  id: string;
  name: string;
  phone: string;
  role: string;
  status: KycStatus;
  submittedAt: string;
  note: string;
};

export type InvestmentRow = {
  id: string;
  investor: string;
  businessId: string;
  business: string;
  amountKes: number;
  shares: number;
  ownership: string;
  certificate: string;
  status: string;
};

export type EvidenceItem = {
  id: string;
  businessId: string;
  business: string;
  title: string;
  category: string;
  amountKes: number;
  date: string;
  sha256: string;
  cid: string;
  verified: boolean;
};

export type Distribution = {
  id: string;
  businessId: string;
  business: string;
  period: string;
  grossKes: number;
  expensesKes: number;
  ownerPercent: number;
  investorPercent: number;
  sharesOwned: number;
  totalShares: number;
  status: DistributionStatus;
};

export type ChainRow = {
  id: string;
  business: string;
  title: string;
  amountKes: number | null;
  tx: string;
  date: string;
  status: string;
};
