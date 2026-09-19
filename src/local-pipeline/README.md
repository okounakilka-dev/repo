# Local take-turns pipeline (rebuilt)

Your lost project: **LLM chat -> betters prompt -> queues image gen -> unloads/loads -> direct text-to-video**. One model in VRAM at a time (RTX 3050 6GB).

## Flow
```
you: "a cabin"
 -> [LLM loaded, others unloaded] Qwen3-1.7B enhances -> "cozy snow cabin, warm lights, ultra detailed..."
 -> [unload LLM, load SD] image gen saves outputs/img_*.png
 -> [unload image, load video] direct text-to-video saves outputs/vid_*.mp4
 -> all unloaded, VRAM free
```

## Setup
```powershell
cd local-pipeline
pip install -r requirements.txt
# Qwen3-1.7B auto-downloads (you already have it cached)
# SD1.5 + video 1.7B download on first run (~5GB total)
```

## Use — both CLI + UI
```powershell
# CLI
python run.py "a cozy cabin in snow" --seed 0
python run.py "a dragon" --no-video   # image only

# API + Web UI
uvicorn server:app --port 8000
# open http://127.0.0.1:8000
```

## Your merged 3 image gens
You merged 3 checkpoints before. To restore:
```powershell
python merge_checkpoints.py --a modelA.safetensors --b modelB.safetensors --c modelC.safetensors --weights 0.5 0.3 0.2 --out models/merged-3in1.safetensors
# then in config.yaml: image.checkpoint_path: "models/merged-3in1.safetensors"
```
If you still have the 3 `.safetensors` files, tell me their paths and I wire them in. Otherwise default `runwayml/stable-diffusion-v1-5` works now.

## Why take-turns
RTX 3050 = 6GB. Qwen1.7B (~3.5GB fp16) + SD1.5 (~4GB) + video1.7B (~4GB) cannot coexist. `model_manager.py` holds an `asyncio.Lock`: `acquire()` unloads current, `cuda.empty_cache()`, loads next. `/health` shows what's loaded + VRAM free.
