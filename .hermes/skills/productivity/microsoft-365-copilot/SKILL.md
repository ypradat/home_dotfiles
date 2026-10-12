---
name: microsoft-365-copilot
description: "Use when a Microsoft 365 Copilot feature is gated."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Microsoft365, Copilot, Outlook, Teams, Licensing, AdminPolicy, macOS]
    related_skills: [blocked-page-recovery, grounded-citations]
---

# Microsoft 365 Copilot — why a feature is missing, gated, or different per user

## When to Use

Use for: "I have the Copilot icon but chat won't open", "my colleague can do X and I
can't", "does feature X exist on platform Y", "is this my license or IT?" — any question
about availability of a Microsoft 365 / Copilot capability in a client app (Outlook,
Teams, Word, Excel, PowerPoint, OneNote) on desktop, web or mobile.

## Mental model: four independent gates — never collapse them

Most wasted time in this class of problem comes from treating "Copilot doesn't work" as
one condition. It is four, and they fail independently:

1. **License tier.** *Copilot Chat* ("Basic") is included with an eligible Microsoft 365
   base subscription — no add-on needed. *Copilot* ("Premium", the M365 Copilot add-on)
   gates the deep in-app skills (summarize/draft/coach/prioritize/agents). A user can
   legitimately have one and not the other; the client shows the detected label in the
   app's Settings > Copilot section.
2. **Surface / entry point.** The same product name maps to *different UI surfaces per
   client and per platform*. The decisive example: in Outlook for Mac the toolbar
   Copilot button opens the **Copilot Command Center** — a consolidated, eligibility-
   adaptive menu (Summarize, draft/Reply, Prioritize, Schedule, Settings) — while
   **Copilot Chat** is a separate item in the **left navigation rail**. A user clicking
   the toolbar button and reporting "chat doesn't open" is not reporting a fault.
   Establish which control was clicked before diagnosing anything else.
3. **Tenant / admin controls.** Pinning and policy settings are group-scopable, so two
   colleagues on the same tenant legitimately differ. See the admin checklist below.
4. **Client build and staged rollout.** Web ships first, Windows next, Mac lags; Mac in-app
   features have regressed and returned between builds. "It worked last month" is a real
   signal, not user error.

**Invariant that shortcuts most of the work:** if the feature works in the web client
(OWA / Office on the web) for the same account, tenant configuration and licensing are
proven correct. The fault is then gate 2, 3 or 4 — never a license problem. Say so
explicitly and stop re-litigating the license.

## Procedure

1. **Get the exact surface and platform from the user** before researching: which control
   they click, which app, which platform, and the *full menu items* they see. The menu
   wording is a fingerprint — it identifies the surface. Match it against Microsoft's
   release notes and support pages (`references/feature-availability-evidence.md`).
2. **Read the client's real state from the machine** instead of asking: version/build, UI
   flavour (new vs legacy), account type, and whether the client is successfully talking
   to the service. Recipes and paths: `references/outlook-for-mac-client-inspection.md`.
   A 200 from the client's own Copilot service calls (preferences, capabilities) proves
   entitlement plumbing works and re-frames the problem as presentation/enablement.
3. **Rank the candidate causes, then hand over an ordered checklist.** Typical order:
   correct entry point (rail vs toolbar) → user-level toggle in app Settings > Copilot →
   client build parity with the colleague → entitlement token refresh (sign out/in) →
   admin pinning/policy → staged rollout as the residual explanation.
4. **Give the admin message with exact setting names and paths**, not paraphrases — IT
   acts on strings it can search for. Canonical set: *Pin Microsoft Copilot Chat*
   (M365 admin center > Copilot > Settings); *Allow the use of additional optional
   connected experiences in Office*; per-group Microsoft 365 Cloud Policy equivalents;
   and the fact that the Copilot UI hides when disabled in the admin portal. Details in
   `references/feature-availability-evidence.md`.
5. **Offer the interim path**: web client, the standalone Copilot app, or the in-app
   chat pane where it exists (it can float over the Outlook window on Mac/iPad).

## Pitfalls

- **Do not propose reinstall, profile reset, or cache clearing for a missing in-app chat
  surface.** In the documented Mac cases these change nothing; they cost the user an hour
  and destroy the diagnostic state you just read. The supported answer is "use the web
  client until the rollout reaches your client".
- **Do not treat "my colleague has it" as evidence of a broken account.** Rollout is
  per-user/per-ring and pinning can be group-scoped; same tenant ≠ same experience.
- **Do not report a roadmap item's status from a stale mirror without checking for a
  later transition** — roadmap statuses are edited in place, so an aggregator's change log
  is more trustworthy than any single snapshot. Prefer status + date of last transition.
- **Naming churn is a trap:** Microsoft 365 Copilot → Microsoft Copilot, Microsoft 365
  Copilot Chat → Microsoft Copilot Chat, primary URL now `copilot.cloud.microsoft`. Search
  old *and* new names, or you will conclude a feature doesn't exist.
- **Log payloads from Microsoft clients are PII-masked** (`"pii:<hex>"` keys). Read HTTP
  status and booleans only; take field names from documentation or the app's own
  preferences plist. Do not burn cycles trying to decode the mask.

## Deliverable shape for this user

- Lead with **what they are actually seeing, identified by name** (e.g. "that menu is the
  Command Center, not chat") — it resolves the confusion in the first sentence.
- Then ranked causes **with the evidence that supports each**, then an ordered, numbered
  checklist with exact UI paths, then the exact strings to send IT.
- Include a small table of **locally verified facts** (version/build, client flavour,
  account, service-call results) so the user can rule out licensing at a glance.
- Separate clearly: *verified on your machine* vs *you must check this* vs *IT must check
  this*. Preserve uncertainty; give one recommendation with trade-offs rather than a flat
  list of possibilities.
- Cite the primary Microsoft sources (support pages, learn.microsoft.com, release notes,
  roadmap/message-center items) — this user checks provenance.

## References

- `references/outlook-for-mac-client-inspection.md` — read Outlook for Mac's version, UI
  flavour, account, Copilot routes and service-call logs from disk; macOS shell pitfalls.
- `references/feature-availability-evidence.md` — where to find authoritative answers on
  which platform/version has a feature, roadmap and message-center sources that fetch
  reliably, the admin control set, and the license-tier vocabulary.
