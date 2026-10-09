// Création d'un acompte auprès du service de paiement

export async function createDeposit(workOrderId: number, amount: number): Promise<string> {
  const response = await fetch(`${process.env.PAYMENT_API_URL}/deposits`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${process.env.PAYMENT_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ reference: `WO-${workOrderId}`, amount, currency: "EUR" }),
  });
  const body = (await response.json()) as { checkoutUrl: string };
  return body.checkoutUrl;
}
