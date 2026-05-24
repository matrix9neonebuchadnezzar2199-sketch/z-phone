# Z-Phone (Japanese RP Fork)

**Languages:** [日本語](README.md) · **English**

[![License: DWYWDBM](https://img.shields.io/badge/License-DWYWDBM-blue.svg)](LICENSE)
[![FiveM](https://img.shields.io/badge/FiveM-Resource-6c3fb5.svg)](https://docs.fivem.net/)
[![GitHub](https://img.shields.io/badge/GitHub-matrix9neonebuchadnezzar2199--sketch%2Fz--phone-181717.svg?logo=github)](https://github.com/matrix9neonebuchadnezzar2199-sketch/z-phone)
[![Based on](https://img.shields.io/badge/Based%20on-alfaben12%2Fz--phone-181717.svg?logo=github)](https://github.com/alfaben12/z-phone)
[![Framework](https://img.shields.io/badge/Framework-QBCore%20%7C%20ESX%20%7C%20QBX-green.svg)](config/config.lua)
[![UI](https://img.shields.io/badge/UI-React%2018%20%2B%20Tailwind-61DAFB.svg?logo=react&logoColor=white)](web/)
[![i18n](https://img.shields.io/badge/i18n-Phase%202%20done-3fb950.svg)](docs/GUIDE-EN.md)
[![Locale](https://img.shields.io/badge/Locale-ja%20%7C%20en-red.svg)](docs/GUIDE-EN.md#multilingual-i18n)

Fork of [alfaben12/z-phone](https://github.com/alfaben12/z-phone) with **bug fixes, security hardening, and i18n** for Japanese RP servers.  
iPhone 15–style NUI bundling contacts, calls, banking, SNS (Loops), news, and more.

---

## Quick start

```powershell
git clone https://github.com/matrix9neonebuchadnezzar2199-sketch/z-phone.git
```

**No** manual `mysql ... < z-phone.sql` by default — 16 tables are created on resource start. For manual DBA workflow see [GUIDE-EN.md § Database](docs/GUIDE-EN.md#3-database).

```cfg
# server.cfg
setr zphone_discord_webhook "https://discord.com/api/webhooks/YOUR_ID/YOUR_TOKEN"
ensure ox_lib
ensure oxmysql
ensure ox_inventory
ensure qb-core
ensure qb-banking
ensure pma-voice
ensure screenshot-basic
ensure interact-sound
ensure z-phone
```

`config/config.lua`:

```lua
Config.Core = "QBX"
Config.Locale = "ja"   -- use "en" for English UI
Config.AutoInstallSchema = true   -- false = import z-phone.sql manually
```

Ringtone setup: [upstream sound import](https://github.com/alfaben12/z-phone#required-import-sound) — copy into interact-sound.

---

## Key improvements (summary)

| Area | Changes |
|------|---------|
| **Critical** | Transfer bug fix (C-01), Webhook convar (C-02), InetMax server authority (C-03) |
| **High** | QBX invoices, PayInvoice validation, call nil guards |
| **i18n** | Full Japanese NUI + `Config.Locale` for ja/en |
| **Ops** | Auto DB schema on start, call ring integration, GetChats fix, Services logos |

Details: **[Full guide](docs/GUIDE-EN.md#improvements-over-upstream)**

---

## Adding a new app (developers)

Canonical step-by-step guide for community contributions:

| Guide | Description |
|-------|-------------|
| **[docs/ADDING-APP-EN.md](docs/ADDING-APP-EN.md)** | **Full guide (English)** |
| [docs/ADDING-APP.md](docs/ADDING-APP.md) | アプリ追加（日本語） |

**Quick path:** `config.json` → `menu.js` → React → `DynamicComponent` / `App.jsx` → `client/feature` → `server/feature` → i18n → `npm run build`

---

## Documentation

| Document | Description |
|----------|-------------|
| **[docs/ADDING-APP-EN.md](docs/ADDING-APP-EN.md)** | **Adding apps (English)** |
| [docs/ADDING-APP.md](docs/ADDING-APP.md) | アプリ追加（日本語） |
| **[docs/GUIDE-EN.md](docs/GUIDE-EN.md)** | **Full guide** — install, config, i18n, troubleshooting |
| [docs/GUIDE-JA.md](docs/GUIDE-JA.md) | 日本語版ガイド |
| [docs/CHANGELOG.md](docs/CHANGELOG.md) | Changelog |

---

## Development

```powershell
cd web
npm install
npm run build
```

Details: [GUIDE-EN § Development](docs/GUIDE-EN.md#development)

---

## Troubleshooting (common)

| Symptom | Fix |
|---------|-----|
| Phone won't open | Holster weapon / check `phone` item |
| Camera fails | Set `zphone_discord_webhook` convar |
| Blank NUI | Run `npm run build` |
| Empty bills tab | Check `phone_invoices` table |

More: [GUIDE-EN § Troubleshooting](docs/GUIDE-EN.md#troubleshooting)

---

## Remaining work

- **Live FiveM verification** (code complete; server test only)
- ESX `AddMoneyBankSociety` stub (ESX servers only)

---

## Credits & license

- **Upstream:** [alfaben12/z-phone](https://github.com/alfaben12/z-phone) by Alfaben — [DWYWDBM](LICENSE)
- **Fork:** [matrix9neonebuchadnezzar2199-sketch/z-phone](https://github.com/matrix9neonebuchadnezzar2199-sketch/z-phone)

---

<p align="center">
  <sub>Based on <a href="https://github.com/alfaben12/z-phone">alfaben12/z-phone</a> · <a href="docs/GUIDE-EN.md">Full guide</a> · <a href="README.md">日本語</a></sub>
</p>
