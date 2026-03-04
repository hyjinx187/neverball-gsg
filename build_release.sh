#!/usr/bin/env bash
set -euo pipefail

SRC="${SRC:-/tmp/neverball-src-clean}"
RUNTIME_BASE="${RUNTIME_BASE:-/run/media/kyle/SD64/neverball}"
OUT="${OUT:-$(pwd)/dist}"
VERSION="${VERSION:-1.1.0}"
PKG="${PKG:-neverball-gsg-${VERSION}}"
SRC_TARBALL="neverball-upstream-source-${VERSION}.tar.gz"

rm -rf "$OUT"
mkdir -p "$OUT/$PKG/bin" "$OUT/$PKG/data" "$OUT/$PKG/libs"

cp -f "$SRC/neverball" "$OUT/$PKG/bin/neverball"
cp -f "$SRC/neverputt" "$OUT/$PKG/bin/neverputt"
chmod +x "$OUT/$PKG/bin/neverball"
chmod +x "$OUT/$PKG/bin/neverputt"

cp -a "$RUNTIME_BASE/data/." "$OUT/$PKG/data/"
cp -a "$RUNTIME_BASE/libs/." "$OUT/$PKG/libs/"

# Default libGL to gl4es for full OpenGL compatibility on CFW targets.
if [ -f "$OUT/$PKG/libs/libGL.so.1.gl4es" ]; then
  cp -f "$OUT/$PKG/libs/libGL.so.1.gl4es" "$OUT/$PKG/libs/libGL.so.1"
fi

cp -f "$SRC/LICENSE.md" "$OUT/$PKG/NEVERBALL_LICENSE.md"
cp -f "$SRC/README.md" "$OUT/$PKG/UPSTREAM_README.md"

cat > "$OUT/$PKG/neverball.sh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
NBD="$(cd "$(dirname "$0")" && pwd)"
NBLIBS="$NBD/libs"
export HOME="$NBD"
export LC_ALL=C
export SDL_VIDEODRIVER="${SDL_VIDEODRIVER:-kmsdrm}"
export SDL_AUDIODRIVER="${SDL_AUDIODRIVER:-alsa}"
export LD_LIBRARY_PATH="$NBLIBS:/usr/lib:/usr/lib/arm-linux-gnueabihf:/lib:${LD_LIBRARY_PATH:-}"
mkdir -p /tmp/s
if [ -f "$NBLIBS/libGL.so.1.gl4es" ]; then
  ln -sf "$NBLIBS/libGL.so.1.gl4es" /tmp/s/libGL.so.1
elif [ -f "$NBLIBS/libGL.so.1" ]; then
  ln -sf "$NBLIBS/libGL.so.1" /tmp/s/libGL.so.1
fi
exec "$NBD/bin/neverball" >> "$NBD/neverball.log" 2>&1
SH
chmod +x "$OUT/$PKG/neverball.sh"

cat > "$OUT/$PKG/neverputt.sh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
NBD="$(cd "$(dirname "$0")" && pwd)"
NBLIBS="$NBD/libs"
export HOME="$NBD"
export LC_ALL=C
export SDL_VIDEODRIVER="${SDL_VIDEODRIVER:-kmsdrm}"
export SDL_AUDIODRIVER="${SDL_AUDIODRIVER:-alsa}"
export LD_LIBRARY_PATH="$NBLIBS:/usr/lib:/usr/lib/arm-linux-gnueabihf:/lib:${LD_LIBRARY_PATH:-}"
mkdir -p /tmp/s
if [ -f "$NBLIBS/libGL.so.1.gl4es" ]; then
  ln -sf "$NBLIBS/libGL.so.1.gl4es" /tmp/s/libGL.so.1
elif [ -f "$NBLIBS/libGL.so.1" ]; then
  ln -sf "$NBLIBS/libGL.so.1" /tmp/s/libGL.so.1
fi
exec "$NBD/bin/neverputt" >> "$NBD/neverputt.log" 2>&1
SH
chmod +x "$OUT/$PKG/neverputt.sh"

cat > "$OUT/$PKG/libs/README.txt" <<'TXT'
Bundled armhf runtime libraries for CFW compatibility.
Default OpenGL wrapper is gl4es via /tmp/s/libGL.so.1 link at launch.
TXT

tar -czf "$OUT/$SRC_TARBALL" \
  --exclude='.git' \
  --exclude='*.o' \
  --exclude='*.d' \
  --exclude='neverball' \
  --exclude='neverputt' \
  --exclude='mapc' \
  -C "$SRC" .

( cd "$OUT" && tar -czf "$PKG.tar.gz" "$PKG" )
( cd "$OUT" && zip -rq "$PKG.zip" "$PKG" )
( cd "$OUT" && sha256sum "$PKG.tar.gz" "$PKG.zip" "$SRC_TARBALL" > "$PKG.sha256" )
