"use client";

import { useRouter } from "next/navigation";
import { FormEvent, useState } from "react";
import { reviewer } from "@/lib/data";

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");

  function submit(event: FormEvent) {
    event.preventDefault();
    if (email.trim().toLowerCase() !== reviewer.email || password !== reviewer.password) {
      setError("Use the demo reviewer account shown below. This is not a production login.");
      return;
    }
    window.localStorage.setItem("barakah.admin", "reviewer");
    router.replace("/");
  }

  return (
    <main className="grid min-h-screen place-items-center bg-deep px-4">
      <form onSubmit={submit} className="w-full max-w-md rounded-3xl bg-ivory p-8 text-ink">
        <p className="font-display text-4xl text-deep">BarakahShares</p>
        <p className="mt-1 text-gold">Halal Equity Crowd</p>
        <h1 className="mt-6 text-2xl font-semibold">Reviewer sign in</h1>
        <p className="mt-2 text-sm leading-6 text-muted">
          Approve campaigns, KYC decisions, and evidence. This console does not send Smile ID, Daraja, or chain transactions.
        </p>
        <label className="mt-6 block text-sm font-semibold" htmlFor="email">
          Email
        </label>
        <input
          id="email"
          className="mt-1 w-full rounded-xl border border-line bg-white px-3 py-3"
          value={email}
          onChange={(event) => setEmail(event.target.value)}
          autoComplete="username"
        />
        <label className="mt-4 block text-sm font-semibold" htmlFor="password">
          Password
        </label>
        <input
          id="password"
          type="password"
          className="mt-1 w-full rounded-xl border border-line bg-white px-3 py-3"
          value={password}
          onChange={(event) => setPassword(event.target.value)}
          autoComplete="current-password"
        />
        {error ? <p className="mt-3 text-sm text-danger">{error}</p> : null}
        <button className="mt-6 w-full rounded-xl bg-deep px-4 py-3 font-semibold text-white" type="submit">
          Sign in
        </button>
        <p className="mt-4 text-sm text-muted">
          Demo: {reviewer.email} / {reviewer.password}
        </p>
      </form>
    </main>
  );
}
