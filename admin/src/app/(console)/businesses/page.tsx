"use client";

import Link from "next/link";
import { Badge, markTone, Panel } from "@/components/ui";
import { kes } from "@/lib/format";
import { useReview } from "@/lib/store";

export default function BusinessesPage() {
  const { businesses } = useReview();
  return (
    <div className="space-y-6">
      <header>
        <h1 className="font-display text-4xl text-deep">Businesses</h1>
        <p className="mt-2 text-muted">Vetted halal campaigns. A raise opens only after the checks you record here.</p>
      </header>
      <Panel>
        <div className="overflow-x-auto">
          <table className="w-full min-w-[720px] text-left text-sm">
            <thead className="text-muted">
              <tr>
                <th className="py-2 font-medium">Business</th>
                <th className="font-medium">Raised</th>
                <th className="font-medium">Shariah</th>
                <th className="font-medium">Audit</th>
                <th className="font-medium">Status</th>
                <th />
              </tr>
            </thead>
            <tbody>
              {businesses.map((item) => (
                <tr key={item.id} className="border-t border-line">
                  <td className="py-3">
                    <span className="font-semibold">{item.name}</span>
                    <span className="block text-muted">{item.location}</span>
                  </td>
                  <td>
                    {kes(item.filledShares * item.sharePriceKes)}
                    <span className="block text-muted">of {kes(item.targetKes)}</span>
                  </td>
                  <td>
                    <Badge tone={markTone(item.shariah)}>{item.shariah}</Badge>
                  </td>
                  <td>
                    <Badge tone={markTone(item.audit)}>{item.audit}</Badge>
                  </td>
                  <td>
                    <Badge tone={markTone(item.status)}>{item.status.replaceAll("_", " ")}</Badge>
                  </td>
                  <td className="text-right">
                    <Link className="font-semibold text-deep" href={`/businesses/${item.id}`}>
                      Review
                    </Link>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Panel>
    </div>
  );
}
