from __future__ import annotations

import argparse
import html
import json
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[1]


def resolve_path(path: str) -> Path:
    if path.startswith("res://"):
        return PROJECT_ROOT / path.removeprefix("res://")
    return Path(path)


def relative_uri(from_file: Path, target: Path) -> str:
    return target.resolve().relative_to(from_file.parent.resolve()).as_posix()


def build_contact_sheet(manifest_path: Path, output_path: Path) -> None:
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    cards: list[str] = []
    for sprite in manifest.get("sprites", []):
        sprite_path = resolve_path(sprite["output_path"])
        bounds = sprite["bounds"]
        cards.append(
            f"""
            <article class="sprite-card">
              <div class="preview"><img src="{html.escape(relative_uri(output_path, sprite_path))}" alt="{html.escape(sprite['id'])}"></div>
              <h2>{html.escape(sprite['id'])}</h2>
              <p>{bounds['w']}x{bounds['h']} at {bounds['x']},{bounds['y']}</p>
              <code>{html.escape(sprite_path.name)}</code>
            </article>
            """
        )
    document = f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Sprite Contact Sheet - {html.escape(manifest_path.parent.name)}</title>
  <style>
    body {{
      margin: 24px;
      background: #15171c;
      color: #e6e2d8;
      font-family: Arial, sans-serif;
    }}
    h1 {{ font-size: 22px; }}
    .grid {{
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
      gap: 16px;
    }}
    .sprite-card {{
      border: 1px solid #3b414d;
      background: #20242c;
      padding: 10px;
      border-radius: 6px;
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
  </style>
</head>
<body>
  <h1>{html.escape(manifest_path.parent.name)} - {len(manifest.get("sprites", []))} Sprites</h1>
  <p>Source: {html.escape(str(manifest.get("source_path", "")))}</p>
  <section class="grid">
    {''.join(cards)}
  </section>
</body>
</html>
"""
    output_path.write_text(document, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Build an HTML contact sheet for extracted sprite candidates.")
    parser.add_argument("--manifest", required=True)
    parser.add_argument("--output", default="")
    args = parser.parse_args()
    manifest_path = resolve_path(args.manifest)
    output_path = resolve_path(args.output) if args.output else manifest_path.parent / "contact_sheet.html"
    build_contact_sheet(manifest_path, output_path)
    print(f"Wrote {output_path}")


if __name__ == "__main__":
    main()
