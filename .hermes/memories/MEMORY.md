Default profile: official Spotify plugin at ~/.hermes/plugins/spotify with Spotify PKCE authorization, independent of hosted connectors; `hermes spotify status` verifies it. "Yoann's MacBook Pro" is a working Spotify Connect target, and the plugin's seven tools cover listening history and playback.
§
Mac calendar access: the Hermes terminal helper has osascript automation + full EventKit calendar access. Two accounts sync calendars with colliding names — Exchange (Calendrier, Personnel, Vacances, Travail, Conférence, Anniversaires) and iCloud (Calendrier, Personnel, Travail, Maison) — so always pass the source. Exchange events keep only one reminder; iCloud events hold several. Use the macos-calendar skill's calendar_tool.swift.
§
Music: picks from their Spotify listening history — Bon Entendeur, Cannons, Zimmer90, Drove, Folamour, Kygo, French songwriting. Speaks English and French.
§
macOS TCC: this shell cannot read ~/Documents, ~/Desktop, or ~/Downloads ("Operation not permitted"); ~/Library, ~/Music, ~/Pictures, ~/Movies, ~/Nextcloud, ~/Tools are readable. Treat a blocked path as a permission boundary, not a missing file.
