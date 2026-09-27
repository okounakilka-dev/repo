# Contributing

## Branches
- `main` is protected, always releasable.
- Create feature branches: `feat/<short-name>`, `fix/<short-name>`, `docs/<short-name>`.

## Commits (Conventional Commits)
```
feat(cad): add E102 lighting plan
fix(cad): correct DXF Y-flip for doors
docs(readme): add Freebuff quickstart
chore(repo): add .gitignore for python
```

## Pull requests
1. One purpose per PR.
2. Update README/docs if behavior changes.
3. Ensure CI passes (Python syntax check).
4. No `bin/`, `obj/`, `__pycache__/`, `node_modules/`, `*.blend1`, secrets, or large PNGs (>500KB) in diff.

## Code style
- Python: `python -m py_compile`, 4 spaces, no absolute local paths.
- PowerShell: full cmdlet names, `LiteralPath`, no `cd` inside scripts.

## Security
Never commit API keys, `.env`, `.pem`/`.key`.
