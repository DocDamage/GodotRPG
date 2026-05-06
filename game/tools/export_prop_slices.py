from __future__ import annotations

import json
from pathlib import Path

from PIL import Image


PROJECT_ROOT = Path(__file__).resolve().parents[1]


def resolve_resource_path(path: str) -> Path:
    if path.startswith("res://"):
        return PROJECT_ROOT / path.removeprefix("res://")
    return Path(path)


def export_slice(entry: dict) -> None:
    source_path = resolve_resource_path(entry["source_path"])
    output_path = resolve_resource_path(entry["output_path"])
    rect = entry["rect"]
    box = (
        int(rect["x"]),
        int(rect["y"]),
        int(rect["x"]) + int(rect["w"]),
        int(rect["y"]) + int(rect["h"]),
    )
    image = Image.open(source_path).convert("RGBA")
    crop = image.crop(box)
    if entry.get("trim", True):
        bbox = crop.getbbox()
        if bbox:
            crop = crop.crop(bbox)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    crop.save(output_path)


def main() -> None:
    manifest_path = PROJECT_ROOT / "data" / "tilesets" / "apothecary_prop_slices.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    for entry in manifest.get("slices", []):
        export_slice(entry)


if __name__ == "__main__":
    main()
