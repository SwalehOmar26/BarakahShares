export function kes(amount: number) {
  return `KES ${new Intl.NumberFormat("en-KE").format(amount)}`;
}

export function shortHash(value: string) {
  if (value.length <= 12) return value;
  return `${value.slice(0, 6)}…${value.slice(-4)}`;
}
