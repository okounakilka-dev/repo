"""Merge 3 SD checkpoints into 1 (your 'merged 3 image gens' workflow).

Usage:
  python merge_checkpoints.py --a modelA.safetensors --b modelB.safetensors --c modelC.safetensors --weights 0.5 0.3 0.2 --out models/merged-3in1.safetensors

Merges UNet + text-encoder + VAE tensors by weighted average.
Works when all 3 share architecture (e.g. all SD1.5 based).
"""
import argparse
import os
from safetensors.torch import load_file, save_file


def merge_3(a, b, c, weights, out):
    wa, wb, wc = weights
    assert abs(wa + wb + wc - 1.0) < 1e-5, "weights must sum to 1.0"
    print(f"loading {a} ...")
    ta = load_file(a)
    print(f"loading {b} ...")
    tb = load_file(b)
    print(f"loading {c} ...")
    tc = load_file(c)
    keys = set(ta) & set(tb) & set(tc)
    print(f"common keys: {len(keys)}")
    merged = {}
    for k in keys:
        merged[k] = ta[k].float() * wa + tb[k].float() * wb + tc[k].float() * wc
        merged[k] = merged[k].to(ta[k].dtype)
    os.makedirs(os.path.dirname(os.path.abspath(out)) or ".", exist_ok=True)
    save_file(merged, out)
    print(f"saved {out} ({len(merged)} tensors)")


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("--a", required=True)
    p.add_argument("--b", required=True)
    p.add_argument("--c", required=True)
    p.add_argument("--weights", nargs=3, type=float, default=[0.5, 0.3, 0.2])
    p.add_argument("--out", default="models/merged-3in1.safetensors")
    args = p.parse_args()
    merge_3(args.a, args.b, args.c, args.weights, args.out)
