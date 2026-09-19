# Running this repo in Freebuff

Freebuff Cloud/CLI evaluates repos best when they have: README quickstart, one-command builds, no junk, and no secrets. This repo is prepared for that.

## 1. Connect to Freebuff Cloud
1. Push this repo to GitHub (public).
2. Go to Freebuff Cloud -> Connect repository -> select `okounakilka-dev/repo`.
3. Use prompt: `Build the C++ RPG game and explain the VPet plugin architecture from src/vpet-ai-plugin/AIPlugin.cs`.

## 2. CLI smoke test
```bash
npm install -g freebuff
cd repo
freebuff
# then ask: "Summarize src/ structure and how to build each project"
```

## 3. What Freebuff checks (and where we pass)
- **Description + README**: root README has what/why/quickstart/structure/badges.
- **Language detection**: C# (.sln/csproj), C++ (.cpp/CMake), Python, PowerShell — no empty repo.
- **Buildability**: CI builds C++ and compiles Python; .NET build documented (requires VPet DLLs, so CI skips it with clear note).
- **No noise**: `.gitignore` excludes `bin/obj/__pycache__/node_modules/*.blend1/*.log` + large renders.
- **License**: MIT `LICENSE`.
- **Activity**: multiple conventional commits, not single "love it".
- **Security**: no API keys; `AISetting*.json` ignored.

## 4. If credits are still 0
- Ensure repo is **Public**, not private.
- Ensure default branch is `main` with >1 commit.
- Add About description + topics (csharp, cpp, python, blender, cad).
- Make at least one Issue + one PR (shows maintenance).
- Re-connect in Freebuff Cloud after push (it caches empty repos).
