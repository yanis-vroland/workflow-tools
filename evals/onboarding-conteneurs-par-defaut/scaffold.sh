#!/usr/bin/env bash
# Petit projet JavaScript fictif, hors git (spec 003, CA7, repli) : installation
# par conteneurs (docker-compose.yml, qui donne ses commandes en commentaire) et
# installation native possible (package.json, .nvmrc), mais un README qui ne
# décrit aucune des deux voies. La voie principale doit être celle par
# conteneurs, la voie native tient en une ligne qui cite package.json.
set -euo pipefail

mkdir -p src test

cat >README.md <<'MD'
# FieldOps Notifications

Service d'envoi des notifications aux techniciens FieldOps.
MD

cat >docker-compose.yml <<'YAML'
# Construire l'image : docker compose build
# Démarrer le service : docker compose up
# Lancer les tests : docker compose run --rm notifications npm test
services:
  notifications:
    build: .
    ports:
      - "4000:4000"
YAML

cat >Dockerfile <<'DOCKER'
FROM node:20-alpine
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
CMD ["npm", "start"]
DOCKER

printf '20\n' >.nvmrc

cat >package.json <<'JSON'
{
  "name": "fieldops-notifications",
  "version": "0.2.0",
  "private": true,
  "scripts": {
    "start": "node src/index.js",
    "test": "node --test test/"
  }
}
JSON

cat >package-lock.json <<'JSON'
{
  "name": "fieldops-notifications",
  "version": "0.2.0",
  "lockfileVersion": 3,
  "requires": true,
  "packages": {
    "": {
      "name": "fieldops-notifications",
      "version": "0.2.0"
    }
  }
}
JSON

cat >src/notification.js <<'JS'
/** Message adressé à un technicien : canal (sms ou push) et texte à envoyer. */
function createNotification(technicianId, channel, text) {
  return { technicianId, channel, text, createdAt: new Date().toISOString() };
}

module.exports = { createNotification };
JS

cat >src/index.js <<'JS'
const http = require("node:http");
const { createNotification } = require("./notification");

const server = http.createServer((req, res) => {
  const notification = createNotification(1, "push", "Nouvelle intervention");
  res.setHeader("Content-Type", "application/json");
  res.end(JSON.stringify(notification));
});

server.listen(4000);
JS

cat >test/notification.test.js <<'JS'
const test = require("node:test");
const assert = require("node:assert");
const { createNotification } = require("../src/notification");

test("une notification garde son canal", () => {
  assert.strictEqual(createNotification(1, "sms", "x").channel, "sms");
});
JS
