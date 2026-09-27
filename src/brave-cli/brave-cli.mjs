#!/usr/bin/env node
// brave-cli.mjs - agent-friendly CLI for Brave Browser (Windows)
// Uses Playwright + Brave remote-debugging for persistent sessions.
// Every command supports --json for stable machine output.
import { spawn, execSync } from "node:child_process";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dir = path.dirname(fileURLToPath(import.meta.url));
const BRAVE_EXE = "C:\\Program Files\\BraveSoftware\\Brave-Browser\\Application\\brave.exe";
const DEFAULT_PORT = 9222;
const PROFILE_DIR = path.join(__dir, ".brave-profile");
const REFS_FILE = path.join(__dir, ".brave-refs.json");
const STATE_FILE = path.join(__dir, ".brave-state.json");

const ENGINES = {
  brave: "https://search.brave.com/search?q=",
  google: "https://www.google.com/search?q=",
  bing: "https://www.bing.com/search?q=",
  duckduckgo: "https://duckduckgo.com/?q=",
};

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
function saveState(s) { fs.writeFileSync(STATE_FILE, JSON.stringify(s, null, 2)); }
function loadState() { try { return JSON.parse(fs.readFileSync(STATE_FILE, "utf8")); } catch { return {}; } }

async function getBrowser(port) {
  const { chromium } = await import("playwright");
  try {
    return await chromium.connectOverCDP(`http://127.0.0.1:${port}`);
  } catch (e) {
    throw new Error(`cannot connect to Brave on port ${port}. Run: node brave-cli.mjs launch. (${e.message.split("\n")[0]})`);
  }
}
async function getPage(port, index = 0) {
  const browser = await getBrowser(port);
  const contexts = browser.contexts();
  if (!contexts.length) throw new Error("no browser contexts");
  const pages = contexts[0].pages();
  if (!pages.length) {
    const p = await contexts[0].newPage();
    return { browser, page: p, cleanup: () => browser.close() };
  }
  const i = Math.min(index, pages.length - 1);
  // bring to front
  try { await pages[i].bringToFront(); } catch {}
  return { browser, page: pages[i], cleanup: () => browser.close() };
}
function isBraveRunning(port) {
  try {
    execSync(`netstat -ano | findstr :${port}`, { stdio: "pipe" });
    return true;
  } catch { return false; }
}

async function cmdLaunch(args, asJson) {
  const port = parseInt(getOpt(args, "--port") || DEFAULT_PORT, 10);
  const headed = !hasFlag(args, "--headless");
  if (!fs.existsSync(BRAVE_EXE)) fail(`Brave not found at ${BRAVE_EXE}`, "reinstall Brave", asJson);
  if (!fs.existsSync(PROFILE_DIR)) fs.mkdirSync(PROFILE_DIR, { recursive: true });
  if (isBraveRunning(port)) {
    try {
      const b = await getBrowser(port); b.close();
      return out({ ok: true, message: `Brave already running on port ${port}`, port }, asJson);
    } catch {}
  }
  const childArgs = [
    `--remote-debugging-port=${port}`,
    `--user-data-dir=${PROFILE_DIR}`,
    "--no-first-run", "--no-default-browser-check",
    "about:blank",
  ];
  if (!headed) childArgs.push("--headless=new");
  // Windows: shell tool reaps spawned children, so detach via Start-Process.
  // NOTE: -WorkingDirectory matters (some apps resolve data files from cwd).
  let pid = 0;
  if (process.platform === "win32") {
    const psArgs = childArgs.map(a => `'${a.replace(/'/g, "''")}'`).join(",");
    const ps = `Start-Process -FilePath '${BRAVE_EXE}' -WorkingDirectory 'C:\\Program Files\\BraveSoftware\\Brave-Browser\\Application' -ArgumentList ${psArgs}`;
    try {
      const { execSync: ex } = await import("node:child_process");
      ex(`powershell -NoProfile -Command "${ps}"`, { stdio: "ignore" });
    } catch {}
  } else {
    const child = spawn(BRAVE_EXE, childArgs, { detached: true, stdio: "ignore" });
    child.unref();
    pid = child.pid || 0;
  }
  // wait for CDP
  const { chromium } = await import("playwright");
  const deadline = Date.now() + 15000;
  let lastErr = "";
  while (Date.now() < deadline) {
    await new Promise(r => setTimeout(r, 500));
    try { const b = await chromium.connectOverCDP(`http://127.0.0.1:${port}`); b.close(); break; }
    catch (e) { lastErr = e.message.split("\n")[0]; }
  }
  saveState({ port, pid, launchedAt: new Date().toISOString() });
  out({ ok: true, message: `Brave launched on port ${port}`, port, profile: PROFILE_DIR }, asJson);
}

async function cmdOpen(args, asJson, rest) {
  const port = parseInt(getOpt(args, "--port") || loadState().port || DEFAULT_PORT, 10);
  const url = rest[0];
  if (!url) fail("missing <url>. Usage: open <url>", "e.g. open https://example.com --json", asJson);
  const wait = getOpt(args, "--wait") || "load";
  const full = /^https?:\/\//i.test(url) ? url : "https://" + url;
  const { browser, page, cleanup } = await getPage(port).catch(e => { fail(e.message, undefined, asJson); });
  await page.goto(full, { waitUntil: wait === "networkidle" ? "networkidle" : "load", timeout: 30000 });
  const title = await page.title().catch(() => "");
  cleanup();
  out({ ok: true, message: `opened ${full}`, url: full, title }, asJson);
}

async function cmdSearch(args, asJson, rest) {
  const engine = (getOpt(args, "--engine") || "brave").toLowerCase();
  const base = ENGINES[engine] || ENGINES.brave;
  const q = rest.join(" ");
  if (!q) fail("missing query. Usage: search <query>", undefined, asJson);
  const url = base + encodeURIComponent(q);
  await cmdOpen(["--port", String(parseInt(getOpt(args, "--port") || loadState().port || DEFAULT_PORT, 10))], asJson, [url]);
}

async function cmdTabs(args, asJson) {
  const port = parseInt(getOpt(args, "--port") || loadState().port || DEFAULT_PORT, 10);
  const browser = await getBrowser(port).catch(e => { fail(e.message, undefined, asJson); });
  const pages = browser.contexts()[0]?.pages() || [];
  const tabs = [];
  for (let i = 0; i < pages.length; i++) {
    tabs.push({ index: i, url: pages[i].url(), title: await pages[i].title().catch(() => "") });
  }
  browser.close();
  out({ ok: true, tabs }, asJson);
}

async function cmdSnapshot(args, asJson) {
  const port = parseInt(getOpt(args, "--port") || loadState().port || DEFAULT_PORT, 10);
  const idx = parseInt(getOpt(args, "--tab") || "0", 10);
  const limit = parseInt(getOpt(args, "--limit") || "80", 10);
  const { browser, page, cleanup } = await getPage(port, idx).catch(e => { fail(e.message, undefined, asJson); });
  // DOM-based snapshot (works on CDP pages where page.accessibility is unavailable)
  const els = await page.evaluate((lim) => {
    const nodes = Array.from(document.querySelectorAll(
      'a,button,input,select,textarea,[role=button],[role=link],[role=textbox],[role=checkbox],[role=radio],[role=combobox],[role=searchbox]'
    )).slice(0, lim);
    return nodes.map((e) => {
      const tag = e.tagName.toLowerCase();
      const text = ((e.innerText || e.value || e.getAttribute("aria-label") || e.getAttribute("placeholder") || e.getAttribute("name") || "") + "").replace(/\s+/g, " ").trim().slice(0, 80);
      let role = e.getAttribute("role") || tag;
      if (tag === "input") role = e.type === "checkbox" ? "checkbox" : e.type === "radio" ? "radio" : "textbox";
      if (tag === "a") role = "link";
      if (tag === "button") role = "button";
      if (tag === "select") role = "combobox";
      if (tag === "textarea") role = "textbox";
      const r = e.getBoundingClientRect();
      return { tag, role, name: text, href: e.href || undefined, type: e.type || undefined, visible: r.width > 0 && r.height > 0 };
    });
  }, limit).catch(() => []);
  const refs = els.map((el, i) => ({ ref: `@e${i + 1}`, ...el }));
  const urlNow = page.url();
  const titleNow = await page.title().catch(() => "");
  fs.writeFileSync(REFS_FILE, JSON.stringify({ at: new Date().toISOString(), url: urlNow, refs }, null, 2));
  cleanup();
  if (asJson) out({ ok: true, url: urlNow, title: titleNow, refs }, true);
  else {
    console.log(`URL: ${urlNow}`);
    for (const r of refs) console.log(`${r.ref} [${r.role}] ${r.name || r.text || r.tag || ""}`);
  }
}

function resolveTarget(target, refsData) {
  if (!target) return null;
  if (target.startsWith("@e")) {
    const hit = (refsData?.refs || []).find(r => r.ref === target);
    if (!hit) return null;
    // build selector from text
    const t = (hit.name || hit.text || "").trim();
    if (t) return { byText: t, hit };
    return { css: hit.tag || "button", hit };
  }
  return { css: target };
}

async function cmdClick(args, asJson, rest) {
  const port = parseInt(getOpt(args, "--port") || loadState().port || DEFAULT_PORT, 10);
  const target = rest[0];
  if (!target) fail("missing <target>. Usage: click <selector|@eN> (run snapshot first)", undefined, asJson);
  const { browser, page, cleanup } = await getPage(port).catch(e => { fail(e.message, undefined, asJson); });
  try {
    if (target.startsWith("@e")) {
      const n = parseInt(target.slice(2), 10);
      if (!n) throw new Error(`bad ref ${target}`);
      const clicked = await page.evaluate((idx) => {
        const nodes = Array.from(document.querySelectorAll(
          'a,button,input,select,textarea,[role=button],[role=link],[role=textbox],[role=checkbox],[role=radio],[role=combobox],[role=searchbox]'
        ));
        const el = nodes[idx - 1];
        if (!el) return null;
        el.scrollIntoView({ block: "center" });
        el.click();
        return { tag: el.tagName.toLowerCase(), text: (el.innerText || "").slice(0, 80) };
      }, n).catch(() => null);
      if (!clicked) throw new Error(`${target} not found. Run snapshot first.`);
    } else {
      await page.click(target, { timeout: 8000 });
    }
    cleanup();
    out({ ok: true, message: `clicked ${target}` }, asJson);
  } catch (e) { cleanup(); fail(`click failed: ${e.message.split("\n")[0]}`, "run snapshot, then use listed @eN or a CSS selector", asJson); }
}

async function cmdFill(args, asJson, rest) {
  const port = parseInt(getOpt(args, "--port") || loadState().port || DEFAULT_PORT, 10);
  const [selector, ...textParts] = rest;
  const text = textParts.join(" ");
  if (!selector || !text) fail("Usage: fill <selector|@eN> <text>", undefined, asJson);
  const { browser, page, cleanup } = await getPage(port).catch(e => { fail(e.message, undefined, asJson); });
  try {
    if (selector.startsWith("@e")) {
      const n = parseInt(selector.slice(2), 10);
      await page.evaluate(([idx, val]) => {
        const nodes = Array.from(document.querySelectorAll(
          'a,button,input,select,textarea,[role=button],[role=link],[role=textbox],[role=checkbox],[role=radio],[role=combobox],[role=searchbox]'
        ));
        const el = nodes[idx - 1];
        if (!el) return false;
        el.scrollIntoView({ block: "center" });
        el.focus();
        if ("value" in el) { el.value = val; el.dispatchEvent(new Event("input", { bubbles: true })); el.dispatchEvent(new Event("change", { bubbles: true })); }
        return true;
      }, [n, text]);
    } else await page.fill(selector, text, { timeout: 8000 });
    cleanup(); out({ ok: true, message: `filled ${selector}` }, asJson);
  } catch (e) { cleanup(); fail(`fill failed: ${e.message.split("\n")[0]}`, undefined, asJson); }
}

async function cmdShot(args, asJson, rest) {
  const port = parseInt(getOpt(args, "--port") || loadState().port || DEFAULT_PORT, 10);
  const file = rest[0] || path.join(__dir, "brave-shot.png");
  const fullPage = hasFlag(args, "--full");
  const { browser, page, cleanup } = await getPage(port).catch(e => { fail(e.message, undefined, asJson); });
  await page.screenshot({ path: file, fullPage });
  cleanup();
  out({ ok: true, message: `screenshot saved`, path: file }, asJson);
}

async function cmdText(args, asJson) {
  const port = parseInt(getOpt(args, "--port") || loadState().port || DEFAULT_PORT, 10);
  const max = parseInt(getOpt(args, "--max") || "8000", 10);
  const { browser, page, cleanup } = await getPage(port).catch(e => { fail(e.message, undefined, asJson); });
  const title = await page.title().catch(() => "");
  const url = page.url();
  const txt = (await page.evaluate(() => document.body ? document.body.innerText : "").catch(() => "")).slice(0, max);
  cleanup();
  out({ ok: true, url, title, text: txt }, asJson);
}

async function cmdInfo(args, asJson) {
  const port = parseInt(getOpt(args, "--port") || loadState().port || DEFAULT_PORT, 10);
  const { browser, page, cleanup } = await getPage(port).catch(e => { fail(e.message, undefined, asJson); });
  const info = { ok: true, url: page.url(), title: await page.title().catch(() => "") };
  cleanup(); out(info, asJson);
}

async function cmdClose(args, asJson, rest) {
  const port = parseInt(getOpt(args, "--port") || loadState().port || DEFAULT_PORT, 10);
  const what = rest[0];
  if (what === "browser") {
    try { execSync(`taskkill /F /FI "COMMANDLINE eq *--remote-debugging-port=${port}*"`, { stdio: "pipe" }); } catch {}
    try { fs.unlinkSync(STATE_FILE); } catch {}
    return out({ ok: true, message: "browser closed" }, asJson);
  }
  const { browser, cleanup } = await getBrowser(port).then(b => ({ browser: b, cleanup: () => b.close() })).catch(e => { fail(e.message, undefined, asJson); });
  const pages = browser.contexts()[0]?.pages() || [];
  if (pages.length) await pages[pages.length - 1].close().catch(() => {});
  cleanup();
  out({ ok: true, message: "tab closed" }, asJson);
}

function help(asJson) {
  const h = `brave-cli - control Brave Browser (agent-friendly)

Usage: node brave-cli.mjs <cmd> [args] [--json] [--port 9222]

 cmds:
  launch [--headless]          start Brave with remote debugging
  status                       is Brave running?
  open <url> [--wait load|networkidle]
  search <query> [--engine brave|google|bing|duckduckgo]
  tabs                         list open tabs
  snapshot [--limit 80]        accessibility refs (@eN) for click/fill
  click <selector|@eN>         click element
  fill <selector|@eN> <text>   fill input
  press <key>                  press key (Enter, Tab, Escape...)
  type <text...>               keyboard type
  shot [file] [--full]         screenshot
  text [--max 8000]            page text extract
  title|url|info               current page info
  pdf [file]                   save PDF
  close [browser]              close tab (or whole browser)

 flags: --json = stable JSON output for agents. Always use --json from scripts.
 ex: node brave-cli.mjs open https://example.com --json
     node brave-cli.mjs snapshot --json
     node brave-cli.mjs click @e3 --json`;
  if (asJson) out({ ok: true, help: h }, true); else console.log(h);
}

async function main() {
  const raw = process.argv.slice(2);
  const asJson = hasFlag(raw, "--json");
  const args = raw.filter(a => a !== "--json");
  const [cmd, ...rest] = args.filter(a => !a.startsWith("--") || a.startsWith("--port=") || ["--headless", "--full", "--wait", "--engine", "--tab", "--limit", "--max", "--port"].some(p => a === p || a.startsWith(p + "=")));
  // simpler: cmd is first non-flag
  const nonFlag = raw.filter(a => !a.startsWith("--") && a !== "--json");
  const c = (nonFlag[0] || "help").toLowerCase();
  const cmdRest = nonFlag.slice(1);
  try {
    switch (c) {
      case "help": case "--help": case "-h": return help(asJson);
      case "launch": return await cmdLaunch(raw, asJson);
      case "status": {
        const port = parseInt(getOpt(raw, "--port") || loadState().port || DEFAULT_PORT, 10);
        const running = isBraveRunning(port);
        return out({ ok: true, running, port, exe: BRAVE_EXE }, asJson);
      }
      case "open": return await cmdOpen(raw, asJson, cmdRest);
      case "search": return await cmdSearch(raw, asJson, cmdRest);
      case "tabs": return await cmdTabs(raw, asJson);
      case "snapshot": case "snap": return await cmdSnapshot(raw, asJson);
      case "click": return await cmdClick(raw, asJson, cmdRest);
      case "fill": return await cmdFill(raw, asJson, cmdRest);
      case "press": {
        const port = parseInt(getOpt(raw, "--port") || loadState().port || DEFAULT_PORT, 10);
        const key = cmdRest[0] || "Enter";
        const { browser, page, cleanup } = await getPage(port).catch(e => { fail(e.message, undefined, asJson); });
        await page.keyboard.press(key); cleanup();
        return out({ ok: true, message: `pressed ${key}` }, asJson);
      }
      case "type": {
        const port = parseInt(getOpt(raw, "--port") || loadState().port || DEFAULT_PORT, 10);
        const text = cmdRest.join(" ");
        const { browser, page, cleanup } = await getPage(port).catch(e => { fail(e.message, undefined, asJson); });
        await page.keyboard.type(text); cleanup();
        return out({ ok: true, message: `typed ${text.length} chars` }, asJson);
      }
      case "shot": case "screenshot": return await cmdShot(raw, asJson, cmdRest);
      case "text": case "extract": return await cmdText(raw, asJson);
      case "title": case "url": case "info": return await cmdInfo(raw, asJson);
      case "pdf": {
        const port = parseInt(getOpt(raw, "--port") || loadState().port || DEFAULT_PORT, 10);
        const file = cmdRest[0] || path.join(__dir, "brave-page.pdf");
        const { browser, page, cleanup } = await getPage(port).catch(e => { fail(e.message, undefined, asJson); });
        await page.pdf({ path: file }); cleanup();
        return out({ ok: true, path: file }, asJson);
      }
      case "close": return await cmdClose(raw, asJson, cmdRest);
      default: help(asJson); process.exit(1);
    }
  } catch (e) { fail(e.message, undefined, asJson); }
}
main();
