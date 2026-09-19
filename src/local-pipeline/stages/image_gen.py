"""Image stage — SD 1.5 + your 3-way merged checkpoint support."""
import os
import torch
from diffusers import StableDiffusionPipeline


class ImageStage:
    name = "image"

    def __init__(self, model_id, checkpoint_path=None, steps=25, guidance=7.5, w=512, h=512):
        self.model_id = model_id
        self.checkpoint_path = checkpoint_path
        self.steps = steps
        self.guidance = guidance
        self.w = w
        self.h = h
        self.pipe = None

    def _target(self):
        # prefer your merged file if it exists, else hub id
        if self.checkpoint_path and os.path.exists(self.checkpoint_path):
            return self.checkpoint_path
        return self.model_id

    def load(self):
        if self.pipe is not None:
            return
        target = self._target()
        print(f"[image] loading {target}")
        if target.endswith(".safetensors") or target.endswith(".ckpt"):
            self.pipe = StableDiffusionPipeline.from_single_file(
                target, torch_dtype=torch.float16 if torch.cuda.is_available() else torch.float32
            )
        else:
            self.pipe = StableDiffusionPipeline.from_pretrained(
                target, torch_dtype=torch.float16 if torch.cuda.is_available() else torch.float32
            )
        if torch.cuda.is_available():
            self.pipe = self.pipe.to("cuda")
            try:
                self.pipe.enable_attention_slicing()
                self.pipe.enable_vae_slicing()
            except Exception:
                pass
        else:
            self.pipe = self.pipe.to("cpu")

    def unload(self):
        self.pipe = None

    def generate(self, prompt: str, seed: int = 0):
        assert self.pipe is not None, "Image model not loaded"
        g = torch.Generator(device="cuda" if torch.cuda.is_available() else "cpu").manual_seed(seed)
        img = self.pipe(prompt, num_inference_steps=self.steps,
                        guidance_scale=self.guidance, width=self.w, height=self.h,
                        generator=g).images[0]
        return img
