# FieldOps Compagnon

Application Flutter des techniciens : planning du jour, détail d'une intervention,
photos et clôture, avec un cache local pour les zones sans réseau.

## Lancer l'application

La version de Flutter est fixée dans `.fvmrc` (outil fvm).

```bash
fvm flutter pub get
fvm flutter run --dart-define=API_URL=http://10.0.2.2:3000/api
```

## Tests

```bash
fvm flutter test
```
