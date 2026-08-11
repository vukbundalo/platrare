#!/bin/bash
# Copies the live widget snapshot off a booted simulator into the preview
# fixture, with account names neutralised (the fixture ships inside the appex).
#
#   tool/dump_widget_fixture.sh [simulator-udid]
#
# Run the app at least once on the simulator first so a snapshot exists.
set -euo pipefail

SIM="${1:-booted}"
OUT="ios/PlatrareWidgets/Fixtures/golden.json"

GROUP=$(xcrun simctl get_app_container "$SIM" com.platrare.app group.com.platrare.app)
SRC="$GROUP/Library/Application Support/widget_snapshot.json"

if [ ! -f "$SRC" ]; then
  echo "No snapshot at $SRC — launch the app on the simulator first." >&2
  exit 1
fi

mkdir -p "$(dirname "$OUT")"
python3 - "$SRC" "$OUT" <<'PY'
import json, sys
src, out = sys.argv[1], sys.argv[2]
d = json.load(open(src))
generic = ['Main account', 'Cash', 'Travel', 'Savings', 'Card']
for i, a in enumerate(d.get('accounts', [])):
    name = generic[i] if i < len(generic) else f'Account {i + 1}'
    a['name'] = name
    a['institution'] = ''
    a['displayName'] = name
for i, p in enumerate(d.get('plannedDueToday', [])):
    p['title'] = f'Planned {i + 1}'
json.dump(d, open(out, 'w'), indent=1, ensure_ascii=False)
print(f'wrote {out} ({len(open(out, "rb").read())} bytes)')
PY
