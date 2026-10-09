// Calcul de la facture d'un ordre de travail à partir de ses interventions

export interface InvoiceLine {
  hours: number;
  hourlyRate: number;
  partsCost: number;
}

export interface Invoice {
  subtotal: number;
  travelFee: number;
  discount: number;
  vat: number;
  total: number;
}

export const VAT_RATE = 0.2;
export const TRAVEL_FEE = 35;
export const FREE_TRAVEL_THRESHOLD = 500;
export const LOYALTY_DISCOUNT_RATE = 0.05;

function round2(value: number): number {
  return Math.round(value * 100) / 100;
}

export function lineAmount(line: InvoiceLine): number {
  if (line.hours < 0 || line.hourlyRate < 0 || line.partsCost < 0) {
    throw new Error("Montant négatif interdit");
  }
  return line.hours * line.hourlyRate + line.partsCost;
}

export function computeInvoice(lines: InvoiceLine[], options: { loyalCustomer?: boolean } = {}): Invoice {
  if (lines.length === 0) {
    return { subtotal: 0, travelFee: 0, discount: 0, vat: 0, total: 0 };
  }
  const subtotal = round2(lines.reduce((sum, line) => sum + lineAmount(line), 0));

  // Déplacement offert au-delà du seuil
  const travelFee = subtotal >= FREE_TRAVEL_THRESHOLD ? 0 : TRAVEL_FEE;

  let discount = 0;
  if (options.loyalCustomer) {
    discount = round2(subtotal * LOYALTY_DISCOUNT_RATE);
  }

  const taxable = subtotal + travelFee - discount;
  const vat = round2(taxable * VAT_RATE);
  // TODO: gérer le taux de TVA réduit pour les travaux de rénovation (ticket T07)
  return { subtotal, travelFee, discount, vat, total: round2(taxable + vat) };
}
