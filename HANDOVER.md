# NEXORA TECH development start: handover report

Date: 7 November 2026. This file is a report for the Founder & CEO and is not part of the repository content.

## 1. Honest status

- **Nothing has been compiled, run or tested.** This environment has no Flutter or Dart SDK and no network access. All code was written by hand and checked only for bracket balance and import paths.
- **Nothing has been committed to GitHub.** The assistant has no write access. The folder `nexora-tech-app` is a ready-to-copy project for the repository root.
- Package versions were chosen from memory and are resolved by `flutter pub get`. Expect to fix some compile or analyzer messages on the first build.

## 2. Repository inspection

https://github.com/ahmadcrt/-nexora-tech on 7 November 2026: public, branch `main`, one commit, `README.md` only (one line of description). No code, workflows, issues or releases. No existing content is replaced except the README, which keeps its original line and adds sections (review before committing).

## 3. What was built

| Area | Delivered |
|---|---|
| Project | `pubspec.yaml`, lint rules, `.gitignore` (blocks env files and keys), web shell (`index.html`, manifest, icons) |
| Architecture | Feature-first, layered: `core/` and `features/website`, `features/enquiry` (domain, data, application, presentation). Riverpod for state, go_router with path URLs |
| Brand | Colour tokens (approved palette only), Inter font bundled, type scale and breakpoints from NT-DOC-08. Logo shown from exported files of the approved logo system; nothing redrawn |
| Website | Home, Services, About, Contact, Privacy and Terms placeholders, Not found. Responsive at compact, medium and expanded widths, with a menu drawer on smaller screens |
| Components | Logo, buttons, header, footer, drawer, section, content container, responsive grid, notice, service card, values section, call to action, page header |
| Supabase | Optional initialisation from `--dart-define`, enquiry repository behind an interface, Supabase and "unavailable" implementations, draft migration for `profiles` and `enquiries` with Row Level Security |
| Enquiry form | Validation per NT-DOC-04, consent, preselected service from links, no double submit, failure keeps typed text |
| Quality | Unit and widget tests for validators, the draft mapping, the controller and a home page smoke test; GitHub Actions CI (format, analyse, test, web build) |

## 4. First steps on your machine

1. Copy the folder contents into a clone of the repository (keep the existing `.git`).
2. `flutter pub get`, then `dart format .`, then `flutter analyze` and `flutter test`; fix what they report.
3. `flutter run -d chrome`.
4. Create a branch, commit, and open a pull request so CI runs.

## 5. Decisions and findings that need you

| No. | Item | Why it matters |
|---|---|---|
| 1 | **Market and model changed.** You now state the initial market is Nigeria and Africa, and the model is remote-first. The approved documents say "Nigeria-first with international ambitions" (D-002) and do not mention remote-first. The website text now says "remote-first" and "Nigeria and across Africa" | Record as new decisions via a change request and update NT-DOC-01 to 12 and the register |
| 2 | **Development start.** You have started development, which supersedes D-012 (no coding until the documents are approved). The 15-document package is still marked Reviewed, not Approved | Confirm whether the package is approved, or approved with changes |
| 3 | **Website copy is draft.** Service names and the eight values are approved. The one-line service descriptions, "Our values" and "Have a project in mind?" wording are my drafts | Approve or replace the wording (TBD-017) |
| 4 | **Digital Solutions** has no defined scope | TBD-011 |
| 5 | **Privacy notice and terms** are placeholders, not written. The consent sentence on the form is draft wording | Needs qualified legal review before enquiries open (TBD-009) |
| 6 | **Enquiries are switched off** until you create a Supabase project and choose region and plan | TBD-007 |
| 7 | **Spam protection.** The planned hidden "honeypot" field is not included because it protects nothing here: the form is drawn on a canvas and bots can call the Supabase API directly. Real protection needs rate limiting in front of the database (an Edge Function or similar) | New recommendation; decide before launch (TBD-025) |
| 8 | **Search visibility.** Flutter Web pages expose little text to search engines. Meta tags in `index.html` are shared by all pages. Tab titles are set per page | Decide the approach (TBD-012) |
| 9 | **Hosting and URLs.** Path URLs need the host to rewrite unknown paths to the app. GitHub Pages does not do this by default | TBD-007 |
| 10 | **Silver tint.** `#F1F3F5` (Silver at 25% on White) is used for light backgrounds. It is derived, not a new colour | Confirm, or tell me to remove it |
| 11 | **Error colours.** No approved error or success colour exists, so errors use Graphite with an icon and text | TBD-026 |
| 12 | **Contact details** are not shown anywhere, because none are approved | TBD-019 |
| 13 | **Repository name** starts with a hyphen and the repository has no licence | TBD-001, TBD-027 |
| 14 | **Database draft.** The SQL has never been run. The audit log table is not included yet | Test locally before use |
| 15 | **Logo.** Shown from PNG exports of the approved SVGs, because the SVG text relies on fonts that Flutter's SVG support may not render faithfully | Convert the SVG text to outlines later for a vector version |

## 6. Not done yet

Administrator sign-in and enquiry review console, notifications, content management, analytics, deployment pipeline and hosting, audit log, privacy and terms text, real testing in browsers, accessibility audit with a screen reader, and performance measurement.
