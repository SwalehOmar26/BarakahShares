"use client";

import { Badge, markTone, Notice, Panel } from "@/components/ui";
import { poolAmount, yourDistribution } from "@/lib/data";
import { kes } from "@/lib/format";
import { useReview } from "@/lib/store";

export default function DistributionsPage() {
  const review = useReview();
  return (
    <div className="space-y-6">
      <header>
        <h1 className="font-display text-4xl text-deep">Distributions</h1>
        <p className="mt-2 text-muted">
          Illustrative profit splits. Recording a disbursement does not send M-PESA.
        </p>
      </header>
      <Notice>Illustrative distribution based on the approved monthly profit. This is not interest and it is not guaranteed.</Notice>
      <div className="space-y-4">
        {review.distributions.map((item) => {
          const net = item.grossKes - item.expensesKes;
          const owner = poolAmount(net, item.ownerPercent);
          const pool = poolAmount(net, item.investorPercent);
          const yours = yourDistribution(item);
          return (
            <Panel key={item.id}>
              <div className="flex flex-wrap items-start justify-between gap-3">
                <div>
                  <h2 className="text-lg font-semibold">{item.business}</h2>
                  <p className="text-sm text-muted">{item.period}</p>
                </div>
                <Badge tone={markTone(item.status)}>{item.status}</Badge>
              </div>
              <dl className="mt-4 grid gap-2 text-sm sm:grid-cols-2">
                <Row label="Gross sales" value={kes(item.grossKes)} />
                <Row label="Expenses" value={kes(item.expensesKes)} />
                <Row label="Net profit" value={kes(net)} />
                <Row label="Owner share" value={kes(owner)} />
                <Row label="Investor pool" value={kes(pool)} />
                <Row label="Sample investor" value={kes(yours)} />
              </dl>
              {item.status === "pending" ? (
                <button
                  className="mt-4 rounded-xl border border-deep px-4 py-2 text-sm font-semibold text-deep"
                  onClick={() => review.recordDisbursement(item.id)}
                >
                  Record demo disbursement
                </button>
              ) : null}
            </Panel>
          );
        })}
      </div>
    </div>
  );
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between gap-3 border-b border-line py-2">
      <dt className="text-muted">{label}</dt>
      <dd className="font-semibold">{value}</dd>
    </div>
  );
}
