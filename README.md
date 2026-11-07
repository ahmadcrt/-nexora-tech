# -nexora-tech

```
Official development repository for NEXORA TECH.
```

**NEXORA TECH** — *Technology That Moves Business Forward.*
A remote-first technology company serving businesses in Nigeria and across Africa. Founder & CEO: AHMAD YUNUSA.

This repository holds the NEXORA TECH website and web platform, built with Flutter Web, Dart, Supabase and GitHub.

## Status

Early development (version 0.1.0). The public website pages are implemented. Online enquiries are wired to Supabase but stay switched off until a Supabase project is configured. Nothing here has been run or released yet.

## Requirements

- Flutter (stable channel) with web support enabled. Exact versions will be pinned (TBD-023).
- A modern browser (Chrome is used for development).

## Getting started

```bash
flutter pub get
dart format .
flutter test
flutter run -d chrome
```

Run `dart format .` once before the first commit so the CI formatting check passes.

### Optional: connect Supabase

Supabase is optional for local work. To enable enquiries, pass your project values at build or run time (never commit them):

```bash
flutter run -d chrome \
  --dart-define=SUPABASE_URL=<your project url> \
  --dart-define=SUPABASE_ANON_KEY=<your anon key>
```

Use only the public **anon** key. The service-role key must never be used in this application. Apply `supabase/migrations/` to a local Supabase instance and test it before using it anywhere else.

## Project structure

| Path | Purpose |
|---|---|
| `lib/core/` | Theme (approved brand tokens), routing, shared widgets, configuration |
| `lib/features/website/` | Public pages and website content |
| `lib/features/enquiry/` | Enquiry form: domain rules, data layer, state, UI |
| `assets/images/logo/` | Approved NEXORA TECH logo files (do not redraw or recolour) |
| `assets/fonts/` | Inter (SIL Open Font License) |
| `supabase/migrations/` | Database changes (draft, not yet run) |
| `test/` | Automated tests |
| `docs/` | Approved, non-confidential project documentation only |

Layers: presentation, state, domain, data. Only the data layer talks to Supabase.

## Brand

Palette (approved): Midnight Navy `#0B1220`, Electric Blue `#2563EB`, White `#FFFFFF`, Silver `#C7CED8`, Graphite `#202938`. The logo is used only from `assets/images/logo/`.

## Rules for this repository

- Public repository: commit only approved, non-confidential content.
- Never commit credentials, API keys, passwords, private configuration or confidential documents.
- Draft documents stay outside this repository.
