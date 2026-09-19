# CAD Automation

House + hotel floor-plan PNG + DXF generators. Stdlib-only, Windows-first.

## PNG renders (PowerShell 5.1 + System.Drawing/GDI+)
```powershell
powershell -ExecutionPolicy Bypass -File draw_house_plan.ps1        # 12x9m house
powershell -ExecutionPolicy Bypass -File draw_house_electrical.ps1  # electrical
powershell -ExecutionPolicy Bypass -File draw_hotel_floor.ps1       # hotel floor
powershell -ExecutionPolicy Bypass -File draw_hotel_E101_power.ps1  # E101 power
powershell -ExecutionPolicy Bypass -File draw_hotel_E102_lighting.ps1
powershell -ExecutionPolicy Bypass -File draw_hotel_M101_waterhvac.ps1
```
Outputs `*.png` next to script (gitignored if >500KB — keep only small previews in `assets/`).

## DXF R12 (Python, no pip needed)
```powershell
python gen_dxf.py              # -> house_plan.dxf
python gen_elec_dxf.py         # -> house_electrical.dxf
python gen_hotel_dxf.py
python gen_hotel_elec_utils.py
```
Layers: `WALLS, WALLS_INT, DOORS, WINDOWS, ROOM_NAMES, DIMS, TEXT`. Origin SW, meters, Y-up. PNG `y_img` (0=top) converts via `Yc = H - y_img`. Doors = ARC + leaf line.

## Conventions
- Ext walls 200mm (double line), int 100mm (centerline + layer note).
- Do not commit generated `*.dxf/*.png` unless small example for docs — regenerating is the workflow.
