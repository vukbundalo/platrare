#!/usr/bin/env python3
"""
Generate lib/l10n/app_<locale>.arb from app_en.arb.

- Most strings: Google Translate (deep_translator), with placeholder protection.
- ICU plural lines: language-specific templates (repeat units, file count, planned-tx bodies).
- Serbian Cyrillic: transliterate lib/l10n/app_sr_Latn.arb (Latin → Cyrillic).

  pip install deep-translator

Run from repo root: python3 tool/generate_l10n_arbs.py
"""
from __future__ import annotations

import json
import re
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EN_ARB = ROOT / "lib/l10n/app_en.arb"
SR_LATN_ARB = ROOT / "lib/l10n/app_sr_Latn.arb"
OUT_DIR = ROOT / "lib/l10n"

try:
    from deep_translator import GoogleTranslator
except ImportError:
    GoogleTranslator = None

# (arb_filename_stem_suffix, @@locale value, google_target_code or None for transliterate-only)
TARGETS: list[tuple[str, str, str | None]] = [
    ("es", "es", "es"),
    ("fr", "fr", "fr"),
    ("de", "de", "de"),
    ("pt_BR", "pt_BR", "pt"),
    ("it", "it", "it"),
    ("ru", "ru", "ru"),
    ("pl", "pl", "pl"),
    ("uk", "uk", "uk"),
    ("nl", "nl", "nl"),
    ("tr", "tr", "tr"),
    ("sv", "sv", "sv"),
    ("hi", "hi", "hi"),
    ("ar", "ar", "ar"),
    ("ja", "ja", "ja"),
    ("ko", "ko", "ko"),
    ("zh_Hans", "zh_Hans", "zh-CN"),
    ("hr", "hr", "hr"),
    ("bs", "bs", "bs"),
]

# --- ICU plural templates (from English structure) ---------------------------------

REPEAT_KEYS = ("repeatEveryDays", "repeatEveryWeeks", "repeatEveryMonths", "repeatEveryYears")

# (singular, plural) word after {count} in "other" clause
REPEAT_UNITS: dict[str, dict[str, tuple[str, str]]] = {
    "es": {
        "repeatEveryDays": ("día", "días"),
        "repeatEveryWeeks": ("semana", "semanas"),
        "repeatEveryMonths": ("mes", "meses"),
        "repeatEveryYears": ("año", "años"),
    },
    "fr": {
        "repeatEveryDays": ("jour", "jours"),
        "repeatEveryWeeks": ("semaine", "semaines"),
        "repeatEveryMonths": ("mois", "mois"),
        "repeatEveryYears": ("an", "ans"),
    },
    "de": {
        "repeatEveryDays": ("Tag", "Tage"),
        "repeatEveryWeeks": ("Woche", "Wochen"),
        "repeatEveryMonths": ("Monat", "Monate"),
        "repeatEveryYears": ("Jahr", "Jahre"),
    },
    "pt_BR": {
        "repeatEveryDays": ("dia", "dias"),
        "repeatEveryWeeks": ("semana", "semanas"),
        "repeatEveryMonths": ("mês", "meses"),
        "repeatEveryYears": ("ano", "anos"),
    },
    "it": {
        "repeatEveryDays": ("giorno", "giorni"),
        "repeatEveryWeeks": ("settimana", "settimane"),
        "repeatEveryMonths": ("mese", "mesi"),
        "repeatEveryYears": ("anno", "anni"),
    },
    "ru": {
        "repeatEveryDays": ("день", "дня"),
        "repeatEveryWeeks": ("неделя", "недели"),
        "repeatEveryMonths": ("месяц", "месяца"),
        "repeatEveryYears": ("год", "года"),
    },
    "pl": {
        "repeatEveryDays": ("dzień", "dni"),
        "repeatEveryWeeks": ("tydzień", "tygodnie"),
        "repeatEveryMonths": ("miesiąc", "miesiące"),
        "repeatEveryYears": ("rok", "lata"),
    },
    "uk": {
        "repeatEveryDays": ("день", "дні"),
        "repeatEveryWeeks": ("тиждень", "тижні"),
        "repeatEveryMonths": ("місяць", "місяці"),
        "repeatEveryYears": ("рік", "роки"),
    },
    "nl": {
        "repeatEveryDays": ("dag", "dagen"),
        "repeatEveryWeeks": ("week", "weken"),
        "repeatEveryMonths": ("maand", "maanden"),
        "repeatEveryYears": ("jaar", "jaar"),
    },
    "tr": {
        "repeatEveryDays": ("gün", "gün"),
        "repeatEveryWeeks": ("hafta", "hafta"),
        "repeatEveryMonths": ("ay", "ay"),
        "repeatEveryYears": ("yıl", "yıl"),
    },
    "sv": {
        "repeatEveryDays": ("dag", "dagar"),
        "repeatEveryWeeks": ("vecka", "veckor"),
        "repeatEveryMonths": ("månad", "månader"),
        "repeatEveryYears": ("år", "år"),
    },
    "hi": {
        "repeatEveryDays": ("दिन", "दिन"),
        "repeatEveryWeeks": ("सप्ताह", "सप्ताह"),
        "repeatEveryMonths": ("महीना", "महीने"),
        "repeatEveryYears": ("साल", "साल"),
    },
    "ar": {
        "repeatEveryDays": ("يوم", "أيام"),
        "repeatEveryWeeks": ("أسبوع", "أسابيع"),
        "repeatEveryMonths": ("شهر", "أشهر"),
        "repeatEveryYears": ("سنة", "سنوات"),
    },
    "ja": {
        "repeatEveryDays": ("日", "日"),
        "repeatEveryWeeks": ("週間", "週間"),
        "repeatEveryMonths": ("か月", "か月"),
        "repeatEveryYears": ("年", "年"),
    },
    "ko": {
        "repeatEveryDays": ("일", "일"),
        "repeatEveryWeeks": ("주", "주"),
        "repeatEveryMonths": ("개월", "개월"),
        "repeatEveryYears": ("년", "년"),
    },
    "zh_Hans": {
        "repeatEveryDays": ("天", "天"),
        "repeatEveryWeeks": ("周", "周"),
        "repeatEveryMonths": ("个月", "个月"),
        "repeatEveryYears": ("年", "年"),
    },
    "hr": {
        "repeatEveryDays": ("dan", "dana"),
        "repeatEveryWeeks": ("tjedan", "tjedna"),
        "repeatEveryMonths": ("mjesec", "mjeseci"),
        "repeatEveryYears": ("godina", "godine"),
    },
    "bs": {
        "repeatEveryDays": ("dan", "dana"),
        "repeatEveryWeeks": ("sedmicu", "sedmice"),
        "repeatEveryMonths": ("mjesec", "mjeseci"),
        "repeatEveryYears": ("godinu", "godine"),
    },
}


def repeat_plural(one: str, many: str) -> str:
    return f"{{count, plural, =1{{{one}}} other{{{{count}} {many}}}}}"

DETAIL_FILE: dict[str, str] = {
    "es": "{count, plural, =1{1 archivo} other{{count} archivos}}",
    "fr": "{count, plural, =1{1 fichier} other{{count} fichiers}}",
    "de": "{count, plural, =1{1 Datei} other{{count} Dateien}}",
    "pt_BR": "{count, plural, =1{1 ficheiro} other{{count} ficheiros}}",
    "it": "{count, plural, =1{1 file} other{{count} file}}",
    "ru": "{count, plural, =1{1 файл} other{{count} файла}}",
    "pl": "{count, plural, =1{1 plik} other{{count} pliki}}",
    "uk": "{count, plural, =1{1 файл} other{{count} файли}}",
    "nl": "{count, plural, =1{1 bestand} other{{count} bestanden}}",
    "tr": "{count, plural, =1{1 dosya} other{{count} dosya}}",
    "sv": "{count, plural, =1{1 fil} other{{count} filer}}",
    "hi": "{count, plural, =1{1 फ़ाइल} other{{count} फ़ाइलें}}",
    "ar": "{count, plural, =1{ملف واحد} other{{count} ملفات}}",
    "ja": "{count, plural, =1{1 ファイル} other{{count} ファイル}}",
    "ko": "{count, plural, =1{1개 파일} other{{count}개 파일}}",
    "zh_Hans": "{count, plural, =1{1 个文件} other{{count} 个文件}}",
    "hr": "{count, plural, =1{1 datoteka} other{{count} datoteka}}",
    "bs": "{count, plural, =1{1 datoteka} other{{count} datoteka}}",
}

ARCHIVE_PLANNED: dict[str, str] = {
    "es": "{count, plural, =1{1 transacción planificada hace referencia a esta cuenta.} other{{count} transacciones planificadas hacen referencia a esta cuenta.}} Elimínalas para mantener tu plan coherente con una cuenta archivada.",
    "fr": "{count, plural, =1{1 transaction planifiée référence ce compte.} other{{count} transactions planifiées référencent ce compte.}} Supprimez-les pour garder votre plan cohérent avec un compte archivé.",
    "de": "{count, plural, =1{1 geplante Transaktion verweist auf dieses Konto.} other{{count} geplante Transaktionen verweisen auf dieses Konto.}} Entfernen Sie sie, damit Ihr Plan mit einem archivierten Konto konsistent bleibt.",
    "pt_BR": "{count, plural, =1{1 transação planejada referencia esta conta.} other{{count} transações planejadas referenciam esta conta.}} Remova-as para manter seu plano consistente com uma conta arquivada.",
    "it": "{count, plural, =1{1 transazione pianificata fa riferimento a questo conto.} other{{count} transazioni pianificate fanno riferimento a questo conto.}} Rimuovile per mantenere il piano coerente con un conto archiviato.",
    "ru": "{count, plural, =1{1 запланированная операция ссылается на этот счёт.} other{{count} запланированных операций ссылаются на этот счёт.}} Удалите их, чтобы план соответствовал архивному счёту.",
    "pl": "{count, plural, =1{1 zaplanowana transakcja odnosi się do tego konta.} other{{count} zaplanowanych transakcji odnosi się do tego konta.}} Usuń je, aby plan był spójny z zarchiwizowanym kontem.",
    "uk": "{count, plural, =1{1 запланована транзакція посилається на цей рахунок.} other{{count} запланованих транзакцій посилаються на цей рахунок.}} Видаліть їх, щоб план узгоджувався з архівним рахунком.",
    "nl": "{count, plural, =1{1 geplande transactie verwijst naar deze rekening.} other{{count} geplande transacties verwijzen naar deze rekening.}} Verwijder ze om je plan consistent te houden met een gearchiveerde rekening.",
    "tr": "{count, plural, =1{1 planlanan işlem bu hesaba referans veriyor.} other{{count} planlanan işlem bu hesaba referans veriyor.}} Arşivlenmiş bir hesapla planınızın tutarlı kalması için bunları kaldırın.",
    "sv": "{count, plural, =1{1 planerad transaktion refererar till detta konto.} other{{count} planerade transaktioner refererar till detta konto.}} Ta bort dem för att hålla planen konsekvent med ett arkiverat konto.",
    "hi": "{count, plural, =1{1 नियोजित लेनदेन इस खाते को संदर्भित करता है।} other{{count} नियोजित लेनदेन इस खाते को संदर्भित करते हैं।}} संग्रहीत खाते के साथ अपनी योजना सुसंगत रखने के लिए उन्हें हटाएँ।",
    "ar": "{count, plural, =1{معاملة مخططة واحدة تشير إلى هذا الحساب.} other{{count} معاملات مخططة تشير إلى هذا الحساب.}} أزلها للحفاظ على تناسق خطتك مع حساب مؤرشف.",
    "ja": "{count, plural, =1{1 件の予定取引がこの口座を参照しています。} other{{count} 件の予定取引がこの口座を参照しています。}} アーカイブされた口座と計画の整合性を保つために削除してください。",
    "ko": "{count, plural, =1{예정 거래 1건이 이 계정을 참조합니다.} other{{count}건이 이 계정을 참조하는 예정 거래가 더 있습니다.}} 보관된 계정과 계획의 일관성을 유지하려면 삭제하세요.",
    "zh_Hans": "{count, plural, =1{1 条计划交易引用了此账户。} other{{count} 条计划交易引用了此账户。}} 请删除它们，以使计划与已归档账户保持一致。",
    "hr": "{count, plural, =1{1 planirana transakcija referencira ovaj račun.} other{{count} planiranih transakcija referencira ovaj račun.}} Uklonite ih kako bi plan bio usklađen s arhiviranim računom.",
    "bs": "{count, plural, =1{1 planirana transakcija referiše ovaj račun.} other{{count} planiranih transakcija referišu ovaj račun.}} Uklonite ih kako bi plan bio usklađen s arhiviranim računom.",
}

DELETE_PLANNED: dict[str, str] = {
    "es": "{count, plural, =1{1 transacción planificada referencia esta cuenta y también se eliminará.} other{{count} transacciones planificadas referencian esta cuenta y también se eliminarán.}}",
    "fr": "{count, plural, =1{1 transaction planifiée référence ce compte et sera également supprimée.} other{{count} transactions planifiées référencent ce compte et seront également supprimées.}}",
    "de": "{count, plural, =1{1 geplante Transaktion verweist auf dieses Konto und wird ebenfalls gelöscht.} other{{count} geplante Transaktionen verweisen auf dieses Konto und werden ebenfalls gelöscht.}}",
    "pt_BR": "{count, plural, =1{1 transação planejada referencia esta conta e também será excluída.} other{{count} transações planejadas referenciam esta conta e também serão excluídas.}}",
    "it": "{count, plural, =1{1 transazione pianificata fa riferimento a questo conto e verrà eliminata.} other{{count} transazioni pianificate fanno riferimento a questo conto e verranno eliminate.}}",
    "ru": "{count, plural, =1{1 запланированная операция ссылается на этот счёт и также будет удалена.} other{{count} запланированных операций ссылаются на этот счёт и также будут удалены.}}",
    "pl": "{count, plural, =1{1 zaplanowana transakcja odnosi się do tego konta i zostanie usunięta.} other{{count} zaplanowanych transakcji odnosi się do tego konta i zostaną usunięte.}}",
    "uk": "{count, plural, =1{1 запланована транзакція посилається на цей рахунок і також буде видалена.} other{{count} запланованих транзакцій посилаються на цей рахунок і також будуть видалені.}}",
    "nl": "{count, plural, =1{1 geplande transactie verwijst naar deze rekening en wordt ook verwijderd.} other{{count} geplande transacties verwijzen naar deze rekening en worden ook verwijderd.}}",
    "tr": "{count, plural, =1{1 planlanan işlem bu hesaba referans veriyor ve silinecek.} other{{count} planlanan işlem bu hesaba referans veriyor ve silinecek.}}",
    "sv": "{count, plural, =1{1 planerad transaktion refererar till detta konto och tas också bort.} other{{count} planerade transaktioner refererar till detta konto och tas också bort.}}",
    "hi": "{count, plural, =1{1 नियोजित लेनदेन इस खाते को संदर्भित करता है और हटा दिया जाएगा।} other{{count} नियोजित लेनदेन इस खाते को संदर्भित करते हैं और हटा दिए जाएँगे।}}",
    "ar": "{count, plural, =1{معاملة مخططة واحدة تشير إلى هذا الحساب وسيتم حذفها أيضًا.} other{{count} معاملات مخططة تشير إلى هذا الحساب وسيتم حذفها أيضًا.}}",
    "ja": "{count, plural, =1{1 件の予定取引がこの口座を参照しており、削除されます。} other{{count} 件の予定取引がこの口座を参照しており、削除されます。}}",
    "ko": "{count, plural, =1{예정 거래 1건이 이 계정을 참조하며 삭제됩니다.} other{{count}건의 예정 거래가 이 계정을 참조하며 삭제됩니다.}}",
    "zh_Hans": "{count, plural, =1{1 条计划交易引用了此账户，也将被删除。} other{{count} 条计划交易引用了此账户，也将被删除。}}",
    "hr": "{count, plural, =1{1 planirana transakcija referencira ovaj račun i bit će obrisana.} other{{count} planiranih transakcija referencira ovaj račun i bit će obrisane.}}",
    "bs": "{count, plural, =1{1 planirana transakcija referiše ovaj račun i biće obrisana.} other{{count} planiranih transakcija referišu ovaj račun i biće obrisane.}}",
}

_PLACEHOLDER = re.compile(r"(\{[a-zA-Z_][a-zA-Z0-9_]*\})")


def protect_placeholders(s: str) -> tuple[str, dict[str, str]]:
    tokens: dict[str, str] = {}
    i = 0

    def repl(m: re.Match[str]) -> str:
        nonlocal i
        key = f"⟦PH{i}⟧"
        tokens[key] = m.group(1)
        i += 1
        return key

    return _PLACEHOLDER.sub(repl, s), tokens


def restore_placeholders(s: str, tokens: dict[str, str]) -> str:
    for k, v in tokens.items():
        s = s.replace(k, v)
    return s


def translate_value(translator: GoogleTranslator | None, text: str, target: str) -> str:
    if not text.strip():
        return text
    if translator is None:
        return text
    protected, tokens = protect_placeholders(text)
    try:
        out = translator.translate(protected)
        time.sleep(0.04)
    except Exception:
        return text
    return restore_placeholders(out, tokens)


def build_plural_overrides(locale_key: str) -> dict[str, str]:
    out: dict[str, str] = {}
    units = REPEAT_UNITS.get(locale_key)
    if units:
        for rk in REPEAT_KEYS:
            one, many = units[rk]
            out[rk] = repeat_plural(one, many)
    if locale_key in DETAIL_FILE:
        out["detailFileCount"] = DETAIL_FILE[locale_key]
    if locale_key in ARCHIVE_PLANNED:
        out["archiveWithPlannedBody"] = ARCHIVE_PLANNED[locale_key]
    if locale_key in DELETE_PLANNED:
        out["deleteWithPlannedBody"] = DELETE_PLANNED[locale_key]
    return out


def serbian_latin_to_cyrillic(text: str) -> str:
    """Convert Serbian Latin text to Cyrillic (conservative digraph handling)."""
    # Multi-character mappings first (case-sensitive chunks)
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
    # Merge (Latin letters only)
    cmap = {**upper_map, **lower_map}
    out: list[str] = []
    for ch in s:
        out.append(cmap.get(ch, ch))
    return "".join(out)


def transliterate_arb(data: dict) -> dict:
    out: dict = {}
    for k, v in data.items():
        if k == "@@locale":
            out[k] = "sr_Cyrl"
            continue
        if k.startswith("@") or not isinstance(v, str):
            out[k] = v
            continue
        out[k] = serbian_latin_to_cyrillic(v)
    return out


def translate_arb(en: dict, locale_key: str, google_code: str) -> dict:
    translator = (
        GoogleTranslator(source="en", target=google_code) if GoogleTranslator else None
    )
    plural_fix = build_plural_overrides(locale_key)
    out: dict = {}
    out["@@locale"] = locale_key
    for k, v in en.items():
        if k == "@@locale":
            continue
        if k.startswith("@"):
            out[k] = v
            continue
        if not isinstance(v, str):
            out[k] = v
            continue
        if k in plural_fix:
            out[k] = plural_fix[k]
            continue
        out[k] = translate_value(translator, v, google_code)
    return out


def write_arb(path: Path, data: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write("\n")


def main() -> None:
    with EN_ARB.open(encoding="utf-8") as f:
        en = json.load(f)
    if GoogleTranslator:
        print("Using Google Translate (deep_translator).")
    else:
        print("deep_translator not installed — copying English for translated locales.")

    for stem, locale_val, gcode in TARGETS:
        out_path = OUT_DIR / f"app_{stem}.arb"
        if gcode:
            data = translate_arb(en, locale_val, gcode)
            write_arb(out_path, data)
            print(f"Wrote {out_path.name} ({locale_val})")
        time.sleep(0.2)

    with SR_LATN_ARB.open(encoding="utf-8") as f:
        sr_latn = json.load(f)
    cyrl = transliterate_arb(sr_latn)
    write_arb(OUT_DIR / "app_sr_Cyrl.arb", cyrl)
    print("Wrote app_sr_Cyrl.arb (transliterated from app_sr_Latn.arb)")


if __name__ == "__main__":
    main()
