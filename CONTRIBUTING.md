# Contributing

## Branches
- `main` is protected, always releasable.
- Create feature branches: `feat/<short-name>`, `fix/<short-name>`, `docs/<short-name>`.

## Commits (Conventional Commits)
```
feat(vpet): add auto-feed action prompt
fix(cad): correct DXF Y-flip for doors
docs(readme): add Freebuff quickstart
chore(repo): add .gitignore for dotnet/python
```

## Pull requests
1. One purpose per PR.
2. Update README/docs if behavior changes.
3. Ensure CI passes (C++ build + Python syntax check).
4. No `bin/`, `obj/`, `__pycache__/`, `node_modules/`, `*.blend1`, secrets, or large PNGs (>500KB) in diff.

## Code style
- C#: `dotnet format`, nullable enabled, no hardcoded secrets.
- C++: C++17, `-Wall` clean.
- Python: `python -m py_compile`, 4 spaces, no absolute local paths.
- PowerShell: full cmdlet names, `LiteralPath`, no `cd` inside scripts.

## Security
Never commit API keys, `AISetting*.json`, `.env`, `.pem`/`.key`.
Use `AISetting.example.json` pattern instead.
