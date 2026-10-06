"use client";

import { Badge, Notice, Panel } from "@/components/ui";
import { kes, shortHash } from "@/lib/format";
import { useReview } from "@/lib/store";

export default function ChainPage() {
  const { chainRows } = useReview();
  return (
    <div className="space-y-6">
      <header>
        <h1 className="font-display text-4xl text-deep">Chain records</h1>
        <p className="mt-2 text-muted">Base Sepolia demo contract 0x7a3F…9eB2. Nothing on this page is broadcast.</p>
      </header>
      <Notice>
        Public hashes only. Identity documents, selfies, and private statements are not written to the chain.
      </Notice>
      <Panel>
        <ul className="divide-y divide-line">
          {chainRows.map((row) => (
            <li key={row.id} className="flex flex-wrap items-center justify-between gap-3 py-3">
              <div>
                <p className="font-semibold">{row.title}</p>
                <p className="text-sm text-muted">
                  {row.business} · {row.date} · {shortHash(row.tx)}
                </p>
              </div>
              <div className="flex items-center gap-3">
                <span className="font-semibold">{row.amountKes == null ? "Hash" : kes(row.amountKes)}</span>
                <Badge tone="warning">{row.status}</Badge>
              </div>
            </li>
          ))}
        </ul>
      </Panel>
    </div>
  );
}
