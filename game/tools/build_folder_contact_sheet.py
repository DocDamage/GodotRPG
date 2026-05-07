from __future__ import annotations

import argparse
import html
import os
from pathlib import Path

from PIL import Image


PROJECT_ROOT = Path(__file__).resolve().parents[1]
WORKSPACE_ROOT = PROJECT_ROOT.parent


def resolve_path(path: str) -> Path:
    if path.startswith("res://"):
        return PROJECT_ROOT / path.removeprefix("res://")
    return Path(path)


def relative_uri(from_file: Path, target: Path) -> str:
    return Path(os.path.relpath(target.resolve(), from_file.parent.resolve())).as_posix()


def image_size(path: Path) -> tuple[int, int]:
    with Image.open(path) as image:
        return image.width, image.height


def collect_pngs(source_dir: Path, max_files: int, max_dimension: int) -> list[Path]:
    pngs: list[Path] = []
    for path in sorted(source_dir.rglob("*.png"), key=lambda item: item.relative_to(source_dir).as_posix().lower()):
        if max_dimension > 0:
            width, height = image_size(path)
            if max(width, height) > max_dimension:
                continue
        pngs.append(path)
        if max_files > 0 and len(pngs) >= max_files:
            break
    return pngs


def build_contact_sheet(source_dir: Path, output_path: Path, title: str, max_files: int, max_dimension: int) -> None:
    source_dir = source_dir.resolve()
    output_path = output_path.resolve()
    output_path.parent.mkdir(parents=True, exist_ok=True)

    cards: list[str] = []
    for index, sprite_path in enumerate(collect_pngs(source_dir, max_files, max_dimension), start=1):
        width, height = image_size(sprite_path)
        sprite_id = f"sprite_{index:04d}"
        rel_source = sprite_path.relative_to(source_dir).as_posix()
        cards.append(
            f"""
            <article class="sprite-card" data-source-path="{html.escape(str(sprite_path))}">
              <div class="preview"><img src="{html.escape(relative_uri(output_path, sprite_path))}" alt="{html.escape(sprite_id)}"></div>
              <h2>{html.escape(sprite_id)}</h2>
              <p>{width}x{height}</p>
              <code>{html.escape(rel_source)}</code>
            </article>
            """
        )

    dimension_note = "all dimensions" if max_dimension <= 0 else f"max dimension <= {max_dimension}px"
    document = f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Cut Sprite Contact Sheet - {html.escape(title)}</title>
  <style>
    body {{
      margin: 24px;
      background: #15171c;
      color: #e6e2d8;
      font-family: Arial, sans-serif;
    }}
    h1 {{ font-size: 22px; margin-bottom: 4px; }}
    .meta {{ color: #b9c0cd; margin: 0 0 18px; }}
    .grid {{
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(172px, 1fr));
      gap: 16px;
    }}
    .sprite-card {{
      border: 1px solid #3b414d;
      background: #20242c;
      padding: 10px;
      border-radius: 6px;
      min-width: 0;
    }}
    .preview {{
      height: 144px;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: #2a2f39;
      background-image:
        linear-gradient(45deg, #39414f 25%, transparent 25%),
        linear-gradient(-45deg, #39414f 25%, transparent 25%),
        linear-gradient(45deg, transparent 75%, #39414f 75%),
        linear-gradient(-45deg, transparent 75%, #39414f 75%);
      background-size: 16px 16px;
      background-position: 0 0, 0 8px, 8px -8px, -8px 0;
    }}
    img {{
      max-width: 128px;
      max-height: 128px;
      image-rendering: pixelated;
    }}
    h2 {{ font-size: 14px; margin: 10px 0 4px; }}
    p, code {{ font-size: 12px; color: #b9c0cd; }}
    code {{
      display: block;
      overflow-wrap: anywhere;
    }}
  </style>
</head>
<body>
  <h1>Cut Sprite Contact Sheet - {html.escape(title)}</h1>
  <p class="meta">{len(cards)} PNGs, {html.escape(dimension_note)}</p>
  <p class="meta">Source: {html.escape(str(source_dir))}</p>
  <section class="grid">
    {''.join(cards)}
  </section>
</body>
</html>
"""
    output_path.write_text(document, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Build an HTML contact sheet from an already-cut sprite folder.")
    parser.add_argument("--source-dir", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--title", default="")
    parser.add_argument("--max-files", type=int, default=0, help="Maximum PNGs to include. 0 includes all matching files.")
    parser.add_argument("--max-dimension", type=int, default=256, help="Skip PNGs larger than this max width/height. 0 disables filtering.")
    args = parser.parse_args()

    source_dir = resolve_path(args.source_dir)
    output_path = resolve_path(args.output)
    title = args.title or source_dir.name
    build_contact_sheet(source_dir, output_path, title, args.max_files, args.max_dimension)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
