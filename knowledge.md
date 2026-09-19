# knowledge.md — project background for Freebuff

Owner: okounakilka-dev. RTX 3050 6GB, Windows, PowerShell 5.1, Python 3.12, .NET 8.
Main work: VPet AI plugin (OpenAI-compatible chat + auto actions), C++ RPG, house/hotel CAD PNG+DXF generators, Blender avatar steps, local take-turns pipeline (LLM betters prompt, queues image, unloads/loads, direct text-to-video).
LLM history: Qwen (Qwen3-1.7B), not Llama. Image: 3 merged SD checkpoints (see `src/local-pipeline/merge_checkpoints.py`). Video: direct text-to-video.
Build: per-folder README. CI: C++ build + Python compile + junk check.
