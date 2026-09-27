# AGENTS.md — for Freebuff / Codebuff agents

This repo is a personal dev toolkit. Be conservative, build incrementally.

## Layout
- `src/cad-automation/` — PowerShell GDI+ + Python stdlib DXF. Run from repo root.
- `src/local-pipeline/` — Qwen3-1.7B -> SD1.5 -> video-ms-1.7B, one model in VRAM. See its README + `config.yaml`.

## Rules
- Never commit `bin/`, `obj/`, `__pycache__/`, `node_modules/`, `*.blend1`, `*.log`, `outputs/`, `AISetting*.json`, `.env`, keys.
- No secrets in code. Endpoints/keys stay in local settings.
- Keep diffs small, one purpose per change. Update per-folder README when behavior changes.
- Python: stdlib-first, `python -m py_compile` must pass.
