# AGENTS.md — for Freebuff / Codebuff agents

This repo is a personal dev toolkit. Be conservative, build incrementally.

## Layout
- `src/vpet-ai-plugin/` — C# .NET 8 WPF, `VPet.AIPlugin.csproj`, entry `AIPlugin.cs`. Needs `$(VPetPath)` DLLs to fully build.
- `src/cpp-rpg-game/` — C++17, `g++ main.cpp -o rpg-game -std=c++17` or CMake.
- `src/cad-automation/` — PowerShell GDI+ + Python stdlib DXF. Run from repo root.
- `src/blender-avatar/` — `bpy` scripts, run inside Blender in numeric order.
- `src/local-pipeline/` — Qwen3-1.7B -> SD1.5 -> video-ms-1.7B, one model in VRAM. See its README + `config.yaml`.

## Rules
- Never commit `bin/`, `obj/`, `__pycache__/`, `node_modules/`, `*.blend1`, `*.log`, `outputs/`, `AISetting*.json`, `.env`, keys.
- No secrets in code. Endpoints/keys stay in local settings.
- Keep diffs small, one purpose per change. Update per-folder README when behavior changes.
- Python: stdlib-first, `python -m py_compile` must pass. C++: `-Wall` clean.
