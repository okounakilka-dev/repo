# repo — Personal Dev Toolkit

> VPet AI plugin (C#) + C++ RPG game + CAD plan automation (PowerShell/Python) + Blender avatar pipeline + local take-turns AI pipeline (Qwen/SD/video).
> Built to be **Freebuff-ready**: clear structure, docs, build instructions, and clean history.

![license](https://img.shields.io/badge/license-MIT-green)
![dotnet](https://img.shields.io/badge/.NET-8.0-blue)
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
│   ├── vpet-ai-plugin/    # C# .NET 8 WPF plugin for VPet-Simulator (OpenAI-compatible chat + auto actions)
│   ├── cpp-rpg-game/      # Self-contained C++ console RPG (no deps, g++/MSVC)
│   ├── cad-automation/    # House/hotel floor-plan PNG + DXF R12 generators (PS1 + Python)
│   ├── blender-avatar/    # Blender 3D anime-avatar build pipeline (step1-6 + base)
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

### 1. VPet AI Plugin (main project)

```powershell
# Prerequisites: VPet-Simulator (Steam), .NET 8 SDK
$env:VPetPath="C:\Program Files (x86)\Steam\steamapps\common\VPet-Simulator"
dotnet build src\vpet-ai-plugin\VPet.AIPlugin.csproj -c Release -p:VPetPath="$env:VPetPath"
# Copy bin\Release\net8.0-windows\VPet.AIPlugin.dll -> <VPet>\mod\AIPlugin\
```

Full guide: [src/vpet-ai-plugin/README.md](src/vpet-ai-plugin/README.md)

### 2. C++ RPG game

```powershell
g++ src\cpp-rpg-game\main.cpp -o rpg-game -std=c++17
.\rpg-game
# or: MSVC -> cl /EHsc src\cpp-rpg-game\main.cpp
```

Full guide: [src/cpp-rpg-game/README.md](src/cpp-rpg-game/README.md)

### 3. CAD automation

```powershell
# House plan PNG (GDI+)
powershell -ExecutionPolicy Bypass -File src\cad-automation\draw_house_plan.ps1
# DXF R12 (no deps)
python src\cad-automation\gen_dxf.py
```

Full guide: [src/cad-automation/README.md](src/cad-automation/README.md)

### 4. Blender avatar

```powershell
# Inside Blender Text Editor or:
blender --background --python src\blender-avatar\anime_girl_base.py
```

Full guide: [src/blender-avatar/README.md](src/blender-avatar/README.md)

## Tech stack

| Area | Language | Key deps |
|------|----------|----------|
| VPet plugin | C# .NET 8 WPF | Newtonsoft.Json, VPet-Simulator.Core |
| RPG game | C++17 | STL only |
| CAD | PowerShell 5.1 + Python 3 | System.Drawing, stdlib only |
| Blender | Python (bpy) | Blender 3.6+ |

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
`Description: Personal dev toolkit — VPet AI plugin, C++ RPG, CAD automation, Blender pipeline`
`Topics: csharp, dotnet, cpp, python, powershell, blender, cad, dxf, vpet, ai-plugin`

## License

MIT — see [LICENSE](LICENSE).
