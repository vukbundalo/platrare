#!/usr/bin/env python3
"""Create ARB files without network: en-based locales + sr_Cyrl from sr_Latn."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EN = ROOT / "lib/l10n/app_en.arb"
SR_LATN = ROOT / "lib/l10n/app_sr_Latn.arb"
OUT = ROOT / "lib/l10n"

# Major languages: start from English (translate later with generate_l10n_arbs.py).
FROM_EN = [
    "es",
    "fr",
    "de",
    "pt_BR",
    "it",
    "ru",
    "pl",
    "uk",
    "nl",
    "tr",
    "sv",
    "hi",
    "ar",
    "ja",
    "ko",
    "zh_Hans",
]

# Regional: Serbian Latin is the closest existing full translation for HR/BS UI.
FROM_SR_LATN = ["hr", "bs"]


def serbian_latin_to_cyrillic(text: str) -> str:
    triples = [
        ("DŽ", "Џ"),
        ("Dž", "Џ"),
        ("dž", "џ"),
        ("Lj", "Љ"),
        ("LJ", "Љ"),
        ("lj", "љ"),
        ("Nj", "Њ"),
        ("NJ", "Њ"),
        ("nj", "њ"),
    ]
    s = text
    for a, b in triples:
        s = s.replace(a, b)
    upper_map = {
        "A": "А",
        "B": "Б",
        "V": "В",
        "G": "Г",
        "D": "Д",
        "Đ": "Ђ",
        "E": "Е",
        "Ž": "Ж",
        "Z": "З",
        "I": "И",
        "J": "Ј",
        "K": "К",
        "L": "Л",
        "M": "М",
        "N": "Н",
        "O": "О",
        "P": "П",
        "R": "Р",
        "S": "С",
        "T": "Т",
        "Ć": "Ћ",
        "U": "У",
        "F": "Ф",
        "H": "Х",
        "C": "Ц",
        "Č": "Ч",
        "Š": "Ш",
    }
    lower_map = {k.lower(): v.lower() for k, v in upper_map.items()}
    cmap = {**upper_map, **lower_map}
    return "".join(cmap.get(ch, ch) for ch in s)


def transliterate_arb(data: dict) -> dict:
    """Cyrillic for plain strings; keep Latin for any value with `{` (ICU / placeholders)."""
    out: dict = {}
    for k, v in data.items():
        if k == "@@locale":
            out[k] = "sr_Cyrl"
        elif k.startswith("@") or not isinstance(v, str):
            out[k] = v
        elif "{" in v:
            out[k] = v
        else:
            out[k] = serbian_latin_to_cyrillic(v)
    return out


def main() -> None:
    with EN.open(encoding="utf-8") as f:
        en = json.load(f)
    with SR_LATN.open(encoding="utf-8") as f:
        sr_latn = json.load(f)

    for loc in FROM_EN:
        data = {**en, "@@locale": loc}
        (OUT / f"app_{loc}.arb").write_text(
            json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
        )
        print(f"app_{loc}.arb (from en)")

    for loc in FROM_SR_LATN:
        data = {**sr_latn, "@@locale": loc}
        (OUT / f"app_{loc}.arb").write_text(
            json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
        )
        print(f"app_{loc}.arb (from sr_Latn)")

    cyrl = transliterate_arb(sr_latn)
    (OUT / "app_sr_Cyrl.arb").write_text(
        json.dumps(cyrl, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print("app_sr_Cyrl.arb (transliterated)")

    # Flutter requires base locales for country/script-specific ARBs.
    pt_br = json.loads((OUT / "app_pt_BR.arb").read_text(encoding="utf-8"))
    pt_br["@@locale"] = "pt"
    (OUT / "app_pt.arb").write_text(
        json.dumps(pt_br, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print("app_pt.arb (fallback for pt_BR)")
    zh_hans = json.loads((OUT / "app_zh_Hans.arb").read_text(encoding="utf-8"))
    zh_hans["@@locale"] = "zh"
    (OUT / "app_zh.arb").write_text(
        json.dumps(zh_hans, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    print("app_zh.arb (fallback for zh_Hans)")


if __name__ == "__main__":
    main()
