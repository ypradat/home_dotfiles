// calendar_tool.swift — EventKit CLI for the macOS Calendar app.
// Build:  swiftc -O -framework EventKit calendar_tool.swift -o calendar_tool
// Usage:
//   ./calendar_tool list   [--from YYYY-MM-DD] [--days N] [--source iCloud|Exchange|any]
//   ./calendar_tool create --calendar NAME [--source iCloud|Exchange|any] --title T
//                          --start "YYYY-MM-DD HH:MM" --end "YYYY-MM-DD HH:MM"
//                          [--alarms "-120,-45"] [--notes TEXT] [--location TEXT]
//   ./calendar_tool delete --title T --start "YYYY-MM-DD HH:MM" [--source ...]
//   ./calendar_tool calendars
// Notes: times are local to the machine. Multiple alarms only persist on iCloud
// (CalDAV) calendars; Exchange-backed events keep a single reminder.

import EventKit
import Foundation

let args = Array(CommandLine.arguments.dropFirst())
guard let cmd = args.first else { print("usage: calendar_tool <list|create|delete|calendars> [options]"); exit(64) }

func opt(_ names: String...) -> String? {
    for n in names {
        if let i = args.firstIndex(of: n), i + 1 < args.count { return args[i + 1] }
    }
    return nil
}

let tz = TimeZone.current
let df = DateFormatter()
df.dateFormat = "yyyy-MM-dd HH:mm"
df.timeZone = tz
let dayF = DateFormatter()
dayF.dateFormat = "EEE dd MMM yyyy HH:mm"
dayF.timeZone = tz

let store = EKEventStore()
let status = EKEventStore.authorizationStatus(for: .event)
guard status.rawValue == 3 else {   // 3 == fullAccess
    print("ERROR: full Calendar access not granted (status \(status.rawValue)). Call requestFullAccessToEvents first.")
    exit(1)
}

let sources = store.calendars(for: .event)

func matchCalendars(title: String, sourceWant: String) -> [EKCalendar] {
    sources.filter { c in
        c.title == title && c.allowsContentModifications &&
        (sourceWant == "any" || c.source.title.lowercased().contains(sourceWant.lowercased()))
    }
}

if cmd == "calendars" {
    for c in sources {
        print("\(c.title) | source=\(c.source.title) | type=\(c.source.sourceType.rawValue) | modifiable=\(c.allowsContentModifications)")
    }
    exit(0)
}

if cmd == "list" {
    let from = df.date(from: (opt("--from") ?? dayF.string(from: Date()).prefix(10) + " 00:00"))
        ?? Date()
    let days = Int(opt("--days") ?? "7") ?? 7
    let sourceWant = opt("--source") ?? "any"
    let pred = store.predicateForEvents(withStart: from, end: from.addingTimeInterval(Double(days) * 86400), calendars: nil)
    for e in store.events(matching: pred).sorted(by: { $0.startDate < $1.startDate }) {
        if sourceWant != "any" && !e.calendar.source.title.lowercased().contains(sourceWant.lowercased()) { continue }
        let alarms = (e.alarms ?? []).map { Int($0.relativeOffset / 60) }
        print("[\(dayF.string(from: e.startDate)) - \(dayF.string(from: e.endDate))] \(e.title ?? "?") | \(e.calendar.title) (\(e.calendar.source.title)) | alarms(min)=\(alarms)")
    }
    exit(0)
}

if cmd == "create" {
    guard let calTitle = opt("--calendar"), let title = opt("--title"),
          let startS = opt("--start"), let endS = opt("--end"),
          let startD = df.date(from: startS), let endD = df.date(from: endS) else {
        print("ERROR: --calendar --title --start --end are required"); exit(64)
    }
    let sourceWant = opt("--source") ?? "any"
    let targets = matchCalendars(title: calTitle, sourceWant: sourceWant)
    if targets.count != 1 {
        print("ERROR: \(targets.count) calendars match '\(calTitle)' (source=\(sourceWant)); disambiguate with --source. Candidates:")
        for c in targets { print("  \(c.title) | \(c.source.title)") }
        exit(65)
    }
    let ev = EKEvent(eventStore: store)
    ev.calendar = targets[0]
    ev.title = title
    ev.startDate = startD
    ev.endDate = endD
    if let n = opt("--notes") { ev.notes = n }
    if let l = opt("--location") { ev.location = l }
    if let a = opt("--alarms") {
        ev.alarms = a.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            .map { EKAlarm(relativeOffset: TimeInterval($0 * 60)) }
    }
    do { try store.save(ev, span: .thisEvent, commit: true) }
    catch { print("ERROR saving: \(error.localizedDescription)"); exit(2) }

    let wanted = ev.alarms?.count ?? 0
    var persisted = -1
    for _ in 1...6 {
        if let fresh = store.event(withIdentifier: ev.eventIdentifier!) { persisted = fresh.alarms?.count ?? 0 }
        if persisted == wanted { break }
        Thread.sleep(forTimeInterval: 1.0)
    }
    print("CREATED id=\(ev.eventIdentifier!) calendar=\(targets[0].title) (\(targets[0].source.title))")
    print("  \(dayF.string(from: ev.startDate)) -> \(dayF.string(from: ev.endDate)) | alarms persisted=\(persisted)")
    if persisted != wanted {
        print("  WARN: requested \(wanted) alarm(s), store kept \(persisted) — Exchange keeps only one reminder")
    }
    exit(0)
}

if cmd == "delete" {
    guard let title = opt("--title"), let startS = opt("--start"), let startD = df.date(from: startS) else {
        print("ERROR: --title --start required"); exit(64)
    }
    let sourceWant = opt("--source") ?? "any"
    let pred = store.predicateForEvents(withStart: startD.addingTimeInterval(-3600), end: startD.addingTimeInterval(3600), calendars: nil)
    var hits = 0
    for e in store.events(matching: pred) {
        guard (e.title ?? "").contains(title) else { continue }
        if sourceWant != "any" && !e.calendar.source.title.lowercased().contains(sourceWant.lowercased()) { continue }
        do { try store.remove(e, span: .thisEvent, commit: true); hits += 1
             print("DELETED '\(e.title!)' from \(e.calendar.title) (\(e.calendar.source.title))") }
        catch { print("ERROR deleting: \(error.localizedDescription)") }
    }
    print("deleted \(hits) event(s)")
    exit(hits > 0 ? 0 : 66)
}

print("unknown command: \(cmd)")
exit(64)
