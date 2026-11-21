# Changelog

All notable user-visible changes to the DumbBudget TOS application package.

## 2026.11.14-3 — 2026-11-21

Review remediation for `2026.11.14-2` (aarch64 on-hold, tracking checklist
TOS-APP-CL-20261120-01; codes C10/C2/C3/C4/C5/C9/F2/T1).

### Fixed
- **F2 — aarch64 service failed to start: amd64-only image.** The `-1` and
  `-2` packages used `moechz/dumbbudget:2026.11.14`, which is a **single
  `linux/amd64` OCI manifest** (verified against the registry: manifest
  `sha256:b73d761a5c16…`). On aarch64 hardware the container cannot execute, so
  the service never becomes ready and the App Center install test cannot open
  the app. This version pulls the official upstream
  `dumbwareio/dumbbudget:b9db5cb32d14b7b78675d8be054611d4829253ef`, an OCI image
  index (digest `sha256:e845d989765c…`) with native `linux/amd64`
  (`sha256:b73d761a5c16…`) and `linux/arm64` (`sha256:aeacb4d78de9…`) manifests.
  The amd64 layers are byte-identical to the previous package.
- **C9 — description inconsistent with delivered functionality.** The English
  description now lists what DumbBudget 1.0.0 actually ships (income/expense
  and categories, running balance, date-range filtering, sorting, CSV/PDF
  export, recurring transactions, 24 currencies, theme, PWA, optional PIN). The
  Simplified and Traditional Chinese descriptions and install notes were
  leftover text from a different application (a habit tracker) and now describe
  DumbBudget, its real data path and its optional PIN. All 23 language sections
  carry the corrected release note and the accurate `important` text.
- **C10 — repository and directory compliance.** The README now documents the
  repository layout, install/first start/upgrade, the exact data path, privacy,
  security limits, build/verification and licences. `PRIVACY.md`, `NOTICE.md`
  and `LICENSE` are present; the repository is public.
- **C2 — intellectual property.** `tosapp.json` declares **GPL-3.0** for the
  upstream application (it was incorrectly MIT). `NOTICE.md` records the
  upstream project, author, commit, image digests, inside-image components,
  packaging licence and the trademark statement. `LICENSE` (MIT) covers only
  this packaging.
- **C3/C4/C5 — privacy policy.** `PRIVACY.md` covers the actual data
  (transactions, optional PIN, session cookie, theme, generated PWA files),
  local storage, outbound connections (Docker Hub pull, browser → cdnjs for
  jsPDF), the retention period, user rights, security measures, third-party
  sharing and the deletion channel. `help` in `config.ini` and `tosapp.json`
  points to <https://github.com/Moechz/dumbbudget/blob/main/PRIVACY.md>.
- **Stale metadata.** The `probe` block in `tosapp.json` described a different
  application (beaverhabits) and `entrypoint_file` pointed at a file that did
  not exist; both are gone. The wrapper now refreshes the code copy on every
  start instead of only on the first one, so upgrades take effect.

### Security
- **T1 — high/critical CVE in the upstream image, retained with reason.** The
  upstream DumbBudget repository has no release, tag or commit newer than
  `b9db5cb32d14` (2025-11-03); the official multi-arch image pinned above is that
  build (Node.js 20.19.5 on Alpine 3.22.2). There is no newer upstream image to
  upgrade to, and the packaging does not redistribute or rebuild the
  application, so the affected runtime components cannot be patched from this
  repository without forking the upstream image. The finding remains tracked:
  it will be re-checked on the next upstream release, and the package will be
  rebuilt on the fixed image as soon as one exists. Mitigations available today:
  keep the app on the LAN, do not expose port 8161, and set `DUMBBUDGET_PIN`.
- Container still runs as uid 1000 with no `privileged`, no host network, no
  `cap_add` and no Docker socket; the image is pinned by upstream commit tag.

### Changed
- Version bumped from `2026.11.14-2` to `2026.11.14-3` (upstream base
  unchanged).
- Image tag changed from the maintainer's amd64-only mirror to the official
  upstream multi-arch commit tag.

## 2026.11.14-1 — 2026-11-14

### Added
- First release. DumbBudget (`moechz/dumbbudget:2026.11.14`, Docker Hub,
  unmodified) packaged as a TOS 7 Docker application, published on port 8161
  and running as a non-root user (1000:1000).
- Persistent data is kept under `/Volume1/DockerAppData/dumbbudgetdocker/`.
