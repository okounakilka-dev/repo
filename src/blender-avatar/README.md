# Blender Avatar Pipeline

Procedural anime-avatar builder for Blender 3.6+ (`bpy`).

## Steps
1. `anime_girl_base.py` — base mesh, proportions, base materials.
2. `blend_step1.py` → `blend_step6.py` — incremental passes: body → face → eyes → hair → cloth → final polish.
3. `blender_bridge.py` — helper to trigger builds externally.

## Run
```powershell
# Inside Blender: Text Editor -> Open -> Run Script in order
# Or headless:
blender --background --python anime_girl_base.py
blender --background --python blend_step1.py
```

## Notes
- Keep working `.blend` files local (gitignored: `*.blend1` backups + large `.blend`).
- Commit only scripts + small preview PNGs (<500KB) in `assets/`.
- Tested pattern: run base once, then steps 1-6 in order, save final as `anime_girl_final.blend` locally.
