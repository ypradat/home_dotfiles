# Evidence sources for M365 / Copilot feature availability

Use these to answer "does platform X have feature Y, since when, behind which gate" with
something citable instead of inference.

## Release notes (which build changed what, per platform)

- **Office for Mac release notes** — `learn.microsoft.com/en-us/officeupdates/release-notes-office-for-mac`.
  Authoritative for Mac-specific surfaces and behaviour. Structure: `## <Month DD, YYYY>`
  then `### <App>` then bullets. Parse by tracking *both* headings and attributing each
  bullet to the current pair; a bullet grabbed without its date/app context is useless.
  Grep the whole page for the feature keyword and print `[date][app] bullet`. This is
  where you find entries like the consolidated Copilot entry point, left-rail
  customisation, and chat served from the left navigation rail.
- **Microsoft 365 Copilot release notes** — `learn.microsoft.com/en-us/microsoft-365/copilot/release-notes`
  (and `…/release-notes-archive`). Each item carries a platform tag list such as
  `[Android, Windows, iOS, Mac, Web]` — that tag is the fastest way to confirm a feature is
  claimed for the user's platform.

## Roadmap and message-center status

The public roadmap API (`microsoft.com/releasecommunications/api/v2/m365?responseFormat=csv…`)
returns a rich CSV but **403s on scripted fetches**; don't conclude data is unavailable.
Working equivalents:

| Source | What it gives |
|---|---|
| `microsoft.github.io/Analytics-Hub/community/roadmap-digest/` | Status *transitions* with dates — catches "In development" → "Launched" |
| `365fanatic.com/roadmap-detailed/`, `launchswitch.github.io/m365-roadmap/` | Current status, added/modified dates, platform tags |
| `app.cloudscout.one/evergreen-item/MC<number>/`, `mc.merill.net/message/MC<number>` | Message-center items with full change history and **per-platform rollout phases** (e.g. "Outlook for Mac: rollout starts <when> and completes in the weeks following") |
| `windowsforum.com` news write-ups | Secondary, but states status + claimed dates plainly |

Prefer the transition log over a single snapshot: roadmap statuses are edited in place, so
an old mirror can show "In development" long after the item shipped.

## Admin-side controls (give IT the exact strings)

- **Pin Microsoft Copilot Chat** — M365 admin center > Copilot > Settings. Default is
  *Pin*. With *Do not pin*, Copilot Chat is not available by default in Teams and Outlook,
  **but users can still add it themselves from the app store / navigation customisation**
  — this distinction determines whether the fix is user-side or admin-side. Changes can
  take up to ~48 h to apply.
- **Per-group pinning** — Microsoft 365 Cloud Policy (config.office.com → Microsoft 365
  Cloud Policy), policy *Pin Microsoft Copilot Chat*, scope targeted. This is the usual
  reason two users on one tenant differ.
- **Allow the use of additional optional connected experiences in Office** — when
  Disabled, it restricts Copilot and Copilot Chat across Microsoft 365.
- **Admin-portal disablement** — the Copilot UI in Outlook is hidden when disabled in the
  M365 admin portal; a group-scoped policy can therefore hide it on one device/user only.
- Reference write-ups: `learn.microsoft.com/en-us/copilot/manage` (eligibility list,
  pinning behaviour, web-search policy) and
  `learn.microsoft.com/en-us/microsoft-365/copilot/microsoft-copilot-requirements`
  (requirements-at-a-glance table).

## License vocabulary — use the labels the client shows

- **Copilot Chat (Basic)** — included at no extra cost with an eligible Microsoft 365 base
  subscription for Entra work/school accounts; no add-on required.
- **Copilot (Premium)** — the Microsoft 365 Copilot add-on; gates deep in-app skills,
  advanced reasoning, agent priority access.
- Support pages: *How Copilot Chat works with and without a Microsoft 365 Copilot license*,
  *Check your Copilot license*, *Chat with Copilot in Outlook* (this last one states where
  the chat surface lives per platform: "Copilot Chat is available when you select the
  Copilot icon from the navigation header"), *Frequently asked questions about Copilot in
  Outlook* (enumerates the skills and the minimum-version requirement: latest Outlook for
  Mac only, legacy unsupported).

## Community threads: read the resolution, not the question

Techcommunity/Microsoft Q&A threads are the best source for *symptom-class* answers on Mac
(same licence works in OWA but not in the desktop client; chat appears and disappears
between builds). Two habits:

- Extract the page, split the markdown on `componentScriptGroups|__NEXT_DATA__`, and reach
  threaded replies via `…/discussions/<slug>/<id>/replies/<replyId>` URLs.
- Weight the accepted/forum-expert answer over the original question, and prefer a reply
  that states a mechanism (rollout rings, build-specific regression) over reassurance.
