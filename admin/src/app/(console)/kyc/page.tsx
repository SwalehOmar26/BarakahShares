"use client";

import { Badge, markTone, Notice, Panel } from "@/components/ui";
import { useReview } from "@/lib/store";
import type { KycStatus } from "@/lib/types";

const actions: KycStatus[] = ["pending", "verified", "failed"];

export default function KycPage() {
  const review = useReview();
  return (
    <div className="space-y-6">
      <header>
        <h1 className="font-display text-4xl text-deep">KYC queue</h1>
        <p className="mt-2 text-muted">Identity decisions for the demo. National IDs and selfies are not stored or shown.</p>
      </header>
      <Notice>Demo KYC. Marking a case verified does not contact Smile ID.</Notice>
      <div className="space-y-4">
        {review.kyc.map((item) => (
          <Panel key={item.id}>
            <div className="flex flex-wrap items-start justify-between gap-3">
              <div>
                <h2 className="text-lg font-semibold">{item.name}</h2>
                <p className="text-sm text-muted">
                  {item.phone} · {item.role} · {item.submittedAt}
                </p>
                <p className="mt-2 max-w-xl text-sm leading-6">{item.note}</p>
              </div>
              <Badge tone={markTone(item.status)}>{item.status.replaceAll("_", " ")}</Badge>
            </div>
            <div className="mt-4 flex flex-wrap gap-2">
              {actions.map((status) => (
                <button
                  key={status}
                  className="rounded-xl border border-line px-3 py-2 text-sm font-semibold capitalize"
                  onClick={() => review.setKyc(item.id, status)}
                >
                  Mark {status}
                </button>
              ))}
            </div>
          </Panel>
        ))}
      </div>
    </div>
  );
}
