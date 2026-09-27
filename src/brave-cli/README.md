# brave-cli

Agent-friendly CLI for Brave Browser (Windows). Drives Brave over Chrome DevTools Protocol via Playwright, with stable `--json` output for scripts and agents.

## Install

```powershell
cd src/brave-cli
npm install
```

Requires Brave at `C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe`.

## Usage

```powershell
node brave-cli.mjs launch --json
node brave-cli.mjs open https://example.com --json
node brave-cli.mjs snapshot --json
node brave-cli.mjs click @e1 --json
node brave-cli.mjs text --json
node brave-cli.mjs shot out.png --json
.\brave-cli.bat status --json
```

Agent pattern: `open` -> `snapshot` -> `click`/`fill` -> `text`/`shot`. Always pass `--json`.

## Notes

- Uses an isolated profile in `.brave-profile/` next to the script (main Brave profile untouched).
- `snapshot` prints `@eN` refs; `click`/`fill` accept a ref or CSS selector.
- `launch` uses Start-Process with the Brave directory as working directory.
