#!/usr/bin/env python3
"""Draws the my_budget launcher icon and writes it out for every platform.

The artwork is described once, as signed distance fields in a resolution
independent coordinate space, then rasterised with analytic anti-aliasing.
Every output size is drawn at its native resolution rather than downscaled
from a single master, so the small densities stay crisp.

Standard library only -- no image toolchain required.

    python3 tool/generate_app_icons.py
"""

from __future__ import annotations

import math
import os
import struct
import zlib

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# --- Palette -----------------------------------------------------------------
# Built around the app's Material seed colour (AppTheme.seed, 0xFF2E7D63).

BG_TOP = (0x3E, 0x9B, 0x7D)
BG_BOTTOM = (0x1E, 0x5B, 0x48)
BODY = (0xFF, 0xFF, 0xFF)
CARD = (0x9F, 0xD8, 0xC3)
POCKET = (0xC3, 0xE3, 0xD6)
CLASP = (0x2E, 0x7D, 0x63)
SHADOW = (0x0C, 0x2E, 0x24)


# --- Signed distance fields --------------------------------------------------


class Shape:
    """A signed distance field plus a loose bounding box used to skip pixels."""

    def __init__(self, sdf, bbox):
        self.sdf = sdf
        self.bbox = bbox  # (x0, y0, x1, y1)

    def dilate(self, amount):
        f = self.sdf
        x0, y0, x1, y1 = self.bbox
        return Shape(
            lambda x, y: f(x, y) - amount,
            (x0 - amount, y0 - amount, x1 + amount, y1 + amount),
        )

    def translate(self, dx, dy):
        f = self.sdf
        x0, y0, x1, y1 = self.bbox
        return Shape(
            lambda x, y: f(x - dx, y - dy),
            (x0 + dx, y0 + dy, x1 + dx, y1 + dy),
        )

    def intersect(self, other):
        a, b = self.sdf, other.sdf
        ax0, ay0, ax1, ay1 = self.bbox
        bx0, by0, bx1, by1 = other.bbox
        return Shape(
            lambda x, y: max(a(x, y), b(x, y)),
            (max(ax0, bx0), max(ay0, by0), min(ax1, bx1), min(ay1, by1)),
        )

    def union(self, other):
        a, b = self.sdf, other.sdf
        ax0, ay0, ax1, ay1 = self.bbox
        bx0, by0, bx1, by1 = other.bbox
        return Shape(
            lambda x, y: min(a(x, y), b(x, y)),
            (min(ax0, bx0), min(ay0, by0), max(ax1, bx1), max(ay1, by1)),
        )

    def placed(self, ox, oy, scale):
        """Maps local coordinates into the canvas: canvas = origin + scale * local."""
        f = self.sdf
        x0, y0, x1, y1 = self.bbox
        return Shape(
            lambda x, y: scale * f((x - ox) / scale, (y - oy) / scale),
            (
                ox + scale * x0,
                oy + scale * y0,
                ox + scale * x1,
                oy + scale * y1,
            ),
        )


def rounded_rect(cx, cy, half_w, half_h, radius):
    ix, iy = half_w - radius, half_h - radius

    def sdf(x, y):
        dx = abs(x - cx) - ix
        dy = abs(y - cy) - iy
        return (
            math.hypot(dx if dx > 0.0 else 0.0, dy if dy > 0.0 else 0.0)
            + min(max(dx, dy), 0.0)
            - radius
        )

    return Shape(sdf, (cx - half_w, cy - half_h, cx + half_w, cy + half_h))


def circle(cx, cy, radius):
    return Shape(
        lambda x, y: math.hypot(x - cx, y - cy) - radius,
        (cx - radius, cy - radius, cx + radius, cy + radius),
    )


def square():
    return Shape(lambda x, y: -1.0, (0.0, 0.0, 1.0, 1.0))


# --- Rasteriser --------------------------------------------------------------


class Layer:
    def __init__(self, shape, color, alpha=1.0, blur=0.0, erase=False):
        self.shape = shape
        self.color = color  # (r, g, b) or a callable (x, y) -> (r, g, b)
        self.alpha = alpha
        self.blur = blur
        self.erase = erase


def render(size, layers):
    """Composites the layers into a straight-alpha RGBA byte buffer."""
    # Premultiplied float accumulators, un-premultiplied on the way out.
    px_r = [0.0] * (size * size)
    px_g = [0.0] * (size * size)
    px_b = [0.0] * (size * size)
    px_a = [0.0] * (size * size)
    inv = 1.0 / size

    for layer in layers:
        x0, y0, x1, y1 = layer.shape.bbox
        pad = layer.blur + 2.0 * inv
        col0 = max(0, int((x0 - pad) * size))
        row0 = max(0, int((y0 - pad) * size))
        col1 = min(size, int(math.ceil((x1 + pad) * size)))
        row1 = min(size, int(math.ceil((y1 + pad) * size)))
        if col0 >= col1 or row0 >= row1:
            continue

        sdf = layer.shape.sdf
        alpha = layer.alpha
        erase = layer.erase
        falloff = 1.0 / max(layer.blur, inv)
        flat = None if callable(layer.color) else layer.color
        tint = layer.color if flat is None else None

        for row in range(row0, row1):
            y = (row + 0.5) * inv
            base = row * size
            for col in range(col0, col1):
                d = sdf((col + 0.5) * inv, y)
                cov = 0.5 - d * falloff
                if cov <= 0.0:
                    continue
                if cov > 1.0:
                    cov = 1.0
                i = base + col

                if erase:
                    keep = 1.0 - cov
                    px_r[i] *= keep
                    px_g[i] *= keep
                    px_b[i] *= keep
                    px_a[i] *= keep
                    continue

                sa = cov * alpha
                r, g, b = flat if flat is not None else tint((col + 0.5) * inv, y)
                keep = 1.0 - sa
                px_r[i] = r * sa + px_r[i] * keep
                px_g[i] = g * sa + px_g[i] * keep
                px_b[i] = b * sa + px_b[i] * keep
                px_a[i] = sa + px_a[i] * keep

    out = bytearray(size * size * 4)
    for i in range(size * size):
        a = px_a[i]
        j = i * 4
        if a <= 0.0:
            continue
        scale = 1.0 / a
        out[j] = min(255, int(px_r[i] * scale + 0.5))
        out[j + 1] = min(255, int(px_g[i] * scale + 0.5))
        out[j + 2] = min(255, int(px_b[i] * scale + 0.5))
        out[j + 3] = min(255, int(a * 255.0 + 0.5))
    return out


# --- PNG / ICO encoding ------------------------------------------------------


def _chunk(tag, data):
    return (
        struct.pack(">I", len(data))
        + tag
        + data
        + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)
    )


def encode_png(size, rgba, opaque=False):
    if opaque:
        channels, color_type = 3, 2
        pixels = bytearray(size * size * 3)
        for i in range(size * size):
            pixels[i * 3 : i * 3 + 3] = rgba[i * 4 : i * 4 + 3]
    else:
        channels, color_type = 4, 6
        pixels = rgba

    stride = size * channels
    raw = bytearray()
    for row in range(size):
        raw.append(0)  # filter type: none
        raw += pixels[row * stride : (row + 1) * stride]

    return (
        b"\x89PNG\r\n\x1a\n"
        + _chunk(b"IHDR", struct.pack(">IIBBBBB", size, size, 8, color_type, 0, 0, 0))
        + _chunk(b"IDAT", zlib.compress(bytes(raw), 9))
        + _chunk(b"IEND", b"")
    )


def write(path, data):
    full = os.path.join(ROOT, path)
    os.makedirs(os.path.dirname(full), exist_ok=True)
    with open(full, "wb") as handle:
        handle.write(data)
    print(f"  {path}")


def write_ico(path, pngs):
    """PNG-compressed ICO entries, understood by Windows Vista and newer."""
    header = struct.pack("<HHH", 0, 1, len(pngs))
    offset = len(header) + 16 * len(pngs)
    entries, blobs = bytearray(), bytearray()
    for size, blob in pngs:
        entries += struct.pack(
            "<BBBBHHII",
            0 if size >= 256 else size,
            0 if size >= 256 else size,
            0,
            0,
            1,
            32,
            len(blob),
            offset,
        )
        blobs += blob
        offset += len(blob)
    write(path, header + bytes(entries) + bytes(blobs))


# --- The mark ----------------------------------------------------------------
#
# A wallet with a card slipped in behind it. Drawn in a local space where the
# whole mark spans roughly [-0.5, 0.5] on both axes, y pointing down.

_CARD = rounded_rect(0.020, -0.295, 0.315, 0.145, 0.060)
_BODY = rounded_rect(0.000, 0.065, 0.440, 0.315, 0.130)
_POCKET = rounded_rect(0.300, 0.070, 0.220, 0.135, 0.085).intersect(_BODY)
_CLASP = circle(0.285, 0.070, 0.080)

# Bounding box of the whole mark, used to keep it optically centred.
_MARK_CENTER_Y = (-0.440 + 0.380) / 2.0


def mark_layers(origin_x, origin_y, scale):
    """The full-colour wallet, centred on (origin_x, origin_y)."""
    place = lambda shape: shape.placed(
        origin_x, origin_y - _MARK_CENTER_Y * scale, scale
    )
    return [
        Layer(
            place(_CARD.union(_BODY).translate(0.0, 0.055)),
            SHADOW,
            alpha=0.22,
            blur=0.075 * scale,
        ),
        Layer(place(_CARD), CARD),
        Layer(place(_BODY), BODY),
        Layer(place(_POCKET), POCKET),
        Layer(place(_CLASP), CLASP),
    ]


def monochrome_layers(origin_x, origin_y, scale):
    """A single-colour silhouette for Android 13+ themed icons."""
    place = lambda shape: shape.placed(
        origin_x, origin_y - _MARK_CENTER_Y * scale, scale
    )
    return [
        Layer(place(_CARD), BODY),
        # A gap so the card stays legible once everything is one colour.
        Layer(place(_BODY.dilate(0.030)), BODY, erase=True),
        Layer(place(_BODY), BODY),
        Layer(place(_CLASP), BODY, erase=True),
    ]


def gradient(x, y):
    t = (x + y) * 0.5
    return (
        BG_TOP[0] + (BG_BOTTOM[0] - BG_TOP[0]) * t,
        BG_TOP[1] + (BG_BOTTOM[1] - BG_TOP[1]) * t,
        BG_TOP[2] + (BG_BOTTOM[2] - BG_TOP[2]) * t,
    )


# --- Compositions ------------------------------------------------------------

MARK_SCALE = 0.70  # mark width as a fraction of a full-bleed canvas


def rounded_tile(mark_scale=MARK_SCALE, corner=0.225, inset=0.0):
    """A rounded square with the mark on it -- Android legacy, web, Windows."""
    tile = rounded_rect(0.5, 0.5, 0.5 - inset, 0.5 - inset, corner * (1.0 - 2 * inset))
    return [Layer(tile, gradient)] + mark_layers(0.5, 0.5, mark_scale)


def square_tile(mark_scale=MARK_SCALE):
    """A hard-edged square -- iOS masks the corners itself."""
    return [Layer(square(), gradient)] + mark_layers(0.5, 0.5, mark_scale)


def macos_tile():
    """Big Sur proportions: an 824pt rounded square inside a 1024pt canvas."""
    inset = 100.0 / 1024.0
    return rounded_tile(mark_scale=0.57, corner=185.4 / 824.0, inset=inset)


def adaptive_foreground():
    """Android adaptive foreground: the mark alone, well inside the safe zone."""
    return mark_layers(0.5, 0.5, 0.50)


def adaptive_monochrome():
    return monochrome_layers(0.5, 0.5, 0.50)


def maskable():
    """PWA maskable icon: content stays within the guaranteed centre circle."""
    return [Layer(square(), gradient)] + mark_layers(0.5, 0.5, 0.55)


def draw(size, layers, opaque=False):
    return encode_png(size, render(size, layers), opaque=opaque)


# --- Outputs -----------------------------------------------------------------

ANDROID_DENSITIES = [
    ("mdpi", 1),
    ("hdpi", 1.5),
    ("xhdpi", 2),
    ("xxhdpi", 3),
    ("xxxhdpi", 4),
]

IOS_ICONS = [
    ("Icon-App-20x20@1x.png", 20),
    ("Icon-App-20x20@2x.png", 40),
    ("Icon-App-20x20@3x.png", 60),
    ("Icon-App-29x29@1x.png", 29),
    ("Icon-App-29x29@2x.png", 58),
    ("Icon-App-29x29@3x.png", 87),
    ("Icon-App-40x40@1x.png", 40),
    ("Icon-App-40x40@2x.png", 80),
    ("Icon-App-40x40@3x.png", 120),
    ("Icon-App-60x60@2x.png", 120),
    ("Icon-App-60x60@3x.png", 180),
    ("Icon-App-76x76@1x.png", 76),
    ("Icon-App-76x76@2x.png", 152),
    ("Icon-App-83.5x83.5@2x.png", 167),
    ("Icon-App-1024x1024@1x.png", 1024),
]

MACOS_SIZES = [16, 32, 64, 128, 256, 512, 1024]
ICO_SIZES = [16, 24, 32, 48, 64, 128, 256]


def main():
    res = "android/app/src/main/res"

    print("Android")
    for name, factor in ANDROID_DENSITIES:
        legacy = int(48 * factor)
        # Small densities need slightly more presence to survive the downscale.
        png = draw(legacy, rounded_tile(mark_scale=0.72 if legacy <= 72 else MARK_SCALE))
        write(f"{res}/mipmap-{name}/ic_launcher.png", png)
        write(
            f"{res}/mipmap-{name}/ic_launcher_round.png",
            draw(legacy, [Layer(circle(0.5, 0.5, 0.5), gradient)]
                 + mark_layers(0.5, 0.5, 0.62)),
        )
        adaptive = int(108 * factor)
        write(
            f"{res}/mipmap-{name}/ic_launcher_foreground.png",
            draw(adaptive, adaptive_foreground()),
        )
        write(
            f"{res}/mipmap-{name}/ic_launcher_monochrome.png",
            draw(adaptive, adaptive_monochrome()),
        )

    print("iOS")
    for name, size in IOS_ICONS:
        # The App Store rejects icons with an alpha channel.
        write(
            f"ios/Runner/Assets.xcassets/AppIcon.appiconset/{name}",
            draw(size, square_tile(mark_scale=0.74 if size <= 40 else MARK_SCALE),
                 opaque=True),
        )

    print("macOS")
    for size in MACOS_SIZES:
        write(
            f"macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_{size}.png",
            draw(size, macos_tile()),
        )

    print("Web")
    write("web/favicon.png", draw(16, rounded_tile(mark_scale=0.80, corner=0.18)))
    for size in (192, 512):
        write(f"web/icons/Icon-{size}.png", draw(size, rounded_tile()))
        write(f"web/icons/Icon-maskable-{size}.png", draw(size, maskable()))

    print("Windows")
    write_ico(
        "windows/runner/resources/app_icon.ico",
        [
            (size, draw(size, rounded_tile(mark_scale=0.80 if size <= 32 else MARK_SCALE)))
            for size in ICO_SIZES
        ],
    )


if __name__ == "__main__":
    main()
