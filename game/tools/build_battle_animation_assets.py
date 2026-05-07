from __future__ import annotations

import json
from pathlib import Path
from typing import Callable

from PIL import Image, ImageEnhance, ImageFilter


ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIR = ROOT / "assets" / "generated" / "pixellab" / "first_slice"
CUT_SPRITES_ROOT = ROOT.parent / "Assets" / "Cut Sprites"
MONSTER_SMALL_DIR = CUT_SPRITES_ROOT / "Monster Mega Pack 1-100 by BattleInkMaps" / "Monster Mega Pack- Small Size"
OUT_DIR = ROOT / "assets" / "battle" / "animations"
DATA_PATH = ROOT / "data" / "battle" / "animation_sets.json"


def centered_canvas(source: Image.Image, size: tuple[int, int], offset: tuple[int, int] = (0, 0)) -> Image.Image:
    canvas = Image.new("RGBA", size, (0, 0, 0, 0))
    x = (size[0] - source.width) // 2 + offset[0]
    y = size[1] - source.height - 8 + offset[1]
    canvas.alpha_composite(source, (x, y))
    return canvas


def tint(source: Image.Image, color: tuple[int, int, int], amount: float) -> Image.Image:
    overlay = Image.new("RGBA", source.size, (*color, 0))
    alpha = source.getchannel("A").point(lambda p: int(p * amount))
    overlay.putalpha(alpha)
    return Image.alpha_composite(source, overlay)


def silhouette(source: Image.Image, color: tuple[int, int, int, int]) -> Image.Image:
    result = Image.new("RGBA", source.size, color)
    result.putalpha(source.getchannel("A"))
    return result


def make_frames(seed: Image.Image, canvas_size: tuple[int, int], direction: int) -> dict[str, list[Image.Image]]:
    base = seed.convert("RGBA")
    idle_offsets = [(0, 0), (0, -2), (0, 0), (0, 1)]
    attack_offsets = [(0, 0), (direction * 8, -2), (direction * 16, -3), (direction * 4, 0)]
    hurt_offsets = [(0, 0), (-direction * 4, 0), (direction * 3, -1), (0, 0)]
    cast_offsets = [(0, 0), (0, -1), (0, -2), (0, -1)]

    frames: dict[str, list[Image.Image]] = {
        "idle": [centered_canvas(base, canvas_size, offset) for offset in idle_offsets],
        "attack": [centered_canvas(base, canvas_size, offset) for offset in attack_offsets],
        "hurt": [centered_canvas(tint(base, (255, 72, 72), 0.42), canvas_size, offset) for offset in hurt_offsets],
        "cast": [],
        "ko": [],
        "defeated": [],
    }

    for index, offset in enumerate(cast_offsets):
        aura = silhouette(base.filter(ImageFilter.GaussianBlur(1.2)), (112, 210, 255, 120))
        aura_scale = 1.0 + 0.06 * index
        aura = aura.resize((max(1, int(aura.width * aura_scale)), max(1, int(aura.height * aura_scale))), Image.Resampling.NEAREST)
        frame = centered_canvas(aura, canvas_size, offset)
        frame.alpha_composite(centered_canvas(base, canvas_size, offset))
        frames["cast"].append(frame)

    faded = ImageEnhance.Brightness(base).enhance(0.55)
    frames["ko"] = [
        centered_canvas(base, canvas_size, (0, 0)),
        centered_canvas(tint(base, (120, 120, 150), 0.30), canvas_size, (-direction * 3, 5)),
        centered_canvas(tint(faded, (90, 90, 110), 0.40), canvas_size, (-direction * 6, 9)),
        centered_canvas(tint(faded, (70, 70, 90), 0.50), canvas_size, (-direction * 8, 12)),
    ]
    frames["defeated"] = [
        centered_canvas(tint(faded, (80, 80, 96), 0.35), canvas_size, (0, 6)),
        centered_canvas(tint(faded, (80, 80, 96), 0.45), canvas_size, (0, 10)),
        centered_canvas(tint(faded, (80, 80, 96), 0.55), canvas_size, (0, 12)),
        centered_canvas(tint(faded, (80, 80, 96), 0.65), canvas_size, (0, 12)),
    ]
    return frames


def create_sev_seed() -> Image.Image:
    image = Image.new("RGBA", (32, 48), (0, 0, 0, 0))
    for y in range(4, 44):
        for x in range(9, 23):
            if y < 14 and 11 <= x <= 20:
                image.putpixel((x, y), (194, 199, 209, 255))
            elif y < 32:
                image.putpixel((x, y), (71, 92, 138, 255))
            elif x < 15 or x > 17:
                image.putpixel((x, y), (31, 36, 51, 255))
    return image


def monster_seed(folder_id: str, frame_index: int = 0) -> Image.Image:
    path = MONSTER_SMALL_DIR / folder_id / f"{folder_id}_{frame_index}.png"
    if not path.exists():
        raise FileNotFoundError(path)
    return Image.open(path).convert("RGBA")


def write_set(set_id: str, seed: Image.Image, canvas_size: tuple[int, int], direction: int) -> dict:
    set_dir = OUT_DIR / set_id
    set_dir.mkdir(parents=True, exist_ok=True)
    frames = make_frames(seed, canvas_size, direction)
    states: dict[str, dict] = {}
    for state, state_frames in frames.items():
        paths: list[str] = []
        for index, frame in enumerate(state_frames, start=1):
            filename = f"{state}_{index:02d}.png"
            frame.save(set_dir / filename)
            paths.append(f"res://assets/battle/animations/{set_id}/{filename}")
        states[state] = {
            "fps": 6 if state == "idle" else 9,
            "loop": state in ["idle", "cast"],
            "frames": paths,
        }
    preview = render_preview(frames)
    preview.save(set_dir / "preview.png")
    return {"frame_size": list(canvas_size), "states": states}


def render_preview(frames: dict[str, list[Image.Image]]) -> Image.Image:
    labels = ["idle", "attack", "hurt", "cast", "ko", "defeated"]
    frame_w = max(frame.width for state in labels for frame in frames[state])
    frame_h = max(frame.height for state in labels for frame in frames[state])
    sheet = Image.new("RGBA", (frame_w * 4, frame_h * len(labels)), (24, 24, 28, 255))
    for row, state in enumerate(labels):
        for col, frame in enumerate(frames[state]):
            sheet.alpha_composite(frame, (col * frame_w, row * frame_h))
    return sheet


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    animation_sets = {
        "sev_placeholder": write_set("sev_placeholder", create_sev_seed(), (72, 80), 1),
        "clean_man_generated": write_set("clean_man_generated", Image.open(SOURCE_DIR / "clean_man_enemy.png"), (96, 120), -1),
        "bell_saint_generated": write_set("bell_saint_generated", Image.open(SOURCE_DIR / "bell_saint_boss.png"), (192, 180), -1),
        "plague_wretch": write_set("plague_wretch", monster_seed("027"), (112, 120), -1),
        "prayer_bound_corpse": write_set("prayer_bound_corpse", monster_seed("073"), (104, 120), -1),
        "rot_choir": write_set("rot_choir", monster_seed("033"), (104, 128), -1),
        "bell_touched": write_set("bell_touched", monster_seed("024"), (112, 112), -1),
        "slime_contradiction": write_set("slime_contradiction", monster_seed("052"), (96, 96), -1),
        "cave_bat": write_set("cave_bat", monster_seed("014"), (96, 96), -1),
    }
    DATA_PATH.parent.mkdir(parents=True, exist_ok=True)
    DATA_PATH.write_text(json.dumps(animation_sets, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
