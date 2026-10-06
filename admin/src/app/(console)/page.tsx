"use client";

import Link from "next/link";
import { Notice, Panel } from "@/components/ui";
import { kes } from "@/lib/format";
import { useReview } from "@/lib/store";

export default function OverviewPage() {
  const review = useReview();
  const raised = review.businesses.reduce((sum, item) => sum + item.filledShares * item.sharePriceKes, 0);
  const pendingKyc = review.kyc.filter((item) => item.status === "pending").length;
  const openCampaigns = review.businesses.filter((item) => item.status === "funding").length;
  const pendingPay = review.distributions.filter((item) => item.status === "pending").length;

  return (
    <div className="space-y-6">
      <header>
        <p className="text-sm text-muted">Assalamu Alaikum</p>
        <h1 className="font-display text-4xl text-deep">Review overview</h1>
        <p className="mt-2 max-w-2xl text-muted">
          Campaigns stay closed until Shariah, audit, and evidence checks are recorded. Distributions are profit shares, not interest, and they are not guaranteed.
        </p>
      </header>
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        {[
          ["Capital recorded", kes(raised)],
          ["KYC waiting", String(pendingKyc)],
          ["Campaigns open", String(openCampaigns)],
          ["Distributions pending", String(pendingPay)],
        ].map(([label, value]) => (
          <Panel key={label}>
            <p className="text-sm text-muted">{label}</p>
            <p className="mt-2 text-2xl font-semibold">{value}</p>
          </Panel>
        ))}
      </div>
      <div className="grid gap-4 lg:grid-cols-[1.4fr_1fr]">
        <Panel title="Needs a decision">
          <ul className="space-y-3 text-sm">
            {review.kyc
              .filter((item) => item.status === "pending")
              .map((item) => (
                <li key={item.id} className="flex items-center justify-between gap-3">
                  <span>
                    {item.name}
                    <span className="block text-muted">KYC pending</span>
                  </span>
                  <Link className="font-semibold text-deep" href="/kyc">
                    Review
                  </Link>
                </li>
              ))}
            {review.businesses
              .filter((item) => item.audit !== "verified" || item.shariah !== "verified")
              .map((item) => (
                <li key={item.id} className="flex items-center justify-between gap-3">
                  <span>
                    {item.name}
                    <span className="block text-muted">Checks incomplete</span>
                  </span>
                  <Link className="font-semibold text-deep" href={`/businesses/${item.id}`}>
                    Open
                  </Link>
                </li>
              ))}
          </ul>
        </Panel>
        <Panel title="Review log">
          <ul className="space-y-2 text-sm text-muted">
            {review.log.map((entry) => (
              <li key={entry}>{entry}</li>
            ))}
          </ul>
        </Panel>
      </div>
      <Notice>
        Investments carry risk. Past business performance does not guarantee future distributions. Returns may be zero when a business makes no distributable profit.
      </Notice>
    </div>
  );
}
