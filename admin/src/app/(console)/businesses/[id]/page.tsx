"use client";

import { useParams } from "next/navigation";
import { Badge, markTone, Notice, Panel } from "@/components/ui";
import { kes } from "@/lib/format";
import { useReview } from "@/lib/store";
import type { CampaignStatus, ReviewMark } from "@/lib/types";

const marks: ReviewMark[] = ["pending", "verified", "failed"];
const campaigns: CampaignStatus[] = ["funding_soon", "funding", "funded"];

export default function BusinessReviewPage() {
  const params = useParams<{ id: string }>();
  const review = useReview();
  const business = review.businesses.find((item) => item.id === params.id);

  if (!business) {
    return <p>That campaign is not in the demo catalogue.</p>;
  }

  const raised = business.filledShares * business.sharePriceKes;
  const checks = [
    ["shariah", "Shariah"],
    ["audit", "Audit"],
    ["halal", "Halal certificate"],
    ["cma", "CMA"],
  ] as const;

  return (
    <div className="space-y-6">
      <header>
        <p className="text-sm text-muted">{business.category}</p>
        <h1 className="font-display text-4xl text-deep">{business.name}</h1>
        <p className="mt-2 text-muted">
          {business.location} · Owner {business.owner}
        </p>
      </header>
      <Panel>
        <p className="leading-7">{business.summary}</p>
        <div className="mt-4 grid gap-3 sm:grid-cols-3">
          <Metric label="Monthly profit" value={kes(business.monthlyProfitKes)} />
          <Metric label="Raised" value={`${kes(raised)} / ${kes(business.targetKes)}`} />
          <Metric label="Share price" value={kes(business.sharePriceKes)} />
        </div>
        <p className="mt-4 text-sm text-muted">
          {business.equityOffered}% equity offered. Investor profit pool {business.investorPool}%. This is ownership, not a loan.
        </p>
      </Panel>
      <Panel title="Checks">
        <div className="space-y-4">
          {checks.map(([field, label]) => (
            <div key={field} className="flex flex-wrap items-center justify-between gap-3">
              <div className="flex items-center gap-2">
                <span className="font-semibold">{label}</span>
                <Badge tone={markTone(business[field])}>{business[field]}</Badge>
              </div>
              <div className="flex gap-2">
                {marks.map((mark) => (
                  <button
                    key={mark}
                    className="rounded-lg border border-line px-3 py-2 text-sm capitalize"
                    onClick={() => review.setCheck(business.id, field, mark)}
                  >
                    {mark}
                  </button>
                ))}
              </div>
            </div>
          ))}
        </div>
      </Panel>
      <Panel title="Campaign">
        <div className="flex flex-wrap gap-2">
          {campaigns.map((status) => (
            <button
              key={status}
              className={`rounded-xl px-4 py-2 text-sm font-semibold ${
                business.status === status ? "bg-deep text-white" : "border border-line"
              }`}
              onClick={() => review.setCampaign(business.id, status)}
            >
              {status.replaceAll("_", " ")}
            </button>
          ))}
        </div>
        <p className="mt-3 text-sm text-muted">
          {business.filledShares} / {business.totalShares} shares filled. Opening a campaign here updates the demo queue only.
        </p>
      </Panel>
      <Notice>
        Permits, KRA records, and statements stay private. This screen records a decision. It does not publish the file.
      </Notice>
    </div>
  );
}

function Metric({ label, value }: { label: string; value: string }) {
  return (
    <div>
      <p className="text-sm text-muted">{label}</p>
      <p className="font-semibold">{value}</p>
    </div>
  );
}
