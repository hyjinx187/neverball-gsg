# Neverball GSG Repackage

CFW-oriented repackaging of **Neverball** with a ready-to-deploy ARM runtime bundle and release assets.

## Upstream Project Credit

- Project: Neverball
- Website: https://neverball.org/
- Source: https://github.com/Neverball/neverball
- Original author: Robert Kooima
- Contributors: see upstream `doc/authors.txt`

This repository is an independent packaging/release project and is not the official Neverball repository.

## Release Assets

`v1.1.0` publishes:
- `neverball-gsg-1.1.0.tar.gz`
- `neverball-gsg-1.1.0.zip`
- `neverball-upstream-source-1.1.0.tar.gz`
- `neverball-gsg-1.1.0.sha256`

Highlights:
- Native Linux `armv7` hard-float build.
- NEON enabled (`Tag_Advanced_SIMD_arch: NEONv1 with Fused-MAC`).
- Includes CFW-tested runtime libraries and launcher scripts.

## Install (CFW SD Card)

1. Download `neverball-gsg-1.1.0.tar.gz` (or `.zip`) from Releases.
2. Extract to SD card as `/neverball` (or rename extracted folder accordingly).
3. In your CFW launcher, set executable to `neverball.sh`.
4. Launch from CFW menu.

Optional:
- Launch mini-golf mode with `neverputt.sh`.

## Runtime Notes

- Launcher scripts set `/tmp/s/libGL.so.1` to bundled `libGL.so.1.gl4es` by default.
- `libs/` contains bundled armhf libs used on CFW where system ABI/library sets differ.
- Logs are written to `neverball.log` and `neverputt.log` in the package root.
- If your firmware requires different GPU libraries, replace files in `libs/` accordingly.

## Licensing

Neverball is licensed under GPL-2.0-or-later. This repository redistributes Neverball runtime/data under that license family with attribution.

- Upstream licensing notes: `LICENSE.md` in upstream repo.
- Included corresponding source archive in release assets: `neverball-upstream-source-1.1.0.tar.gz`.
