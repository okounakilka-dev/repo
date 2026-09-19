"""Orchestrator — enhance -> image -> video, models take turns via MANAGER."""
import os
import time
import yaml
import imageio.v2 as imageio
import numpy as np

from model_manager import MANAGER
from stages.llm_enhance import LLMStage
from stages.image_gen import ImageStage
from stages.video_gen import VideoStage


def load_cfg(path="config.yaml"):
    with open(path) as f:
        return yaml.safe_load(f)


def build_stages(cfg):
    llm = LLMStage(cfg["llm"]["model_id"], cfg["llm"]["system_prompt"],
                   cfg["llm"].get("max_new_tokens", 256), cfg["llm"].get("temperature", 0.7))
    img = ImageStage(cfg["image"]["model_id"], cfg["image"].get("checkpoint_path"),
                     cfg["image"].get("steps", 25), cfg["image"].get("guidance", 7.5),
                     cfg["image"].get("width", 512), cfg["image"].get("height", 512))
    vid = VideoStage(cfg["video"]["model_id"], cfg["video"].get("num_frames", 24),
                     cfg["video"].get("steps", 25), cfg["video"].get("guidance", 9.0),
                     cfg["video"].get("width", 512), cfg["video"].get("height", 512))
    MANAGER.register("llm", llm)
    MANAGER.register("image", img)
    MANAGER.register("video", vid)
    return llm, img, vid


async def run_full(idea: str, cfg, do_image=True, do_video=True, seed=0):
    os.makedirs(cfg["outputs"]["dir"], exist_ok=True)
    stamp = time.strftime("%Y%m%d_%H%M%S")
    out = {"original": idea}

    # 1. LLM betters the prompt (loads LLM, others unloaded)
    llm = await MANAGER.acquire("llm")
    enhanced = llm.enhance(idea)
    out["enhanced"] = enhanced
    print(f"[pipe] enhanced: {enhanced}")

    # 2. queue image (unload LLM, load image)
    if do_image:
        img_stage = await MANAGER.acquire("image")
        img = img_stage.generate(enhanced, seed=seed)
        img_path = os.path.join(cfg["outputs"]["dir"], f"img_{stamp}.png")
        img.save(img_path)
        out["image"] = os.path.abspath(img_path)
        print(f"[pipe] image: {out['image']}")

    # 3. queue video (unload image, load video) — direct text-to-video on enhanced prompt
    if do_video:
        vid_stage = await MANAGER.acquire("video")
        frames = vid_stage.generate(enhanced, seed=seed)
        vid_path = os.path.join(cfg["outputs"]["dir"], f"vid_{stamp}.mp4")
        with imageio.get_writer(vid_path, fps=8) as w:
            for f in frames:
                w.append_data(np.array(f))
        out["video"] = os.path.abspath(vid_path)
        print(f"[pipe] video: {out['video']}")

    return out
