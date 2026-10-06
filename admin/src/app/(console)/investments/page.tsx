"use client";

import { Panel } from "@/components/ui";
import { kes } from "@/lib/format";
import { useReview } from "@/lib/store";

export default function InvestmentsPage() {
  const { investments } = useReview();
  const total = investments.reduce((sum, item) => sum + item.amountKes, 0);
  return (
    <div className="space-y-6">
      <header>
        <h1 className="font-display text-4xl text-deep">Investments</h1>
        <p className="mt-2 text-muted">Equity holdings recorded in the demo ledger. Total {kes(total)}.</p>
      </header>
      <Panel>
        <div className="overflow-x-auto">
          <table className="w-full min-w-[680px] text-left text-sm">
            <thead className="text-muted">
              <tr>
                <th className="py-2 font-medium">Investor</th>
                <th className="font-medium">Business</th>
                <th className="font-medium">Amount</th>
                <th className="font-medium">Ownership</th>
                <th className="font-medium">Certificate</th>
              </tr>
            </thead>
            <tbody>
              {investments.map((item) => (
                <tr key={item.id} className="border-t border-line">
                  <td className="py-3">{item.investor}</td>
                  <td>{item.business}</td>
                  <td>{kes(item.amountKes)}</td>
                  <td>
                    {item.ownership}
                    <span className="block text-muted">{item.shares} shares</span>
                  </td>
                  <td className="font-medium">{item.certificate}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Panel>
    </div>
  );
}
