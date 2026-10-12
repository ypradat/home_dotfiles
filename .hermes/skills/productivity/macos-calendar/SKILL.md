---
name: macos-calendar
description: "Use when editing macOS Calendar events."
version: 1.0.0
author: Nous Research
license: MIT
platforms: [macos]
metadata:
  hermes:
    tags: [Calendar, macOS, EventKit, AppleScript, Reminders, Exchange, iCloud]
    related_skills: [apple-reminders, google-workspace]
---

# macOS Calendar

## When to Use

Use when the user asks to add, change, move or delete an event on the Mac's Calendar app (including its alerts), or to list what is coming up. For Apple Reminders use `apple-reminders`; for a hosted Google Calendar account use `google-workspace`.

## Access paths

Editing the local macOS Calendar app (Calendar.app), which syncs iCloud, Exchange and subscribed calendars. Two access paths:

| Need | Path |
|---|---|
| Read events, create/simple-edit/delete | AppleScript via `osascript` (automation permission only) |
| Multiple alerts per event, know the account/source, server-aware writes | EventKit via the bundled Swift tool |

## Bundled tool

```bash
SD=~/.hermes/skills/productivity/macos-calendar/scripts
swiftc -O -framework EventKit "$SD/calendar_tool.swift" -o /tmp/calendar_tool
/tmp/calendar_tool calendars
/tmp/calendar_tool list --from 2026-10-12 --days 7
/tmp/calendar_tool create --calendar Personnel --source iCloud --title "Be home by 16:45" \
  --start "2026-10-14 16:45" --end "2026-10-14 17:45" --alarms "-120,-45" --notes "..."
/tmp/calendar_tool delete --title "Be home by 16:45" --start "2026-10-14 16:45" --source iCloud
```

`--alarms` values are minutes relative to the start (negative = before). Times are machine-local.

## Rules

1. **Disambiguate duplicate calendar names by source.** Names repeat across accounts (the same Mac here has "Personnel", "Travail" and "Calendrier" on BOTH Exchange and iCloud). Run `calendar_tool calendars` and pass `--source`. AppleScript's `every calendar whose name is X` silently returns the first match, which is often the wrong account.
2. **Never run EventKit code with plain `swift file.swift`** — the JIT fails with `Symbols not found: _OBJC_CLASS_$_EKEventStore`. Compile with `swiftc -O -framework EventKit`.
3. **EventKit needs fullAccess.** `writeOnly` (rawValue 4) cannot find or read events, so it is useless for edits; only `fullAccess` (rawValue 3) allows fetch + multi-alarm writes. Call `store.requestFullAccessToEvents` and wait on a semaphore (~120 s) because a macOS dialog must be approved by the user first. Check with `EKEventStore.authorizationStatus(for: .event).rawValue`.
4. **Exchange-backed events hold exactly ONE reminder.** Additional alarms are accepted by the API and silently dropped by the store. Always read the event back and count alarms; if the user wants two alerts, put the event on an iCloud (CalDAV) calendar, which persists multiple `EKAlarm`s.
5. **AppleScript caps alarms too**: one `display alarm` per event (adding a second replaces the first), and `sound alarm` creation returns success but never persists. Use EventKit for anything beyond one alert.
6. **Build AppleScript dates numerically** (`set d to current date`, then set `year`/`month`/`day`/`hours`/`minutes`/`seconds`), never by parsing a string — string parsing is locale-dependent. `default calendar` and `properties of calendar` also fail to compile/run in Calendar's dictionary; read `defaults read com.apple.iCal` instead.
7. **Verify after every write**: re-fetch and print title, start, end and alarms. A successful `save`/`make new event` is not proof the store kept what was sent.
8. **Screen-based identification is blocked on this machine.** `screencapture` without Screen Recording permission returns wallpaper-only images; `osascript` UI scripting needs Accessibility (not granted); `sdef /System/Applications/Calendar.app` returns nothing. Get account identity from EventKit `calendar.source.title` / `sourceType`, not from the screen.
9. **Confirm with the user before creating or deleting events** (what, when, which calendar), then report exactly what was written.
10. **Write AppleScript to a `.scpt` file and run `osascript file.scpt`** instead of a heredoc; the terminal guard rejects heredocs containing `&`.

## Account identification fallbacks

- `defaults read com.apple.iCal` → `defaultCalendarName`, `defaultCalendarID` (Exchange/Graph IDs begin `AQMkAD...`), `defaultCalendarStoreUID`.
- `~/Library/Preferences/MobileMeAccounts.plist` → Apple ID / iCloud account and enabled `com.apple.Dataclass.Calendars`.
- TCC-blocked, do not attempt: `~/Library/Calendars`, `~/Library/Group Containers/group.com.apple.calendar`, `~/Library/Accounts/Accounts4.sqlite`.

## AppleScript read fallback (no EventKit needed)

```applescript
set out to ""
tell application "Calendar"
  repeat with c in calendars
    if writable of c then
      set evs to (every event of c whose start date is greater than or equal to (current date))
      if (count of evs) > 0 then
        set out to out & "== " & (name of c) & " (" & (count of evs) & ")" & linefeed
        repeat with e in evs
          set out to out & "  " & (start date of e as string) & " | " & (summary of e) & linefeed
        end repeat
      end if
    end if
  end repeat
end tell
return out
```
