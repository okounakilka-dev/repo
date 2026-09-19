"""Single-model VRAM guard. Only one stage loaded at a time — models take turns."""
import asyncio
import gc
import torch


class ModelManager:
    def __init__(self):
        self._lock = asyncio.Lock()
        self._loaded: str | None = None
        self._holders: dict[str, object] = {}

    def register(self, name: str, holder: object):
        self._holders[name] = holder

    @property
    def loaded(self):
        return self._loaded

    def _free_vram(self):
        gc.collect()
        if torch.cuda.is_available():
            torch.cuda.empty_cache()
            torch.cuda.synchronize()

    async def acquire(self, name: str):
        """Unload current, load requested. Serializes all heavy work."""
        async with self._lock:
            if self._loaded == name:
                return self._holders[name]
            # unload current
            if self._loaded and self._loaded in self._holders:
                try:
                    self._holders[self._loaded].unload()
                except Exception as e:
                    print(f"[manager] unload {self._loaded} failed: {e}")
                self._loaded = None
                self._free_vram()
            # load requested
            holder = self._holders[name]
            print(f"[manager] loading {name} ...")
            holder.load()
            self._loaded = name
            self._free_vram()
            vram = ""
            if torch.cuda.is_available():
                free, total = torch.cuda.mem_get_info()
                vram = f" VRAM free={free/1024**3:.2f}/{total/1024**3:.2f}GB"
            print(f"[manager] {name} loaded.{vram}")
            return holder

    def unload_all(self):
        for name, h in self._holders.items():
            try:
                h.unload()
            except Exception:
                pass
        self._loaded = None
        self._free_vram()


MANAGER = ModelManager()
