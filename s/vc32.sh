#!/bin/bash
# Fetch the week's lesson-plan PDFs and extract text + links. No secrets.
set -u
B=https://files.kynaenglish.com/uploads/booking_document
W=$HOME/teaching/week; mkdir -p "$W"; cd "$HOME/teaching"
UV=$HOME/.local/bin/uv
[ -d venv ] || "$UV" venv -q venv
"$UV" pip install -q --python venv/bin/python pymupdf reportlab >/dev/null 2>&1
curl -fsS https://raw.githubusercontent.com/vietugc-hub/vietugc-hermes/main/s/week-2026-10-20.tsv -o week-2026-10-20.tsv
tail -n +2 week-2026-10-20.tsv | cut -f9 | sort -u | while read u; do
  id=$(basename "$u"); curl -fsS -m 60 "$B/$u.pdf" -o "$W/$id.pdf" || echo "FAIL $u"
done
venv/bin/python - <<'PY'
import fitz,glob,os,json
for f in sorted(glob.glob(os.path.expanduser('~/teaching/week/*.pdf'))):
    d=fitz.open(f); t="\n".join(p.get_text() for p in d)
    links=[l.get('uri') for p in d for l in p.get_links() if l.get('uri')]
    open(f[:-4]+'.txt','w').write(t); open(f[:-4]+'.links.json','w').write(json.dumps(links))
    print(os.path.basename(f),len(d),'pages',len(t),'chars',links)
PY
