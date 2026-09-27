#!/usr/bin/env node
// obs-cli.mjs - agent-friendly CLI for OBS Studio via WebSocket (obs-websocket v5).
// Requires: OBS running with Tools -> WebSocket Server Settings -> Enable (default ws://127.0.0.1:4455).
// Every command supports --json for stable machine output.
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { spawn } from "node:child_process";

const __dir = path.dirname(fileURLToPath(import.meta.url));
const OBS_EXE = "C:\\Program Files\\obs-studio\\bin\\64bit\\obs64.exe";
const DEFAULT_URL = "ws://127.0.0.1:4455";

function out(obj, asJson) {
  if (asJson) console.log(JSON.stringify(obj, null, 2));
  else {
    if (obj.ok === false) { console.error("ERR: " + (obj.error || "failed")); if (obj.hint) console.error("hint: " + obj.hint); }
    else if (obj.message) console.log(obj.message);
    else console.log(JSON.stringify(obj, null, 2));
  }
}
function fail(error, hint, asJson) { out({ ok: false, error, hint }, asJson); process.exit(1); }
function hasFlag(args, ...names) { return names.some(n => args.includes(n)); }
function getOpt(args, ...names) {
  for (let i = 0; i < args.length; i++) {
    for (const n of names) {
      if (args[i] === n && i + 1 < args.length) return args[i + 1];
      if (args[i].startsWith(n + "=")) return args[i].slice(n.length + 1);
    }
  }
  return undefined;
}

async function connect(url, password) {
  const { OBSWebSocket } = await import("obs-websocket-js");
  const obs = new OBSWebSocket();
  try {
    await obs.connect(url, password || undefined);
    return obs;
  } catch (e) {
    throw new Error(`cannot connect to OBS at ${url} (${e.message.split("\n")[0]}). Start OBS and enable Tools -> WebSocket Server Settings.`);
  }
}
async function withObs(args, fn, asJson) {
  const url = getOpt(args, "--url") || process.env.OBS_WS_URL || DEFAULT_URL;
  const password = getOpt(args, "--password") || process.env.OBS_WS_PASSWORD || undefined;
  const obs = await connect(url, password).catch(e => { fail(e.message, "Is OBS running? Tools -> WebSocket Server Settings -> Enable server, port 4455.", asJson); });
  try { const r = await fn(obs); await obs.disconnect(); return r; }
  catch (e) { try { await obs.disconnect(); } catch {} throw e; }
}

function help(asJson) {
  const h = `obs-cli - control OBS Studio via WebSocket (agent-friendly)

Usage: node obs-cli.mjs <cmd> [args] [--json] [--url ws://127.0.0.1:4455] [--password xxx]

 cmds:
  launch [--tray]              start OBS (minimized to tray with --tray)
  status                       version + streaming/recording + current scene
  scenes                       list scenes + current program scene
  sources [scene]              list sources/items in scene (default: current)
  switch <scene>               set current program scene
  show <source> [scene]        enable scene item
  hide <source> [scene]        disable scene item
  start-stream | stop-stream   control streaming
  start-record | stop-record   control recording
  shot <source> <file.png>     save source screenshot (absolute path best)
  help

 flags: --json = stable JSON output. Always use --json from scripts.
 env: OBS_WS_URL, OBS_WS_PASSWORD
 ex: node obs-cli.mjs status --json
     node obs-cli.mjs switch "Scene 2" --json
     node obs-cli.mjs start-record --json`;
  if (asJson) out({ ok: true, help: h }, true); else console.log(h);
}

async function main() {
  const raw = process.argv.slice(2);
  const asJson = hasFlag(raw, "--json");
  const nonFlag = raw.filter(a => !a.startsWith("--"));
  const c = (nonFlag[0] || "help").toLowerCase();
  const rest = nonFlag.slice(1);
  try {
    switch (c) {
      case "help": case "--help": case "-h": return help(asJson);
      case "launch": {
        if (!fs.existsSync(OBS_EXE)) fail(`OBS not found at ${OBS_EXE}`, "install OBS Studio", asJson);
        const tray = hasFlag(raw, "--tray");
        if (process.platform === "win32") {
          const { execSync: ex } = await import("node:child_process");
          // Array-style -ArgumentList (one string with spaces = ONE arg) + WorkingDirectory
          // (OBS resolves locale/data files from cwd; wrong cwd => "Failed to find locale" dialogs).
          const argList = tray ? "'--minimize-to-tray','--disable-shutdown-check'" : "'--disable-shutdown-check'";
          ex(`powershell -NoProfile -Command "Start-Process -FilePath '${OBS_EXE}' -WorkingDirectory 'C:\\Program Files\\obs-studio\\bin\\64bit' -ArgumentList ${argList}"`, { stdio: "ignore" });
        } else {
          const child = spawn(OBS_EXE, tray ? ["--minimize-to-tray"] : [], { detached: true, stdio: "ignore" });
          child.unref();
        }
        return out({ ok: true, message: "OBS launch requested", hint: "wait ~10s then run: status --json" }, asJson);
      }
      case "status": return out(await withObs(raw, async (obs) => {
        const ver = await obs.call("GetVersion");
        const stream = await obs.call("GetStreamStatus").catch(() => ({}));
        const rec = await obs.call("GetRecordStatus").catch(() => ({}));
        const scene = await obs.call("GetSceneList").then(s => s.currentProgramSceneName).catch(() => "");
        return { ok: true, obsVersion: ver.obsVersion, wsVersion: ver.obsWebSocketVersion, streaming: !!stream.outputActive, recording: !!rec.outputActive, scene };
      }, asJson), asJson);
      case "scenes": return out(await withObs(raw, async (obs) => {
        const s = await obs.call("GetSceneList");
        return { ok: true, current: s.currentProgramSceneName, scenes: (s.scenes || []).map(x => x.sceneName) };
      }, asJson), asJson);
      case "sources": return out(await withObs(raw, async (obs) => {
        let scene = rest[0];
        if (!scene) scene = await obs.call("GetSceneList").then(s => s.currentProgramSceneName);
        const items = await obs.call("GetSceneItemList", { sceneName: scene });
        return { ok: true, scene, sources: (items.sceneItems || []).map(i => ({ id: i.sceneItemId, name: i.sourceName, enabled: !!i.sceneItemEnabled })) };
      }, asJson), asJson);
      case "switch": {
        const scene = rest.join(" ");
        if (!scene) fail("missing <scene>. Usage: switch <scene>", undefined, asJson);
        return out(await withObs(raw, async (obs) => {
          await obs.call("SetCurrentProgramScene", { scene });
          return { ok: true, message: `switched to ${scene}` };
        }, asJson), asJson);
      }
      case "show": case "hide": {
        const enable = c === "show";
        const [source, ...sceneParts] = rest;
        if (!source) fail(`Usage: ${c} <source> [scene]`, undefined, asJson);
        return out(await withObs(raw, async (obs) => {
          const scene = sceneParts.join(" ") || await obs.call("GetSceneList").then(s => s.currentProgramSceneName);
          const items = await obs.call("GetSceneItemList", { sceneName: scene });
          const item = (items.sceneItems || []).find(i => i.sourceName.toLowerCase() === source.toLowerCase());
          if (!item) throw new Error(`source "${source}" not in scene "${scene}". Run: sources "${scene}"`);
          await obs.call("SetSceneItemEnabled", { sceneName: scene, sceneItemId: item.sceneItemId, sceneItemEnabled: enable });
          return { ok: true, message: `${source} ${enable ? "shown" : "hidden"} in ${scene}` };
        }, asJson), asJson);
      }
      case "start-stream": return out(await withObs(raw, async (obs) => { await obs.call("StartStream"); return { ok: true, message: "streaming started" }; }, asJson), asJson);
      case "stop-stream": return out(await withObs(raw, async (obs) => { await obs.call("StopStream"); return { ok: true, message: "streaming stopped" }; }, asJson), asJson);
      case "start-record": return out(await withObs(raw, async (obs) => { await obs.call("StartRecord"); return { ok: true, message: "recording started" }; }, asJson), asJson);
      case "stop-record": return out(await withObs(raw, async (obs) => { await obs.call("StopRecord"); return { ok: true, message: "recording stopped", path: (await obs.call("GetRecordStatus").catch(() => ({}))).outputPath }; }, asJson), asJson);
      case "shot": {
        const [source, file] = rest;
        if (!source || !file) fail("Usage: shot <source> <file.png>", undefined, asJson);
        const abs = path.isAbsolute(file) ? file : path.join(__dir, file);
        return out(await withObs(raw, async (obs) => {
          await obs.call("SaveSourceScreenshot", { sourceName: source, imageFormat: "png", imageFilePath: abs });
          return { ok: true, message: "screenshot saved", path: abs };
        }, asJson), asJson);
      }
      default: help(asJson); process.exit(1);
    }
  } catch (e) { fail(e.message, undefined, asJson); }
}
main();
