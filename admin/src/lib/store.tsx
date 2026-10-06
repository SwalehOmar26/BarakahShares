"use client";

import {
  createContext,
  useContext,
  useMemo,
  useState,
  type ReactNode,
} from "react";
import {
  businesses as seedBusinesses,
  chainRows,
  distributions as seedDistributions,
  evidence as seedEvidence,
  investments,
  kycCases as seedKyc,
} from "./data";
import type {
  Business,
  CampaignStatus,
  Distribution,
  EvidenceItem,
  KycCase,
  KycStatus,
  ReviewMark,
} from "./types";

type CheckField = "shariah" | "audit" | "halal" | "cma";

type ReviewState = {
  businesses: Business[];
  kyc: KycCase[];
  evidence: EvidenceItem[];
  distributions: Distribution[];
  log: string[];
};

type ReviewApi = ReviewState & {
  investments: typeof investments;
  chainRows: typeof chainRows;
  setKyc: (id: string, status: KycStatus) => void;
  setCheck: (id: string, field: CheckField, mark: ReviewMark) => void;
  setCampaign: (id: string, status: CampaignStatus) => void;
  verifyEvidence: (id: string) => boolean;
  recordDisbursement: (id: string) => void;
};

const ReviewContext = createContext<ReviewApi | null>(null);

export function ReviewProvider({ children }: { children: ReactNode }) {
  const [state, setState] = useState<ReviewState>({
    businesses: seedBusinesses,
    kyc: seedKyc,
    evidence: seedEvidence,
    distributions: seedDistributions,
    log: ["Demo queue loaded. No external provider was contacted."],
  });

  const api = useMemo<ReviewApi>(() => {
    return {
      ...state,
      investments,
      chainRows,
      setKyc: (id, status) => {
        setState((current) => ({
          ...current,
          kyc: current.kyc.map((item) => (item.id === id ? { ...item, status } : item)),
          log: [`KYC ${id} marked ${status}. Smile ID was not called.`, ...current.log].slice(0, 8),
        }));
      },
      setCheck: (id, field, mark) => {
        setState((current) => ({
          ...current,
          businesses: current.businesses.map((item) =>
            item.id === id ? { ...item, [field]: mark } : item,
          ),
          log: [`${id} ${field} set to ${mark}.`, ...current.log].slice(0, 8),
        }));
      },
      setCampaign: (id, status) => {
        setState((current) => ({
          ...current,
          businesses: current.businesses.map((item) =>
            item.id === id ? { ...item, status } : item,
          ),
          log: [`Campaign ${id} is now ${status.replaceAll("_", " ")}.`, ...current.log].slice(0, 8),
        }));
      },
      verifyEvidence: (id) => {
        const item = state.evidence.find((row) => row.id === id);
        if (!item) return false;
        setState((current) => ({
          ...current,
          evidence: current.evidence.map((row) =>
            row.id === id ? { ...row, verified: true } : row,
          ),
          log: [
            `Fingerprint for ${item.title} matches the recorded hash. Mock check only.`,
            ...current.log,
          ].slice(0, 8),
        }));
        return item.sha256.length > 0;
      },
      recordDisbursement: (id) => {
        setState((current) => ({
          ...current,
          distributions: current.distributions.map((item) =>
            item.id === id ? { ...item, status: "disbursed" } : item,
          ),
          log: [
            "Disbursement recorded in the demo ledger. No Daraja payout was sent.",
            ...current.log,
          ].slice(0, 8),
        }));
      },
    };
  }, [state]);

  return <ReviewContext.Provider value={api}>{children}</ReviewContext.Provider>;
}

export function useReview() {
  const value = useContext(ReviewContext);
  if (!value) throw new Error("ReviewProvider is missing");
  return value;
}
