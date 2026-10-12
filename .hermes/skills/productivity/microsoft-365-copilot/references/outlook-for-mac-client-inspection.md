# Inspecting an Outlook for Mac install from the shell

Read-only introspection of the user's own client. Never dump message bodies, addresses
beyond the account under discussion, or anything token-like; report only what the
diagnosis needs.

## Version and UI flavour

```bash
/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" \
  "/Applications/Microsoft Outlook.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" \
  "/Applications/Microsoft Outlook.app/Contents/Info.plist"
```

The `CFBundleVersion` of an Office app ends in a build stamp `YYMMDD…` — that is the
**build date**, so you can tell how current the client is without asking. Compare it with
the colleague's build when "works for them, not for me" is the symptom; also check the
update channel (Microsoft AutoUpdate) if one of them is on Beta/Insider.

## Profile root and which client it belongs to

```
~/Library/Group Containers/UBF8T346G9.Office/Outlook/Outlook 15 Profiles/Main Identity/
```

The *path* does **not** distinguish the clients — legacy and current Outlook for Mac both
use `Outlook 15 Profiles/Main Identity`. Distinguish by contents:

| Marker | Client |
|---|---|
| `HxStore.hxd`, `hxcore.hfl`, `Osa/`, `Omc/`, `rss/`, `ActionsBackup/` | **New Outlook for Mac** (the web-based "Hx" engine — the Copilot-capable one) |
| `Data/` with database / `Message Sources` layout and no `Hx*` files | Legacy Outlook for Mac — Copilot in Outlook is not supported there |

Account folders are named `<alias>_ActiveSyncExchange_HxS` (plus `omc@omc.outlook_Omc_Direct`,
an internal migration artifact — ignore it). Presence of `Hx*` files shows which client ran
most recently; check mtimes before concluding, since stale legacy profiles survive an
upgrade and the profile path alone will mislead you.

## Copilot evidence in the client's own service logs

```
…/Main Identity/Osa/OutlookServiceApiLogs_<timestamp>_<id>/   per-session captures
…/Main Identity/Osa/OsaPinnedLogs/<Command>_<accountId>/      pinned request/response pairs
```

File names encode the command:
`osa{<ts>}_<seq>_<acct>_sync.<Command>.<pid>.{req|res}.xmlgz`. Decompress and read:

```bash
gunzip -c "<file>.res.xmlgz" | head -c 4000
```

The envelope gives `ReceiveTime`, `LogTime`, `HttpStatusCode`, `NetworkProtocol` and a
`<Content>` JSON body. Copilot commands worth grepping for:

- `GetCopilotUserPreferences`, `SyncCopilotUserSettings` — client↔Copilot service settings
- `SyncMChatCapabilities` — whether in-app M365 chat is offered to this account
- `GetCopilotPrompt` — prompt-program experience

A **200** on these means the client authenticated and the tenant served Copilot capability
data — licensing/tenant plumbing is fine and the issue is surface presentation or
enablement. That one observation reframes the whole diagnosis; collect it before
speculating about licenses.

The newest `OutlookServiceApiLogs_*` directory may contain no Copilot-named entries (steady
state is mostly presence/mail sync); the pinned-log directories are the reliable place for
Copilot commands regardless of session timing.

**The `<Content>` JSON is PII-masked**: every key and string value is replaced by
`"pii:<hex>"`. You can read booleans, numbers and structure only. Take field *names* from
documentation or from `ProfilePreferences.plist` — never try to decode the mask.

## Which Copilot surfaces the client has registered

`…/Main Identity/ProfilePreferences.plist` is a **binary** plist (so `grep`/PlistBuddy
report "binary file matches" or nothing at all). Use:

```bash
plutil -p ProfilePreferences.plist | grep -i copilot
```

Its entries look like `https://outlook.office.com/opx/<user>/<route>` with a matching
`name`, e.g. `CopilotSettings`, `CopilotPrioritizeOptin`, `CopilotPrioritizeSettings`.
The registered set shows which Copilot surfaces this build exposes (settings + skills) —
useful corroboration, **not** proof about chat, which is delivered by the service
capability payload rather than a local route.

## macOS shell pitfalls that cost time here

- **Never recursively list or `find` inside `~/Library/Containers/com.microsoft.Outlook/Data`**
  — sandbox container traversal can hang the shell indefinitely and kill the whole call.
  Scope with `-maxdepth` and target the `Group Containers` profile instead, which is fast.
- `timeout` is not a stock macOS binary; use `gtimeout` (coreutils) or drop the guard
  rather than building a command around `timeout`.
- `PlistBuddy` and `grep` fail silently on binary plists and look like "no such setting".
  Convert with `plutil -p` first whenever a preference seems absent.
- Microsoft doc pages (`support.microsoft.com`, `techcommunity.microsoft.com`) return
  large JS blobs to `web_extract`. Split the markdown on
  `componentScriptGroups|__NEXT_DATA__` and keep the head for the real article text.
