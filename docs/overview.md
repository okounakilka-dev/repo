# Overview

## 1. VPet AI Plugin (`src/vpet-ai-plugin`)
C# .NET 8 WPF plugin for VPet-Simulator.
- Connects to any OpenAI-compatible `/v1/chat/completions` endpoint (OpenAI, DeepSeek, Ollama, LM Studio).
- Adds "AI Assistant" chat option + autonomous loop (`TimeHandle` tick + `FunctionSpendHandle` stat change).
- Reads pet state (hunger, happiness, energy, money, level, animation, position) and prompts LLM for one JSON action: `feed|play|work|study|move|speak|pet|click|none`.
- Settings persisted via `AISetting*.json` (gitignored) + VPet `Set["AIPlugin"]` store.
- Key files: `AIPlugin.cs` (~393 lines), `winSetting.xaml(.cs)` (settings UI), `VPet.AIPlugin.csproj` (net8.0-windows, Newtonsoft.Json 13.0.3).

## 2. C++ RPG Game (`src/cpp-rpg-game`)
Single-file C++17 turn-based RPG, zero dependencies.
- `Player` {hp, atk, potions, xp, level} vs `Slime/Goblin/Orc/Dragon`.
- Actions: attack (randomized dmg), potion (+30 HP), run (50%).
- XP 15-30 per win, level-up at `level*50` (+20 maxHp, +3 atk, +1 potion).
- Builds with `g++ -std=c++17` or MSVC `cl`.

## 3. CAD Automation (`src/cad-automation`)
House + hotel floor-plan renderers for quick client previews.
- PowerShell GDI+ (`System.Drawing`) PNGs: `draw_house_plan.ps1`, `draw_house_electrical*.ps1`, `draw_hotel_*.ps1` — 12x9m house, E101 power, E102 lighting, M101 water/HVAC.
- Python DXF R12 writers (stdlib only): `gen_dxf.py`, `gen_elec_dxf.py`, `gen_hotel_*.py` — layers `WALLS/WALLS_INT/DOORS/WINDOWS/ROOM_NAMES/DIMS/TEXT`, origin SW, Y-up.
- Convention: PNG `y_img 0=top(north)` -> CAD `y = H - y_img`; doors as ARC + leaf line.

## 4. Blender Avatar (`src/blender-avatar`)
Procedural anime-avatar pipeline (Blender 3.6+, `bpy`).
- `anime_girl_base.py` — base mesh + materials.
- `blend_step1..6.py` — incremental passes (body, face, eyes, hair, cloth, final).
- `blender_bridge.py` — external trigger helper.
- Outputs are local `.blend`/`.png` (gitignored except small previews in `assets/`).

## Design decisions
- Monorepo over 4 repos: easier for Freebuff Cloud to index in one connect, shared docs/CI.
- Stdlib-first for CAD/Blender: no pip install friction during evaluation.
- No secrets in repo: endpoints/keys live in local settings only.
