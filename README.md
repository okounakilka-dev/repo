# repo — Personal Dev Toolkit

> CAD plan automation (PowerShell/Python) + local take-turns AI pipeline (Qwen/SD/video).
> Built to be **Freebuff-ready**: clear structure, docs, build instructions, and clean history.

![license](https://img.shields.io/badge/license-MIT-green)
![python](https://img.shields.io/badge/python-3.10+-blue)
![platform](https://img.shields.io/badge/platform-Windows-lightgrey)

## Why this repo exists

A single organized home for my practical projects instead of scattered scripts.
Each folder is self-contained with its own README and build steps so an evaluator
(human or Freebuff agent) can understand, build, and run in minutes.

## Project structure

```
repo/
├── src/
│   ├── cad-automation/    # House/hotel floor-plan PNG + DXF R12 generators (PS1 + Python)
│   └── local-pipeline/    # Local Qwen->SD->video take-turns pipeline for 6GB VRAM (FastAPI+CLI)
├── docs/
│   ├── overview.md
│   └── freebuff.md
├── assets/                # Small preview images only (large renders stay local, gitignored)
├── .github/workflows/ci.yml
├── CONTRIBUTING.md
├── CHANGELOG.md
└── LICENSE (MIT)
```

## Quickstart

### 1. CAD automation

```powershell
# House plan PNG (GDI+)
powershell -ExecutionPolicy Bypass -File src\cad-automation\draw_house_plan.ps1
# DXF R12 (no deps)
python src\cad-automation\gen_dxf.py
```

Full guide: [src/cad-automation/README.md](src/cad-automation/README.md)

## Tech stack

| Area | Language | Key deps |
|------|----------|----------|
| CAD | PowerShell 5.1 + Python 3 | System.Drawing, stdlib only |

## Docs

- [docs/overview.md](docs/overview.md) — what/why/how for each module
- [docs/freebuff.md](docs/freebuff.md) — how to run this repo in Freebuff Cloud/CLI
- [CONTRIBUTING.md](CONTRIBUTING.md) — branch, commit, PR rules
- [CHANGELOG.md](CHANGELOG.md) — release history

## Freebuff evaluation checklist

- [x] Public repo with MIT LICENSE
- [x] Root README with description, structure, quickstart, badges
- [x] `.gitignore` (no `bin/`, `obj/`, `node_modules/`, `__pycache__/`, `*.blend1`, secrets)
- [x] One primary language per folder, no root-level loose scripts
- [x] Build docs per project + CI smoke test
- [x] Clean commit history (feat/docs/chore, not "love it")
- [x] Description + topics set on GitHub (see below)

After push, set on GitHub > About:
`Description: Personal dev toolkit — CAD automation, local AI pipeline`
`Topics: python, powershell, cad, dxf`

## License

MIT — see [LICENSE](LICENSE).
