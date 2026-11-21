# dumbbudget-for-tos

> TerraMaster TOS 7 App Center — **Docker application** package for
> [DumbBudget](https://github.com/DumbWareio/DumbBudget), a small self-hosted
> budget tracker.

## What this is

A four-file TOS Docker application archive (`dumbbudgetdocker.tar.gz`) that
installs DumbBudget on TOS 7 through the App Center:

- `config.ini` — TOS application metadata (`application_type: docker`, id `dumbbudgetdocker`)
- `dumbbudgetdocker.lang` — 23-language metadata (TOS requires 14)
- `dumbbudgetdocker.svg` — application icon (SVG, rounded tile, 3 elements)
- `docker-compose.yml` — one service, official multi-arch image

The repository also contains the complete source of the package: the `src/`
templates, the deterministic build scripts, the review-standards self-check and
the isolated staging test.

## How it works

| | |
|---|---|
| Container image | `dumbwareio/dumbbudget:b9db5cb32d14b7b78675d8be054611d4829253ef` (Docker Hub, **official multi-arch** upstream image, used unmodified) |
| Open | `http://<NAS-IP>:8161/` (container port 3000) |
| Runs as | non-root, `user: "1000:1000"` |
| Persistent data | `/data` → `/Volume1/DockerAppData/dumbbudgetdocker/data` |
| Transaction file | `/Volume1/DockerAppData/dumbbudgetdocker/data/app/data/transactions.json` |
| Generated PWA files | `/Volume1/DockerAppData/dumbbudgetdocker/data/app/public/assets/` |
| Logs | `docker logs dumbbudgetdocker` (stdout/stderr) |
| Optional PIN | set `DUMBBUDGET_PIN` in the container environment |
| Optional currency | set `CURRENCY` (default `USD`, 24 codes supported) |
| Optional title | set `SITE_TITLE` / `INSTANCE_NAME` |

DumbBudget itself is a deliberately simple personal-finance app: income and
expenses with categories, a running balance, date-range filtering, sorting by
date or amount, CSV and PDF export, recurring transactions, 24 currencies, a
light/dark theme, an installable PWA and an optional PIN gate. It is
**single-user**: there are no accounts, no sharing and no cloud service.

## Repository layout

```text
.
├── README.md                  this file
├── CHANGELOG.md               every published version and its review fixes
├── PRIVACY.md                 privacy policy (also the package `help` target)
├── NOTICE.md                  upstream licence, image source, trademarks
├── LICENSE                    MIT licence for this packaging
├── tosapp.json                app spec read by the build (id, version, image,
│                              port, volume, translations, licences)
├── src/
│   ├── config.ini             TOS metadata template (@@VERSION@@/@@PLATFORM@@)
│   ├── docker-compose.yml     one non-root service, fixed multi-arch image tag
│   ├── entrypoint.sh          start-up wrapper embedded into the compose file
│   ├── dumbbudgetdocker.lang  23-language descriptions
│   └── dumbbudgetdocker.svg   store icon
├── scripts/
│   ├── build.sh               stage → verify → deterministic tar.gz + sha256
│   └── build-dual.sh          build both architectures and run the official -c
├── tools/
│   └── verify.py              review-standards self-check (archive layout,
│                              metadata, languages, ports, permissions, …)
├── test/
│   └── install-and-verify.sh  optional on-device install check
└── TOSAppSelfTestingTool      official TOS package checker (v1.0.2+)
```

`build/`, `out/` and `test/compose-resolved/` are generated and intentionally
not committed.

## Install, first start and upgrade

1. Install “DumbBudget” from App Center, or install the package manually and open
   `http://<NAS-IP>:8161/`.
2. The first start copies the application code (about 100 KB, no
   `node_modules`) from the image into
   `/Volume1/DockerAppData/dumbbudgetdocker/data/app/`, symlinks the image's
   `node_modules` and starts the server. Nothing is downloaded except the
   Docker image.
3. Transactions are written to
   `/Volume1/DockerAppData/dumbbudgetdocker/data/app/data/transactions.json`.
   Restarting or updating the app keeps them; the code copy is refreshed on
   every start, so an update takes effect immediately.
4. **Upgrading from 2026.11.14-2:** the data path is unchanged, so existing
   transactions stay where they are. Only the image and the wrapper change.
5. To require a PIN, set `DUMBBUDGET_PIN` in the container environment (for
   example with a compose override). Without it the app logs “PIN protection is
   disabled” and the UI is open to anyone who can reach port 8161.

## Privacy

DumbBudget runs entirely on your NAS. The developer receives no data; there are
no accounts, analytics, telemetry or advertising. Transactions stay in the JSON
file above, the theme preference stays in your browser, and the only outbound
traffic is the Docker image pull plus two static jsPDF files that the **browser**
loads from `cdnjs.cloudflare.com` when the page opens (no transaction data is
sent). Uninstalling keeps the data folder unless you tick “delete data”.

**Full policy:** [PRIVACY.md](PRIVACY.md) —
<https://github.com/Moechz/dumbbudget/blob/main/PRIVACY.md>. The package `help`
field and `config.ini` point to that URL.

## Security and known limitations

- **LAN exposure:** the web UI is plain HTTP and has no accounts. Without
  `DUMBBUDGET_PIN`, anyone who can reach port 8161 can read and change the
  budget. Use a VPN or a TLS reverse proxy on untrusted networks; do not expose
  the port to the internet.
- **PIN is not encryption:** the PIN gates the UI/API; `transactions.json` is
  stored unencrypted under the NAS file permissions.
- **PDF export needs internet:** jsPDF is loaded from `cdnjs.cloudflare.com`.
  CSV export works offline.
- **T1 (upstream CVE):** the review flagged a high/critical vulnerability in the
  upstream image. Upstream has published no newer source commit, tag or image
  after 2025-11-03 (`b9db5cb32d14`), and the official image
  `dumbwareio/dumbbudget:b9db5cb32d14b7b78675d8be054611d4829253ef` is that same
  build (Node.js 20.19.5 on Alpine 3.22.2). There is therefore no newer upstream
  image to move to. The item is tracked in [CHANGELOG.md](CHANGELOG.md) and will
  be re-checked on every upstream release; the packaging itself cannot patch the
  runtime dependencies without forking the image. Keep the app on the LAN and
  update as soon as upstream publishes a fixed image.
- **Upstream licence:** DumbBudget is **GPL-3.0**. See [NOTICE.md](NOTICE.md)
  for attribution, image provenance and the trademark statement.

## Review remediation in 2026.11.14-3

| Code | Finding | What changed |
|---|---|---|
| C10 | Repository/directory compliance | Public repository, complete README, `PRIVACY.md`/`NOTICE.md`/`LICENSE`, documented layout |
| C2 | Intellectual property | Upstream licence corrected to **GPL-3.0**; `NOTICE.md` with attribution, image digests and trademark statement |
| C3 | Privacy policy missing | `PRIVACY.md` added; `help` and `config.ini` point to its public GitHub URL |
| C4 | Privacy policy incomplete | Retention, user rights, security measures, third-party sharing and deletion channel are all covered |
| C5 | Privacy policy not accessible | Public URL <https://github.com/Moechz/dumbbudget/blob/main/PRIVACY.md> is the package `help` target |
| C9 | Description inconsistent | All 23 language sections describe the real feature set; zh-cn/zh-hk no longer carry another app's text; data path corrected |
| F2 | aarch64 service fails to start | Replaced the single-arch `moechz/dumbbudget` image with the official multi-arch upstream image (amd64 **and** arm64 manifests) |
| T1 | High/critical CVE | Upstream has no newer image; retained with the reason and mitigation above (see `CHANGELOG.md`) |

## Build and verification

```bash
scripts/build.sh                  # -> out/dumbbudgetdocker.tar.gz + .sha256
scripts/build.sh 2026.11.14-3 x86_64
scripts/build-dual.sh 2026.11.14-3   # both architectures + official -c
python3 ../../stage.py .             # isolated runtime check (from issue-watch)
```

The build stages the four files, substitutes `@@VERSION@@`/`@@PLATFORM@@`,
injects `src/entrypoint.sh` into the compose block scalar (escaping `$`),
removes CRLF/BOM/AppleDouble, then runs `tools/verify.py`: archive layout, JSON
validity, required fields, 14+ language coverage, version consistency,
Docker-Hub-only images, fixed tag, reserved/recommended host ports, non-root
user, per-service healthcheck/TZ/restart, data path below the application data
root, never the `/Volume*` wildcard, no literal secrets and the SVG
size/element limits. `scripts/build-dual.sh` then runs the official
`TOSAppSelfTestingTool -c` on both packages.

## Store submission

1. Public GitHub repo (code + README only).
2. Release **tag `v2026.11.14-3`**, assets `dumbbudgetdocker_x86_64.tar.gz`,
   `dumbbudgetdocker_aarch64.tar.gz` and their `.sha256` files.
3. Developer platform → version `2026.11.14-3` for `x86_64` and `aarch64`.

## Licence and attributions

| Component | Licence | Notes |
|---|---|---|
| DumbBudget (upstream) | **GPL-3.0** | <https://github.com/DumbWareio/DumbBudget> — used unmodified inside the image |
| `dumbwareio/dumbbudget` image | GPL-3.0 | Official upstream multi-arch image, pinned by commit tag, pulled at install time |
| This packaging (compose, metadata, translations, icon, scripts) | MIT | see `LICENSE` |

“DumbBudget”, “DumbWare”, “TerraMaster” and “TOS” are trademarks or registered
trademarks of their respective owners. This is an independent community package
by Moechz; it is not affiliated with or endorsed by the DumbBudget project or
TerraMaster. Full details: [NOTICE.md](NOTICE.md).

## Support

- Privacy and packaging: **moechz@163.com**
- Upstream application: <https://github.com/DumbWareio/DumbBudget/issues>
