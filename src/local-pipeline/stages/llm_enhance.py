"""LLM stage — Qwen3-1.7B prompt bettering. Loads, generates, unloads on turn."""
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer


class LLMStage:
    name = "llm"

    def __init__(self, model_id: str, system_prompt: str, max_new_tokens=256, temperature=0.7):
        self.model_id = model_id
        self.system_prompt = system_prompt
        self.max_new_tokens = max_new_tokens
        self.temperature = temperature
        self.model = None
        self.tok = None

    def load(self):
        if self.model is not None:
            return
        self.tok = AutoTokenizer.from_pretrained(self.model_id, trust_remote_code=True)
        self.model = AutoModelForCausalLM.from_pretrained(
            self.model_id,
            torch_dtype=torch.float16 if torch.cuda.is_available() else torch.float32,
            device_map="auto" if torch.cuda.is_available() else None,
            low_cpu_mem_usage=True,
            trust_remote_code=True,
        )
        self.model.eval()

    def unload(self):
        self.model = None
        self.tok = None

    def enhance(self, user_idea: str) -> str:
        assert self.model is not None, "LLM not loaded — call via MANAGER.acquire('llm')"
        # Qwen3 chat template; fallback to plain concat if missing
        try:
            messages = [
                {"role": "system", "content": self.system_prompt},
                {"role": "user", "content": user_idea},
            ]
            text = self.tok.apply_chat_template(messages, tokenize=False, add_generation_prompt=True)
        except Exception:
            text = f"{self.system_prompt}\nUser: {user_idea}\nEnhanced prompt:"
        inputs = self.tok([text], return_tensors="pt").to(self.model.device)
        with torch.inference_mode():
            out = self.model.generate(
                **inputs,
                max_new_tokens=self.max_new_tokens,
                temperature=self.temperature,
                do_sample=True,
                pad_token_id=self.tok.eos_token_id,
            )
        gen = self.tok.batch_decode(out[:, inputs.input_ids.shape[1]:], skip_special_tokens=True)[0]
        return gen.strip().split("\n")[0][:500]
