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

`v1.0.0` publishes:
- `neverball-gsg-1.0.0.tar.gz`
- `neverball-gsg-1.0.0.zip`
- `neverball-upstream-source-1.6.0.tar.gz`
- `neverball-gsg-1.0.0.sha256`

## Install (CFW SD Card)

1. Download `neverball-gsg-1.0.0.tar.gz` (or `.zip`) from Releases.
2. Extract to SD card so folder name is `neverball` or `neverball-gsg-1.0.0` (as required by your launcher).
3. Point your launcher/menu entry to `neverball.sh`.
4. Launch the game from CFW menu.

## Runtime Notes

- The included ARM binary references `/tmp/s/libGL.so.1`; launcher script creates this runtime link automatically.
- `libs/` folder is provided for optional override shared libs when firmware differs.
- Logs are written to `neverball.log` in the package root.

## Licensing

Neverball is licensed under GPL-2.0-or-later. This repository redistributes Neverball runtime/data under that license family with attribution.

- Upstream licensing notes: `LICENSE.md` in upstream repo.
- Included source archive in release assets: `neverball-upstream-source-1.6.0.tar.gz`.
