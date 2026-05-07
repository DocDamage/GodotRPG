from __future__ import annotations

import argparse
import json
from collections import deque
from pathlib import Path

from PIL import Image


PROJECT_ROOT = Path(__file__).resolve().parents[1]
WORKSPACE_ROOT = PROJECT_ROOT.parent


def resolve_resource_path(path: str) -> Path:
    if path.startswith("res://"):
        return PROJECT_ROOT / path.removeprefix("res://")
    return Path(path)


def display_path(path: Path) -> str:
    try:
        return "res://" + str(path.relative_to(PROJECT_ROOT)).replace("\\", "/")
    except ValueError:
        return str(path.resolve())


def alpha_segmentation(image: Image.Image, alpha_threshold_percent: int) -> bytearray:
    alpha_threshold = int((alpha_threshold_percent / 100.0) * 255)
    pixels = image.getdata()
    return bytearray(1 if pixel[3] > alpha_threshold else 0 for pixel in pixels)


def flood_fill(segmentation: bytearray, visited: bytearray, start_x: int, start_y: int, width: int, height: int) -> dict:
    queue: deque[tuple[int, int]] = deque([(start_x, start_y)])
    min_x = max_x = start_x
    min_y = max_y = start_y
    pixels: list[int] = []
    while queue:
        x, y = queue.pop()
        if x < 0 or y < 0 or x >= width or y >= height:
            continue
        index = y * width + x
        if visited[index] or not segmentation[index]:
            continue
        visited[index] = 1
        pixels.append(index)
        min_x = min(min_x, x)
        max_x = max(max_x, x)
        min_y = min(min_y, y)
        max_y = max(max_y, y)
        queue.append((x + 1, y))
        queue.append((x - 1, y))
        queue.append((x, y + 1))
        queue.append((x, y - 1))
    return {
        "x": min_x,
        "y": min_y,
        "w": max_x - min_x + 1,
        "h": max_y - min_y + 1,
        "pixels": pixels,
    }


def extract_shape(source: Image.Image, bounds: dict) -> Image.Image:
    output = Image.new("RGBA", (bounds["w"], bounds["h"]), (0, 0, 0, 0))
    source_pixels = source.load()
    output_pixels = output.load()
    source_width = source.width
    for index in bounds["pixels"]:
        source_x = index % source_width
        source_y = index // source_width
        output_pixels[source_x - bounds["x"], source_y - bounds["y"]] = source_pixels[source_x, source_y]
    return output


def extract_bounding_box(source: Image.Image, bounds: dict) -> Image.Image:
    return source.crop((bounds["x"], bounds["y"], bounds["x"] + bounds["w"], bounds["y"] + bounds["h"]))


def extract_sprites(source_path: Path, output_dir: Path, alpha_threshold: int, min_size: int, mode: str, max_sprites: int) -> dict:
    source = Image.open(source_path).convert("RGBA")
    segmentation = alpha_segmentation(source, alpha_threshold)
    visited = bytearray(source.width * source.height)
    components: list[dict] = []
    for y in range(source.height):
        for x in range(source.width):
            index = y * source.width + x
            if segmentation[index] and not visited[index]:
                bounds = flood_fill(segmentation, visited, x, y, source.width, source.height)
                if bounds["w"] >= min_size and bounds["h"] >= min_size:
                    components.append(bounds)
    components.sort(key=lambda item: (item["y"], item["x"]))
    if max_sprites > 0:
        components = components[:max_sprites]
    output_dir.mkdir(parents=True, exist_ok=True)
    sprites: list[dict] = []
    for index, bounds in enumerate(components, start=1):
        sprite = extract_shape(source, bounds) if mode == "shape" else extract_bounding_box(source, bounds)
        output_path = output_dir / f"sprite_{index:03d}.png"
        sprite.save(output_path)
        sprites.append({
            "id": f"sprite_{index:03d}",
            "output_path": display_path(output_path),
            "bounds": {
                "x": bounds["x"],
                "y": bounds["y"],
                "w": bounds["w"],
                "h": bounds["h"],
            },
            "pixel_count": len(bounds["pixels"]),
        })
    manifest = {
        "source_path": display_path(source_path),
        "alpha_threshold": alpha_threshold,
        "min_size": min_size,
        "mode": mode,
        "sprites": sprites,
    }
    (output_dir / "manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
    return manifest


def main() -> None:
    parser = argparse.ArgumentParser(description="Extract connected-component sprites from a transparent sprite sheet.")
    parser.add_argument("--source", required=True, help="Source image path, absolute/relative or res://.")
    parser.add_argument("--output-dir", required=True, help="Output directory, absolute/relative or res://.")
    parser.add_argument("--alpha-threshold", type=int, default=10, help="Alpha threshold percent, matching sprite_extractor.html.")
    parser.add_argument("--min-size", type=int, default=30, help="Minimum width and height to export.")
    parser.add_argument("--mode", choices=["shape", "bounding-box"], default="shape")
    parser.add_argument("--max-sprites", type=int, default=200)
    args = parser.parse_args()
    source_path = resolve_resource_path(args.source)
    output_dir = resolve_resource_path(args.output_dir)
    manifest = extract_sprites(source_path, output_dir, args.alpha_threshold, args.min_size, args.mode, args.max_sprites)
    print(f"Exported {len(manifest['sprites'])} sprites to {output_dir}")


if __name__ == "__main__":
    main()
