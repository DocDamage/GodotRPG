from __future__ import annotations

import argparse
import json
import shutil
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[1]


def resolve_path(path: str) -> Path:
    if path.startswith("res://"):
        return PROJECT_ROOT / path.removeprefix("res://")
    return Path(path)


def promote(manifest_path: Path) -> int:
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    count = 0
    for promotion in manifest.get("promotions", []):
        source_path = resolve_path(promotion["source_path"])
        output_path = resolve_path(promotion["output_path"])
        output_path.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source_path, output_path)
        count += 1
    return count


def main() -> None:
    parser = argparse.ArgumentParser(description="Promote selected extracted sprites into game runtime assets.")
    parser.add_argument("--manifest", default="res://data/tilesets/apothecary_promoted_props.json")
    args = parser.parse_args()
    manifest_path = resolve_path(args.manifest)
    count = promote(manifest_path)
    print(f"Promoted {count} sprites from {manifest_path}")


if __name__ == "__main__":
    main()
