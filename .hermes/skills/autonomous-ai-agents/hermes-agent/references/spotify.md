# Spotify setup and playback

## Install and authorize

1. Consult the current official Spotify docs and search the plugin catalog for the official `spotify` plugin. Install with approval and verify catalog status. Keep installation and account authorization separate.
2. Run `hermes spotify status`. If login is needed, inspect `hermes spotify login --help`, then start `hermes spotify login` with `terminal(background=true, pty=true, notify=true)` so the interactive wizard remains available while the user completes browser steps.
3. Poll the process to identify its actual prompt. Without a configured client ID, the wizard requests creation of a user-owned Spotify developer app. Use Web API and the exact redirect URI printed by the wizard (documented default: `http://127.0.0.1:43827/spotify/callback`). A Client ID is public and can be submitted to the process; never request a client secret, password, token, or callback authorization code in chat.
4. Submit the Client ID using `process_manage(action='submit')`; let the user approve OAuth in their browser. Verify completion with `hermes spotify status` rather than treating a browser-open message as successful authorization.

## Execute even when tool discovery has not refreshed

1. Prefer the plugin's registered tools. If tool search returns no Spotify tools, inspect the installed plugin source before telling the user to restart or open a new chat: the installed implementation can provide an executable path now.
2. Discover the active Hermes home, source root, plugin directory, and working Python interpreter; do not copy machine-specific paths. Inspect `spotify_tools.py` for current handlers. A validated fallback is importing the package with its parent directory and Hermes source root on `sys.path`, then calling `_handle_spotify_playback` or `_handle_spotify_devices`. These are private APIs: re-check source before use.
3. Use the plugin client/handlers so OAuth refresh and error mapping remain intact; do not print or manually extract auth tokens.
4. Decode JSON results and output only needed fields. For listening history, reduce items to track name, artists, URI, context, and played time before printing; full Spotify objects otherwise swamp the context with image URLs and metadata.

Example pattern after discovering the paths:

```python
import importlib, json, sys
sys.path.insert(0, hermes_source_root)
sys.path.insert(0, plugin_parent)
m = importlib.import_module('spotify.spotify_tools')
history = json.loads(m._handle_spotify_playback(
    {'action': 'recently_played', 'limit': 30}))
print(json.dumps([
    {'name': x['track']['name'],
     'artists': [a['name'] for a in x['track']['artists']],
     'uri': x['track']['uri'], 'played_at': x['played_at']}
    for x in history.get('items', [])]))
```

## Choose and play

For this user's casual afternoon work, favor warm, mellow electronic pop and French grooves; for waking, favor gentle instrumentals at low volume. History preceding agent-selected playback included Cannons, Zimmer90, Drove, Folamour, Bon Entendeur, Klingande, and Kygo, alongside French songwriting. Treat these as starting candidates, refresh history when available, and let the current mood request override prior selections.

1. Read recent listening and choose a coherent sequence using retrieved track URIs. Distinguish a history-based selection from a discovery recommendation; never invent catalog identifiers. When inferring taste, discount tracks the agent itself just selected, because playback history includes those interventions and can create a circular recommendation loop. Treat children's songs or shared-account listening as ambiguous rather than evidence of the user's personal taste.
2. Match energy to the requested setting: use a gentler sequence for waking or background work rather than simply replaying the most recent dance tracks. Search and verify artist/title matches for discovery tracks before adding them. A suggestion request does not authorize changing playback; an explicit play request does.
3. Retain the proposed ordered track names and verified URIs in task context. When the user says to play the suggestions, execute that sequence, including any explicitly proposed discoveries; do not substitute a new mix or depend on the recent-history window still containing every track. Search missing identifiers and validate artist/title matches before writing playback.
4. Start playback with `action='play'` and the selected `uris`. If Spotify reports no active player, open Spotify (`open -a Spotify` on macOS), list devices, and retry with the explicit `device_id` of the intended device. An inactive but visible Connect device may accept explicit-target playback even when implicit playback fails.
5. Read playback state after the write. A successful 204 response proves command acceptance, not actual playback; if immediate state is empty, perform a subsequent read before declaring success.
6. Report the verified current track and device briefly. Do not create a persistent playlist when the user only requested playback.

## Volume on macOS

For quiet-background or waking requests, inspect both Spotify device volume and local system output volume, then lower Spotify volume before starting playback; this avoids a loud initial burst from the previous session's settings. Use 20% Spotify as an initial quiet setting, not an acoustic guarantee: system volume and speaker gain are independent. If lowering volume fails, resolve it before starting music rather than playing at the previous loud setting. Verify playback and volume together after the write. Do not apply the quiet preset to ordinary play requests without context.

1. Read Spotify's active device volume and increase it modestly, capped at 100; verify the new state.
2. If Spotify is already at 100 and playback is on this Mac, inspect and raise the macOS output volume rather than claiming the sound cannot get louder. The two controls are independent.
3. Use a small relative increase, preserve unrelated settings, and read back the result. Example AppleScript: `set currentVolume to output volume of (get volume settings)`; calculate a capped increase, `set volume output volume newVolume`, then `get volume settings`.
4. Reply in the user's language with the actual verified volume; do not give a setup explanation for a simple playback command.
