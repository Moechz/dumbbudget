# NOTICE — third-party components and attributions

This package (`dumbbudgetdocker`, TOS 7 Docker application, version
`2026.11.14-3`) is an independent packaging by Moechz of the upstream
**DumbBudget** project.

## 1. Upstream application — DumbBudget

- Project: <https://github.com/DumbWareio/DumbBudget>
- Author / brand: **DumbWare** (DumbWareio)
- Upstream version: `1.0.0` (`package.json`); the image was built from the
  upstream `main` branch at commit `b9db5cb32d14b7b78675d8be054611d4829253ef`
  (2025-11-03), the latest upstream commit at the time of this package
- Licence: **GNU General Public License v3.0 (GPL-3.0)** —
  <https://github.com/DumbWareio/DumbBudget/blob/main/LICENSE>
- Relationship: the upstream application is used **unmodified**, inside the
  container image. No upstream source code is redistributed by this package;
  the image is pulled from Docker Hub at install time.

An earlier package (`2026.11.14-1`/`-2`) used the maintainer's own
`moechz/dumbbudget:2026.11.14` build, which was a **single `linux/amd64`
manifest**. It is no longer used: on aarch64 hardware the container could not
start.

## 2. Container image — `dumbwareio/dumbbudget:b9db5cb32d14b7b78675d8be054611d4829253ef`

- Registry: Docker Hub —
  `docker.io/dumbwareio/dumbbudget:b9db5cb32d14b7b78675d8be054611d4829253ef`
- Source: the **official upstream image** for the commit above; it is an OCI
  image index with native `linux/amd64` and `linux/arm64` manifests:
  - index digest: `sha256:e845d989765caceb07b48986764e6b06871d6788a749e7857bfbbea0ae4db5fc`
  - `linux/amd64`: `sha256:b73d761a5c1624e6333f50380304e336ba76755f445d98b820dc5cd4fdff07c0`
  - `linux/arm64`: `sha256:aeacb4d78de95ea0ee7cd917a57b888d816b2d574c4fc20274cc74d718d87427`
- The tag is the upstream commit hash, not `:latest`, so the same immutable
  index is used for both architectures and for every reinstall.
- The image is pulled from Docker Hub at install time and is not redistributed
  in this repository or in the package archive.

## 3. Components inside the image

- Base: `node:20-alpine` as built by upstream on 2025-11-03 — Node.js
  `20.19.5`, npm `10.8.2`, Alpine Linux `3.22.2`, BusyBox `1.37.0`. Alpine
  packages (musl, OpenSSL, wget, etc.) keep the Alpine licence terms.
- Runtime npm dependencies declared by upstream: `cookie-parser` 1.4.7,
  `cors` 2.8.5, `dotenv` 16.4.7, `dumbdateparser` 1.2.0, `express` 4.21.2,
  `express-session` 1.18.1, `helmet` 7.2.0 (resolved through the upstream
  `package-lock.json`). Development-only: `nodemon` 3.1.9. Each package keeps
  its own licence inside the image (`node_modules`); their notices are not
  duplicated here. No separate binary is redistributed by this package.
- Browser-side libraries: jsPDF 2.5.1 and jspdf-autotable 3.5.31, both **MIT**,
  loaded by the web page from `cdnjs.cloudflare.com` and not redistributed in
  this repository or in the package archive.

## 4. This packaging

The files authored for this package — `docker-compose.yml`, `config.ini`,
`dumbbudgetdocker.lang`, `dumbbudgetdocker.svg`, `entrypoint.sh`, the build
scripts and this documentation — are released under **MIT** (see `LICENSE`).
The upstream application and the image remain under **GPL-3.0**; nothing in
this packaging changes that.

## 5. Trademarks and branding

“DumbBudget”, “DumbWare” and the DumbBudget logo are trademarks or brand names
of the upstream authors. “TerraMaster” and “TOS” are trademarks or registered
trademarks of TerraMaster. Their use in this repository is **descriptive only**
(to identify the upstream project and the target platform).

This package is an independent community submission by Moechz. It is **not
affiliated with, sponsored or endorsed by** the DumbBudget/DumbWare project or
TerraMaster.

The icon in `src/dumbbudgetdocker.svg` is a generic rounded tile with a dollar
glyph, drawn for this package. It does not reproduce the upstream DumbBudget
logo.

## 6. No warranty

The packaging is provided “as is”, without warranty of any kind. The upstream
GPL-3.0 terms apply to the application itself.

## 7. Contact

Moechz — moechz@163.com — <https://www.moechz.com/>
