from __future__ import annotations

import argparse
import base64
import io
import json
import os
import sys
import urllib.error
import urllib.request
from pathlib import Path
from typing import Any

from PIL import Image


PROJECT_ROOT = Path(__file__).resolve().parents[1]
WORKSPACE_ROOT = PROJECT_ROOT.parent
DEFAULT_ENV_PATH = WORKSPACE_ROOT / ".secrets" / "pixellab.env"
DEFAULT_MANIFEST = PROJECT_ROOT / "data" / "generation" / "pixellab_first_slice_requests.json"


def resolve_path(path: str) -> Path:
    if path.startswith("res://"):
        return PROJECT_ROOT / path.removeprefix("res://")
    return Path(path)


def display_path(path: Path) -> str:
    try:
        return "res://" + str(path.resolve().relative_to(PROJECT_ROOT.resolve())).replace("\\", "/")
    except ValueError:
        return str(path.resolve()).replace("\\", "/")


def load_env_file(path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    if not path.exists():
        return values
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip().strip('"').strip("'")
    return values


def pixellab_key(env_path: Path) -> str:
    return os.environ.get("PIXELLAB_API_KEY", "") or load_env_file(env_path).get("PIXELLAB_API_KEY", "")


def base64_image(path: Path) -> dict[str, str]:
	encoded = base64.b64encode(path.read_bytes()).decode("ascii")
	return {
		"type": "base64",
		"base64": encoded,
		"format": "png",
	}


def base64_png_from_image(image: Image.Image) -> dict[str, str]:
	buffer = io.BytesIO()
	image.save(buffer, format="PNG")
	encoded = base64.b64encode(buffer.getvalue()).decode("ascii")
	return {
		"type": "base64",
		"base64": encoded,
		"format": "png",
	}


def image_dimensions(path: Path) -> tuple[int, int]:
	with Image.open(path) as image:
		return image.width, image.height


def collect_palette(paths: list[str], max_colors: int) -> list[tuple[int, int, int]]:
	colors: dict[tuple[int, int, int], int] = {}
	for raw_path in paths:
		path = resolve_path(raw_path)
		if not path.exists():
			continue
		with Image.open(path) as source:
			image = source.convert("RGBA")
			for red, green, blue, alpha in image.getdata():
				if alpha < 16:
					continue
				key = (red, green, blue)
				colors[key] = colors.get(key, 0) + 1
	if not colors:
		return []
	return [color for color, _count in sorted(colors.items(), key=lambda item: item[1], reverse=True)[:max_colors]]


def nearest_palette_color(color: tuple[int, int, int], palette: list[tuple[int, int, int]]) -> tuple[int, int, int]:
	if not palette:
		return color
	red, green, blue = color
	return min(palette, key=lambda item: (item[0] - red) ** 2 + (item[1] - green) ** 2 + (item[2] - blue) ** 2)


def trim_transparent_border(image: Image.Image) -> Image.Image:
	bounds = image.getbbox()
	if bounds == None:
		return image
	return image.crop(bounds)


def postprocess_image(raw_path: Path, processed_path: Path, request: dict[str, Any], manifest: dict[str, Any]) -> None:
	shared = manifest.get("shared", {})
	options = shared.get("postprocess", {})
	palette = collect_palette(list(shared.get("palette_reference_paths", [])), int(options.get("palette_colors", 32)))
	alpha_threshold = int(options.get("alpha_threshold", 16))
	with Image.open(raw_path) as source:
		image = source.convert("RGBA")
	output = Image.new("RGBA", image.size, (0, 0, 0, 0))
	source_pixels = image.load()
	output_pixels = output.load()
	for y in range(image.height):
		for x in range(image.width):
			red, green, blue, alpha = source_pixels[x, y]
			if alpha < alpha_threshold:
				output_pixels[x, y] = (0, 0, 0, 0)
			else:
				snapped = nearest_palette_color((red, green, blue), palette)
				output_pixels[x, y] = (snapped[0], snapped[1], snapped[2], alpha)
	if bool(options.get("trim_transparent_border", True)):
		output = trim_transparent_border(output)
	nearest_neighbor_scale = int(options.get("nearest_neighbor_scale", 1))
	if nearest_neighbor_scale > 1:
		output = output.resize((output.width * nearest_neighbor_scale, output.height * nearest_neighbor_scale), Image.Resampling.NEAREST)
	processed_path.parent.mkdir(parents=True, exist_ok=True)
	output.save(processed_path)


def first_existing_reference(paths: list[str]) -> Path | None:
	for raw_path in paths:
		path = resolve_path(raw_path)
		if path.exists():
			return path
	return None


def style_reference_canvas(paths: list[str], width: int, height: int) -> Image.Image | None:
	references = [resolve_path(raw_path) for raw_path in paths if resolve_path(raw_path).exists()]
	if not references:
		return None
	canvas = Image.new("RGBA", (width, height), (34, 36, 42, 255))
	cell_width = max(1, width // min(2, len(references)))
	cell_height = max(1, height // ((len(references) + 1) // 2 if len(references) > 1 else 1))
	for index, path in enumerate(references[:4]):
		with Image.open(path) as source:
			sprite = source.convert("RGBA")
		sprite.thumbnail((max(1, cell_width - 4), max(1, cell_height - 4)), Image.Resampling.NEAREST)
		cell_x = (index % 2) * cell_width if len(references) > 1 else 0
		cell_y = (index // 2) * cell_height if len(references) > 1 else 0
		x = cell_x + max(0, (cell_width - sprite.width) // 2)
		y = cell_y + max(0, (cell_height - sprite.height) // 2)
		canvas.alpha_composite(sprite, (x, y))
	return canvas


def prepared_init_image(path: Path, width: int, height: int) -> Image.Image:
	with Image.open(path) as source:
		image = source.convert("RGBA")
	image.thumbnail((width, height), Image.Resampling.LANCZOS)
	canvas = Image.new("RGBA", (width, height), (0, 0, 0, 0))
	x = (width - image.width) // 2
	y = (height - image.height) // 2
	canvas.alpha_composite(image, (x, y))
	return canvas


def merged_request(shared: dict[str, Any], request: dict[str, Any]) -> dict[str, Any]:
    merged = dict(shared)
    merged.update(request)
    merged["style_reference_paths"] = request.get("style_reference_paths", shared.get("style_reference_paths", []))
    merged["image_size"] = request.get("image_size", shared.get("image_size", {"width": 96, "height": 96}))
    return merged


def build_payload(request: dict[str, Any]) -> dict[str, Any]:
	image_size = request["image_size"]
	payload: dict[str, Any] = {
		"description": request["description"],
		"negative_description": request.get("negative_description", ""),
		"image_size": image_size,
        "text_guidance_scale": request.get("text_guidance_scale", 7.0),
        "style_strength": request.get("style_strength", 35.0),
        "outline": request.get("outline", "selective outline"),
        "shading": request.get("shading", "medium shading"),
        "detail": request.get("detail", "medium detail"),
        "view": request.get("view", "high top-down"),
        "direction": request.get("direction", None),
        "isometric": request.get("isometric", False),
        "oblique_projection": request.get("oblique_projection", False),
        "no_background": request.get("no_background", True),
        "coverage_percentage": request.get("coverage_percentage", 78),
        "seed": request.get("seed"),
	}
	style_canvas = None
	if bool(request.get("use_style_references", False)):
		style_canvas = style_reference_canvas(list(request.get("style_reference_paths", [])), int(image_size["width"]), int(image_size["height"]))
	if style_canvas != None:
		payload["style_image"] = base64_png_from_image(style_canvas)
	init_image_path = str(request.get("init_image_path", ""))
	if init_image_path:
		init_path = resolve_path(init_image_path)
		if init_path.exists():
			payload["init_image"] = base64_png_from_image(prepared_init_image(init_path, int(image_size["width"]), int(image_size["height"])))
			payload["init_image_strength"] = int(request.get("init_image_strength", 420))
	return {key: value for key, value in payload.items() if value is not None}


def decode_response_image(response: dict[str, Any], output_path: Path) -> None:
    image_data = response.get("image", {}).get("base64", "")
    if "," in image_data:
        image_data = image_data.split(",", 1)[1]
    if not image_data:
        raise ValueError("PixelLab response did not contain image.base64")
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_bytes(base64.b64decode(image_data))


def post_json(url: str, api_key: str, payload: dict[str, Any]) -> dict[str, Any]:
    body = json.dumps(payload).encode("utf-8")
    request = urllib.request.Request(
        url,
        data=body,
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
            "Accept": "application/json",
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(request, timeout=180) as response:
            return json.loads(response.read().decode("utf-8"))
    except urllib.error.HTTPError as error:
        details = error.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"PixelLab API returned HTTP {error.code}: {details}") from error


def generate(manifest_path: Path, env_path: Path, only: str, dry_run: bool) -> dict[str, Any]:
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    output_root = resolve_path(manifest["output_root"])
    processed_output_root = resolve_path(manifest.get("processed_output_root", str(output_root) + "_processed"))
    api_url = manifest.get("api_base", "https://api.pixellab.ai/v2").rstrip("/") + manifest.get("endpoint", "/create-image-bitforge")
    shared = manifest.get("shared", {})
    api_key = pixellab_key(env_path)
    if not dry_run and (not api_key or api_key == "replace_me"):
        raise RuntimeError("PIXELLAB_API_KEY is missing. Put it in .secrets/pixellab.env or the environment.")

    results: list[dict[str, Any]] = []
    for request in manifest.get("requests", []):
        if only and request.get("id") != only:
            continue
        merged = merged_request(shared, request)
        payload = build_payload(merged)
        output_path = output_root / request["output_name"]
        processed_output_path = processed_output_root / request["output_name"]
        result = {
            "id": request["id"],
            "output_path": str(output_path).replace("\\", "/"),
            "processed_output_path": str(processed_output_path).replace("\\", "/"),
            "payload_preview": {
                key: ("<base64 image omitted>" if key.endswith("image") else value)
                for key, value in payload.items()
            },
        }
        if not dry_run:
            response = post_json(api_url, api_key, payload)
            decode_response_image(response, output_path)
            postprocess_image(output_path, processed_output_path, merged, manifest)
            if output_path.exists():
                width, height = image_dimensions(output_path)
                result["width"] = width
                result["height"] = height
            if processed_output_path.exists():
                width, height = image_dimensions(processed_output_path)
                result["processed_width"] = width
                result["processed_height"] = height
            result["usage"] = response.get("usage")
        results.append(result)

    output_root.mkdir(parents=True, exist_ok=True)
    processed_output_root.mkdir(parents=True, exist_ok=True)
    review_manifest = {
        "source_manifest": display_path(manifest_path),
        "endpoint": api_url,
        "dry_run": dry_run,
        "outputs": results,
    }
    (output_root / "review_manifest.json").write_text(json.dumps(review_manifest, indent=2), encoding="utf-8")
    return review_manifest


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate style-locked PixelLab assets into Extracted Assets for review.")
    parser.add_argument("--manifest", default=str(DEFAULT_MANIFEST))
    parser.add_argument("--env", default=str(DEFAULT_ENV_PATH))
    parser.add_argument("--only", default="", help="Generate one request id.")
    parser.add_argument("--dry-run", action="store_true", help="Build payload/review manifest without calling PixelLab.")
    args = parser.parse_args()

    review_manifest = generate(resolve_path(args.manifest), Path(args.env), args.only, args.dry_run)
    print(json.dumps({
        "dry_run": review_manifest["dry_run"],
        "count": len(review_manifest["outputs"]),
        "outputs": [output["output_path"] for output in review_manifest["outputs"]],
    }, indent=2))


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        print(str(exc), file=sys.stderr)
        raise SystemExit(1)
