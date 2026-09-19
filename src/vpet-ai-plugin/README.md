# VPet AI Plugin

C# .NET 8 WPF plugin for [VPet-Simulator](https://store.steampowered.com/) — chat + autonomous pet control via any OpenAI-compatible endpoint.

## Features
- Chat: adds "AI Assistant" to pet Talk API.
- Auto actions: tick loop (`TimeHandle`) + stat-change hook decides `feed|play|work|study|move|speak|pet|click|none` as JSON.
- Providers: OpenAI, DeepSeek, Ollama (`http://localhost:11434/v1/chat/completions`), LM Studio, custom.
- State-aware prompts: hunger/happiness/energy/money/level/animation/position + available foods/works.

## Build
```powershell
$env:VPetPath="C:\Program Files (x86)\Steam\steamapps\common\VPet-Simulator"
dotnet build VPet.AIPlugin.csproj -c Release -p:VPetPath="$env:VPetPath"
```

## Install
1. Copy `bin\Release\net8.0-windows\VPet.AIPlugin.dll` to `<VPet>\mod\AIPlugin\`.
2. Restart VPet -> right-click pet -> MOD Config -> AI Assistant.
3. Set Endpoint (must end `/v1/chat/completions`), API Key (empty for local), Model (e.g. `gpt-3.5-turbo`, `llama3.1`, `deepseek-chat`), Temperature, Max Tokens, Enable Automatic Actions, Interval.

## Files
- `AIPlugin.cs` — plugin entry, tick logic, prompts, action executor.
- `winSetting.xaml(.cs)` — settings window.
- `AssemblyInfo.cs` — assembly metadata.
- `VPet.AIPlugin.csproj` — `net8.0-windows`, `Newtonsoft.Json 13.0.3`, VPet refs (`Private=False`).

## Notes
- Settings file `AISetting*.json` is local-only (gitignored) — never commit keys.
- Requires VPet DLLs at build time via `$(VPetPath)`; CI documents this and skips full .NET build.
