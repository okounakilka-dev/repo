"""CLI — python run.py "a cozy cabin" [--no-video] [--no-image]"""
import argparse
import asyncio
from pipeline import load_cfg, build_stages, run_full


def main():
    p = argparse.ArgumentParser()
    p.add_argument("prompt", help="your idea in plain words")
    p.add_argument("--config", default="config.yaml")
    p.add_argument("--no-image", action="store_true")
    p.add_argument("--no-video", action="store_true")
    p.add_argument("--seed", type=int, default=0)
    a = p.parse_args()
    cfg = load_cfg(a.config)
    build_stages(cfg)
    out = asyncio.run(run_full(a.prompt, cfg, do_image=not a.no_image,
                               do_video=not a.no_video, seed=a.seed))
    print(out)


if __name__ == "__main__":
    main()
