# Changelog

All notable changes follow [Keep a Changelog](https://keepachangelog.com/) + SemVer.

## [0.2.0] - 2026-09-19
### Added
- Organized monorepo layout: `src/vpet-ai-plugin`, `src/cpp-rpg-game`, `src/cad-automation`, `src/blender-avatar`
- Root README with quickstarts, structure, Freebuff checklist
- `.gitignore` for .NET/Python/Blender/secrets
- `CONTRIBUTING.md`, `docs/overview.md`, `docs/freebuff.md`
- CI: C++ build + Python compile check
- Per-project READMEs + `CMakeLists.txt` for RPG game

### Removed
- Loose root scripts/images/logs from version control (kept as local only)
- `bin/`, `obj/`, `__pycache__/`, `node_modules/` from tracking

## [0.1.0] - 2026-09-10
### Added
- Initial VPet AIPlugin (chat + autonomous actions)
- C++ console RPG prototype
- House/hotel PS1 + Python DXF generators
- Blender avatar step scripts
