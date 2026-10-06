"use client";

import { useState } from "react";
import { Badge, Notice, Panel } from "@/components/ui";
import { kes, shortHash } from "@/lib/format";
import { useReview } from "@/lib/store";

export default function EvidencePage() {
  const review = useReview();
  const [message, setMessage] = useState("");

  return (
    <div className="space-y-6">
      <header>
        <h1 className="font-display text-4xl text-deep">Evidence</h1>
        <p className="mt-2 text-muted">
          Approved expenses. The receipt stays private. Only the fingerprint can be compared.
        </p>
      </header>
      <Notice>Verification here is a mock comparison against the stored hash. No IPFS download runs.</Notice>
      {message ? <p className="text-sm font-semibold text-success">{message}</p> : null}
      <div className="space-y-4">
        {review.evidence.map((item) => (
          <Panel key={item.id}>
            <div className="flex flex-wrap items-start justify-between gap-3">
              <div>
                <h2 className="text-lg font-semibold">
                  {item.title} · {kes(item.amountKes)}
                </h2>
                <p className="text-sm text-muted">
                  {item.business} · {item.category} · {item.date}
                </p>
                <p className="mt-2 text-sm">SHA-256 {shortHash(item.sha256)}</p>
                <p className="text-sm">IPFS CID {shortHash(item.cid)}</p>
              </div>
              <Badge tone={item.verified ? "success" : "warning"}>
                {item.verified ? "Verified" : "Pending"}
              </Badge>
            </div>
            <button
              className="mt-4 rounded-xl bg-deep px-4 py-2 text-sm font-semibold text-white"
              onClick={() => {
                const matches = review.verifyEvidence(item.id);
                setMessage(
                  matches
                    ? "Document fingerprint matches the recorded hash. Status: Verified. Mock verification only."
                    : "Document fingerprint does not match.",
                );
              }}
            >
              Verify evidence
            </button>
          </Panel>
        ))}
      </div>
    </div>
  );
}
