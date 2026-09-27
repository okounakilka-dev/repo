# Overview

## 1. CAD Automation (`src/cad-automation`)
House + hotel floor-plan renderers for quick client previews.
- PowerShell GDI+ (`System.Drawing`) PNGs: `draw_house_plan.ps1`, `draw_house_electrical*.ps1`, `draw_hotel_*.ps1` — 12x9m house, E101 power, E102 lighting, M101 water/HVAC.
- Python DXF R12 writers (stdlib only): `gen_dxf.py`, `gen_elec_dxf.py`, `gen_hotel_*.py` — layers `WALLS/WALLS_INT/DOORS/WINDOWS/ROOM_NAMES/DIMS/TEXT`, origin SW, Y-up.
- Convention: PNG `y_img 0=top(north)` -> CAD `y = H - y_img`; doors as ARC + leaf line.

## Design decisions
- Monorepo over 4 repos: easier for Freebuff Cloud to index in one connect, shared docs/CI.
- Stdlib-first for CAD: no pip install friction during evaluation.
- No secrets in repo: endpoints/keys live in local settings only.
