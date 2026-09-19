"""Video stage — direct text-to-video (ModelScope 1.7B)."""
import torch
from diffusers import TextToVideoSDPipeline


class VideoStage:
    name = "video"

    def __init__(self, model_id, num_frames=24, steps=25, guidance=9.0, w=512, h=512):
        self.model_id = model_id
        self.num_frames = num_frames
        self.steps = steps
        self.guidance = guidance
        self.w = w
        self.h = h
        self.pipe = None

    def load(self):
        if self.pipe is not None:
            return
        print(f"[video] loading {self.model_id}")
        self.pipe = TextToVideoSDPipeline.from_pretrained(
            self.model_id, torch_dtype=torch.float16 if torch.cuda.is_available() else torch.float32
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
        assert self.pipe is not None, "Video model not loaded"
        g = torch.Generator(device="cuda" if torch.cuda.is_available() else "cpu").manual_seed(seed)
        frames = self.pipe(prompt, num_inference_steps=self.steps,
                           guidance_scale=self.guidance, width=self.w, height=self.h,
                           num_frames=self.num_frames, generator=g).frames[0]
        return frames  # list[PIL]
