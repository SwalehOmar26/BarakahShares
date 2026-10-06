"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useEffect, useState, type ReactNode } from "react";
import { reviewer } from "@/lib/data";
import { ReviewProvider } from "@/lib/store";

const links = [
  ["/", "Overview"],
  ["/businesses", "Businesses"],
  ["/kyc", "KYC"],
  ["/investments", "Investments"],
  ["/evidence", "Evidence"],
  ["/distributions", "Distributions"],
  ["/chain", "Chain"],
];

export function ConsoleShell({ children }: { children: ReactNode }) {
  const pathname = usePathname();
  const router = useRouter();
  const [ready, setReady] = useState(false);

  useEffect(() => {
    const allowed = window.localStorage.getItem("barakah.admin") === "reviewer";
    if (!allowed) {
      router.replace("/login");
      return;
    }
    const frame = requestAnimationFrame(() => setReady(true));
    return () => cancelAnimationFrame(frame);
  }, [router]);

  if (!ready) {
    return <main className="grid min-h-screen place-items-center text-muted">Opening the review console…</main>;
  }

  return (
    <ReviewProvider>
      <div className="min-h-screen md:grid md:grid-cols-[240px_1fr]">
        <aside className="flex flex-col bg-deep text-white md:min-h-screen">
          <div className="px-5 py-6">
            <p className="font-display text-2xl">BarakahShares</p>
            <p className="text-sm text-gold-soft">Review console</p>
          </div>
          <nav className="flex gap-2 overflow-x-auto px-3 pb-4 md:block md:space-y-1 md:px-3">
            {links.map(([href, label]) => {
              const active = href === "/" ? pathname === "/" : pathname.startsWith(href);
              return (
                <Link
                  key={href}
                  href={href}
                  className={`block rounded-xl px-3 py-2 text-sm font-semibold ${
                    active ? "bg-white/10 text-gold-soft" : "text-white/80 hover:bg-white/10"
                  }`}
                >
                  {label}
                </Link>
              );
            })}
          </nav>
          <div className="mt-auto px-5 py-6 text-sm">
            <p className="font-semibold">{reviewer.name}</p>
            <p className="text-white/70">{reviewer.role}</p>
            <button
              className="mt-4 text-gold-soft"
              onClick={() => {
                window.localStorage.removeItem("barakah.admin");
                router.replace("/login");
              }}
            >
              Sign out
            </button>
          </div>
        </aside>
        <div className="mx-auto w-full max-w-6xl px-4 py-6 md:px-8">{children}</div>
      </div>
    </ReviewProvider>
  );
}
