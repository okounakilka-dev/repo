# obs-cli

Agent-friendly CLI for OBS Studio (Windows) via obs-websocket v5, with stable `--json` output for scripts and agents.

## Install

```powershell
cd src/obs-cli
npm install
```

Requires OBS Studio 28+ at `C:\Program Files\obs-studio\bin\64bit\obs64.exe`.

## One-time setup

In OBS: `Tools -> WebSocket Server Settings -> Enable WebSocket server` (port 4455, no auth by default).
`obs-cli launch` writes a starter config, but OBS only starts the server once the setting has been enabled in the UI.

## Usage

```powershell
node obs-cli.mjs status --json
node obs-cli.mjs scenes --json
node obs-cli.mjs sources --json
node obs-cli.mjs switch "Scene Name" --json
node obs-cli.mjs show "Source Name" --json
node obs-cli.mjs start-record --json
node obs-cli.mjs stop-record --json
.\obs-cli.bat status --json
```

Remote/auth overrides: `--url ws://127.0.0.1:4455`, `--password xxx` (or `OBS_WS_URL` / `OBS_WS_PASSWORD` env).

## Notes

- `launch` uses Start-Process with the OBS `bin/64bit` folder as working directory (wrong cwd causes "Failed to find locale" errors).
- If port 4455 refuses connection, OBS is either not running or the WebSocket server is disabled (see one-time setup).
