import { describe, expect, it } from "vitest";
import { computeInvoice, lineAmount } from "./invoice";

describe("lineAmount", () => {
  it("additionne main-d'œuvre et pièces", () => {
    expect(lineAmount({ hours: 2, hourlyRate: 50, partsCost: 30 })).toBe(130);
  });
});

describe("computeInvoice", () => {
  it("renvoie une facture vide sans intervention", () => {
    expect(computeInvoice([]).total).toBe(0);
  });

  it("ajoute les frais de déplacement sous le seuil", () => {
    const invoice = computeInvoice([{ hours: 1, hourlyRate: 60, partsCost: 0 }]);
    expect(invoice.travelFee).toBe(35);
    expect(invoice.total).toBe(114);
  });

  it("offre le déplacement au-delà du seuil", () => {
    const invoice = computeInvoice([{ hours: 10, hourlyRate: 60, partsCost: 0 }]);
    expect(invoice.travelFee).toBe(0);
  });
});
