"""API + UI — uvicorn server:app --port 8000. Queue is the MANAGER lock (one job at a time)."""
import asyncio
import os
from fastapi import FastAPI
from fastapi.responses import HTMLResponse, FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from pipeline import load_cfg, build_stages, run_full

cfg = load_cfg(os.path.join(os.path.dirname(__file__), "config.yaml"))
build_stages(cfg)
os.makedirs(cfg["outputs"]["dir"], exist_ok=True)

app = FastAPI(title="local take-turns pipeline")
app.mount("/outputs", StaticFiles(directory=cfg["outputs"]["dir"]), name="outputs")
JOB_LOCK = asyncio.Lock()


class Req(BaseModel):
    prompt: str
    do_image: bool = True
    do_video: bool = True
    seed: int = 0


@app.post("/generate")
async def generate(r: Req):
    async with JOB_LOCK:  # queue jobs, models take turns inside too
        out = await run_full(r.prompt, cfg, r.do_image, r.do_video, r.seed)
    return out


@app.get("/", response_class=HTMLResponse)
def index():
    with open(os.path.join(os.path.dirname(__file__), "ui", "index.html")) as f:
        return f.read()


@app.get("/health")
def health():
    from model_manager import MANAGER
    import torch
    vram = {}
    if torch.cuda.is_available():
        free, total = torch.cuda.mem_get_info()
        vram = {"free_gb": round(free / 1024**3, 2), "total_gb": round(total / 1024**3, 2)}
    return {"loaded": MANAGER.loaded, "vram": vram}
