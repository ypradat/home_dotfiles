# Autostart: Gateway Service & Desktop App

"Make Hermes start with my computer" means one of two INDEPENDENT things. Ask which (or set both) — do not assume, and do not look for one config key that covers both.

| Target | What it is | Autostart mechanism |
|---|---|---|
| **Gateway** (headless: messaging bots, cron, webhooks) | the `hermes gateway run` process | `hermes gateway install` — a real service the OS supervises |
| **Desktop app** (`/Applications/Hermes.app`, Electron GUI) | a GUI app; it launches its own `hermes serve` backend | a macOS **Login Item** — NOT a Hermes setting |

The gateway and the desktop backend are different processes. Installing one does not start the other.

## Gateway as a service

```bash
hermes gateway install          # user service: launchd agent (macOS), systemd user unit (Linux), Scheduled Task (Windows)
hermes gateway status           # verify: reports supervision, PID, and whether the plist/unit matches the install
hermes gateway stop | start | restart
hermes gateway uninstall        # remove the autostart
```

Flags: `--start-on-login` (default ON), `--start-now` / `--no-start-now`, `--force`, `--if-missing`, `--system` (Linux only). Per-profile: `hermes -p <profile> gateway install` → `ai.hermes.gateway-<profile>.plist`.

macOS artifact: `~/Library/LaunchAgents/ai.hermes.gateway.plist`, with `RunAtLoad` (starts at login) and `KeepAlive` (auto-restarts on crash). Logs: `~/.hermes/logs/gateway.log`, `~/.hermes/logs/gateway.error.log`.

### Pitfalls

- **Non-interactive install (no TTY) hangs on its prompts.** Pass the answers as flags AND accept hooks up front: `hermes gateway --accept-hooks install --start-on-login --start-now`. `--accept-hooks` is a `hermes gateway` subcommand flag, placed before `install`.
- **macOS launchd agents start at LOGIN, not boot.** There is no macOS equivalent of `--system`; a LaunchAgent is per-user and fires when you log in. Only Linux has a true boot-time system service (`sudo hermes gateway install --system`). To run with nobody logged in, the user must enable macOS auto-login — say so rather than implying a boot service exists.
- **The plist snapshots your PATH at install time.** After installing new tools (Node, ffmpeg, Homebrew, nvm), re-run `hermes gateway install` so the gateway can find them; the gateway detects the stale plist and reloads.
- **A gateway with no platforms still runs and idles.** It logs `No messaging platforms enabled. Gateway will continue running for cron job execution.` It is only useful if messaging platforms or cron/webhooks are configured — check `hermes gateway list`, `hermes cron list`, and whether `gateway.enable` is set before installing, and tell the user what it will (not) do.
- **It runs through `/usr/bin/osascript`** (macOS), so `ps` shows `osascript → ... → gateway run`. That is normal — it exists so the gateway passes macOS Local Network Privacy checks.

## Desktop app at login (macOS)

There is no `desktop.autostart` / config key for this — it is a macOS Login Item. Set it one of three ways:

- System Settings → General → Login Items & Extensions → “+” → `/Applications/Hermes.app`
- While running: right-click the Dock icon → Options → Open at Login
- Scripted:
  ```bash
  osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Hermes.app", hidden:false}'
  osascript -e 'tell application "System Events" to get the name of every login item'   # verify
  ```

The login item shows as `Hermes` in the list. Remove it the same way (System Settings, or `osascript ... to delete login item "Hermes"`).
