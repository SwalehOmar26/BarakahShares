import type { ReactNode } from "react";

const tones = {
  success: "bg-success-soft text-success",
  warning: "bg-warning-soft text-warning",
  danger: "bg-danger-soft text-danger",
  gold: "bg-gold-wash text-deep",
  neutral: "bg-ivory text-muted",
};

export function Badge({
  children,
  tone = "neutral",
}: {
  children: ReactNode;
  tone?: keyof typeof tones;
}) {
  return (
    <span className={`inline-flex items-center gap-1 rounded-full px-2 py-1 text-xs font-semibold ${tones[tone]}`}>
      {children}
    </span>
  );
}

export function markTone(mark: string): keyof typeof tones {
  if (mark === "verified" || mark === "disbursed" || mark === "funding") return "success";
  if (mark === "failed") return "danger";
  if (mark === "pending" || mark === "funding_soon") return "warning";
  return "neutral";
}

export function Panel({
  title,
  children,
  action,
}: {
  title?: string;
  children: ReactNode;
  action?: ReactNode;
}) {
  return (
    <section className="rounded-2xl border border-line bg-card p-5 shadow-[0_8px_18px_rgba(11,61,46,0.06)]">
      {title ? (
        <div className="mb-4 flex items-center justify-between gap-3">
          <h2 className="text-lg font-semibold">{title}</h2>
          {action}
        </div>
      ) : null}
      {children}
    </section>
  );
}

export function Notice({ children }: { children: ReactNode }) {
  return (
    <p className="rounded-xl border border-line bg-gold-wash px-4 py-3 text-sm leading-6 text-deep">
      {children}
    </p>
  );
}
