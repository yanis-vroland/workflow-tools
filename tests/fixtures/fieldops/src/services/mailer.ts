import { Intervention } from "../domain/types";

// Envoi du compte rendu d'intervention au client par le service d'e-mail transactionnel

export async function sendInterventionReport(intervention: Intervention): Promise<void> {
  await fetch(`${process.env.MAIL_API_URL}/messages`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${process.env.MAIL_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      from: process.env.MAIL_FROM,
      template: "intervention-report",
      data: { interventionId: intervention.id, report: intervention.report },
    }),
  });
  // TODO: journaliser les échecs d'envoi
}
