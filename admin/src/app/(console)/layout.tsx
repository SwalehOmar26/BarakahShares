import { ConsoleShell } from "@/components/shell";
import type { ReactNode } from "react";

export default function Layout({ children }: { children: ReactNode }) {
  return <ConsoleShell>{children}</ConsoleShell>;
}
