#!/usr/bin/env bash
set -euo pipefail

SRC="${SRC:-/tmp/neverball-src}"
OUT="${OUT:-$(pwd)/dist}"
PKG="${PKG:-neverball-gsg-1.0.0}"

rm -rf "$OUT"
mkdir -p "$OUT/$PKG/bin" "$OUT/$PKG/data" "$OUT/$PKG/libs"

cp -f "$SRC/neverball" "$OUT/$PKG/bin/neverball"
chmod +x "$OUT/$PKG/bin/neverball"
cp -a "$SRC/data/." "$OUT/$PKG/data/"
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
if [ -f "$NBLIBS/libGL.so.1" ]; then
  ln -sf "$NBLIBS/libGL.so.1" /tmp/s/libGL.so.1
elif [ -f /usr/lib/libGL.so.1 ]; then
  ln -sf /usr/lib/libGL.so.1 /tmp/s/libGL.so.1
elif [ -f /usr/lib/arm-linux-gnueabihf/libGL.so.1 ]; then
  ln -sf /usr/lib/arm-linux-gnueabihf/libGL.so.1 /tmp/s/libGL.so.1
fi
exec "$NBD/bin/neverball" >> "$NBD/neverball.log" 2>&1
SH
chmod +x "$OUT/$PKG/neverball.sh"

cat > "$OUT/$PKG/libs/README.txt" <<'TXT'
Optional armhf runtime libraries can be placed here for firmware compatibility.
TXT

git -C "$SRC" archive --format=tar.gz --output "$OUT/neverball-upstream-source-1.6.0.tar.gz" HEAD
( cd "$OUT" && tar -czf "$PKG.tar.gz" "$PKG" )
( cd "$OUT" && zip -rq "$PKG.zip" "$PKG" )
( cd "$OUT" && sha256sum "$PKG.tar.gz" "$PKG.zip" "neverball-upstream-source-1.6.0.tar.gz" > "$PKG.sha256" )
