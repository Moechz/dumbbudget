# Privacy Policy — DumbBudget for TerraMaster TOS (`dumbbudgetdocker`)

**Last updated:** 21 November 2026
**Data controller / contact:** Moechz — moechz@163.com
**Applies to:** version `2026.11.14-3` and later of the TOS application
`dumbbudgetdocker`, the container image it runs and this repository.

## 1. Summary

- DumbBudget runs **entirely on your NAS**. The developer does not receive,
  collect or have access to your transactions, budget or any other data.
- There are **no user accounts**, no registration, no telemetry, no analytics
  and no cloud service operated by the developer.
- The application does **not** phone home and does **not** check for updates.
  It serves a web UI on your LAN and reads/writes one local JSON file.
- The only network access in the normal path is (a) the Docker image pull from
  Docker Hub when the application is installed or updated and (b) two static
  JavaScript libraries loaded by your **browser** from `cdnjs.cloudflare.com`
  (see §4).

## 2. What data is processed

| Data | Where it lives |
|---|---|
| Transactions: type (income/expense), amount, currency, category, description/notes, date, recurring rule | `/Volume1/DockerAppData/dumbbudgetdocker/data/app/data/transactions.json` on your NAS |
| Optional PIN (`DUMBBUDGET_PIN`) | Read from the container environment at start-up. It is **not** written to disk by the application. |
| Login session | An in-memory session in the container and an HttpOnly `connect.sid` cookie in your browser. The session is lost when the container restarts; the cookie contains only a random session id, never the PIN. |
| Theme preference (light/dark) | Your browser's `localStorage`; never sent to the server |
| PWA cache and service-worker files | Your browser's site storage |
| Generated PWA files: `manifest.json`, `asset-manifest.json`, the copied logo | `/Volume1/DockerAppData/dumbbudgetdocker/data/app/public/assets/` inside the application volume (no personal data) |
| Logs: start-up messages, PIN-enabled/disabled message | stdout/stderr only — `docker logs dumbbudgetdocker`; no log file on the NAS |

There are **no accounts** (no username, password or e-mail address is created or
stored by the app), **no attachments or file uploads**, and **no calendar,
contact or location access**. The application stores the transactions you type
in, nothing else.

If you set the optional `CURRENCY`, `BASE_URL`, `SITE_TITLE` or `INSTANCE_NAME`
environment variables, those values are configuration and are not personal data
collected by the developer.

## 3. Retention period

- **Transactions and budget data:** kept until **you** delete them. There is no
  automatic expiry and no upload. The file is rewritten on every change.
- **Uninstalling:** stops and removes the container. The data folder is kept
  unless you tick “delete data” in App Center. To delete it yourself, stop the
  app and remove `/Volume1/DockerAppData/dumbbudgetdocker/`.
- **Generated PWA files:** recreated at every start and removed with the data
  folder.
- **Logs:** stdout/stderr only; the Docker daemon keeps them according to its
  own rotation settings.
- **Browser data:** the session cookie, theme preference, PWA cache and
  service-worker cache stay in your browser until you clear site data or the
  session ends.

## 4. Network connections and third parties

| Destination | When | Data sent |
|---|---|---|
| `registry-1.docker.io` (Docker Hub) or your configured registry mirror | install and update only | anonymous image pull; no transaction data |
| Your browser ↔ NAS on port 8161 | whenever you use the app | the transactions you create, over plain HTTP on the LAN |
| `cdnjs.cloudflare.com` (Cloudflare) | every time the web UI page loads | a request for the static files `jspdf.umd.min.js` (2.5.1) and `jspdf.plugin.autotable.min.js` (3.5.31); Cloudflare receives your IP address, user agent and the requested URL. **No transaction data is sent.** PDF export uses those libraries. |
| The developer's servers | never | none |

The application embeds **no** analytics, advertising, tracking pixels, remote
fonts or other CDNs beyond the two jsPDF files above. There is **no third-party
sharing or sale** of your data. If you place the app behind a reverse proxy, VPN
or tunnel that you operate, that component is outside this package and its own
privacy terms apply. If you use the optional `DUMB_SECRET` API with another
application (for example a calendar), that application receives the data you
allow it to read.

## 5. Your rights

Because all data stays on your NAS, you exercise these rights directly:

- **Access / portability:** open the web UI, read
  `/Volume1/DockerAppData/dumbbudgetdocker/data/app/data/transactions.json`, or
  export the transaction list as CSV or PDF from the UI.
- **Correction:** edit or delete a transaction in the web UI.
- **Deletion (erasure):** delete transactions in the web UI, or stop the app and
  remove `/Volume1/DockerAppData/dumbbudgetdocker/`. Uninstalling with “delete
  data” in App Center does the same.
- **Restriction / objection:** do not set `DUMBBUDGET_PIN` to keep the UI local,
  do not expose port 8161 outside your LAN, and block `cdnjs.cloudflare.com` if
  you do not want the PDF libraries loaded (CSV export still works).
- **Complaint:** contact the developer at the address below.

There is no developer-side account to close and no data to request from the
developer. If you believe the packaging itself mishandles data, contact
**moechz@163.com**; requests are answered within 30 days.

## 6. Security measures

- The container runs as **uid 1000**, never as root, with no `privileged` mode,
  no host network, no `cap_add` and no Docker socket.
- Only one port (8161) is published; the application stores data in a single
  JSON file inside its own data folder.
- The image is the **official upstream multi-arch image**, pinned to the
  upstream commit tag
  `dumbwareio/dumbbudget:b9db5cb32d14b7b78675d8be054611d4829253ef`, never
  `:latest`.
- The optional PIN gate (`DUMBBUDGET_PIN`) is **off by default**; when off,
  anyone who can reach port 8161 can read and change the budget. When on, the
  PIN is compared in constant time and five failed attempts from one address
  trigger a 15-minute lockout.
- The PIN is **not encryption**: `transactions.json` is stored unencrypted on
  the NAS, protected by the NAS file permissions. Use disk encryption or an
  encrypted volume if that matters to you.
- The web UI is served over **plain HTTP** and the session cookie is not marked
  `Secure`, because the package has no TLS certificate. On an untrusted network,
  put it behind a VPN or a reverse proxy with TLS, and do not expose port 8161
  to the internet.
- Back up `/Volume1/DockerAppData/dumbbudgetdocker/data/app/data/transactions.json`
  before uninstalling with data removal.

## 7. Children

DumbBudget is a general-purpose personal-finance tool and is not directed at
children. No age or identity data is collected.

## 8. Changes to this policy

Material changes are recorded in `CHANGELOG.md` and in this file's “Last
updated” date. The current version is always available at
<https://github.com/Moechz/dumbbudget/blob/main/PRIVACY.md>, which is also the
URL in the package `help` field.

## 9. Contact

Moechz — **moechz@163.com** — <https://www.moechz.com/>
