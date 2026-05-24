# Z-Phone（日本語 RP 向けフォーク）

[![License: DWYWDBM](https://img.shields.io/badge/License-DWYWDBM-blue.svg)](LICENSE)
[![FiveM](https://img.shields.io/badge/FiveM-Resource-6c3fb5.svg)](https://docs.fivem.net/)
[![GitHub](https://img.shields.io/badge/GitHub-matrix9neonebuchadnezzar2199--sketch%2Fz--phone-181717.svg?logo=github)](https://github.com/matrix9neonebuchadnezzar2199-sketch/z-phone)
[![Based on](https://img.shields.io/badge/Based%20on-alfaben12%2Fz--phone-181717.svg?logo=github)](https://github.com/alfaben12/z-phone)
[![Framework](https://img.shields.io/badge/Framework-QBCore%20%7C%20ESX%20%7C%20QBX-green.svg)](config/config.lua)
[![UI](https://img.shields.io/badge/UI-React%2018%20%2B%20Tailwind-61DAFB.svg?logo=react&logoColor=white)](web/)
[![i18n](https://img.shields.io/badge/i18n-Phase%202%20done-3fb950.svg)](docs/GUIDE-JA.md)
[![Locale](https://img.shields.io/badge/Locale-ja%20%7C%20en-red.svg)](docs/GUIDE-JA.md#多言語-i18n)

[alfaben12/z-phone](https://github.com/alfaben12/z-phone) をベースに、**日本語 RP サーバー向けのバグ修正・セキュリティ強化・i18n** を加えた FiveM スマホリソースです。  
iPhone 15 風 NUI で、連絡先・通話・銀行・SNS（Loops）・ニュースなど RP 機能を 1 つに集約します。

---

## クイックスタート

```powershell
git clone https://github.com/matrix9neonebuchadnezzar2199-sketch/z-phone.git
mysql -u USER -p DATABASE < z-phone.sql
```

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
Config.Locale = "ja"   -- "en" で英語 UI
```

着信音は [本家手順](https://github.com/alfaben12/z-phone#required-import-sound) で interact-sound へコピー。

---

## 本フォークの主な改善（要約）

| 区分 | 内容 |
|------|------|
| **Critical** | 送金バグ修正（C-01）、Webhook convar 化（C-02）、InetMax server 権威化（C-03） |
| **High** | QBX 請求書接続、PayInvoice 検証、通話 nil ガード |
| **i18n** | NUI 全文日本語 + `Config.Locale` で ja/en 切替 |
| **その他** | 着信リング統合、GetChats 修正、Services 職種別 logo |

一覧・背景は **[詳細ガイド](docs/GUIDE-JA.md#本家からの改善点)** を参照。

---

## ドキュメント

| ドキュメント | 内容 |
|-------------|------|
| **[docs/GUIDE-JA.md](docs/GUIDE-JA.md)** | **詳細ガイド** — インストール・設定・i18n・トラブルシューティング |
| [docs/CHANGELOG.md](docs/CHANGELOG.md) | 変更履歴 |

---

## 開発

```powershell
cd web
npm install
npm run build
```

詳細: [GUIDE-JA.md § 開発](docs/GUIDE-JA.md#開発)

---

## トラブルシューティング（よくあるもの）

| 症状 | 対処 |
|------|------|
| 電話が開かない | 武器をしまう / `phone` アイテム確認 |
| カメラ失敗 | `zphone_discord_webhook` convar |
| NUI 真っ白 | `npm run build` |
| 請求書が空 | `phone_invoices` テーブル確認 |

その他: [GUIDE-JA.md § トラブルシューティング](docs/GUIDE-JA.md#トラブルシューティング)

---

## 残課題

- **FiveM 実機検証**（コード上は完了、サーバー確認のみ）
- ESX `AddMoneyBankSociety` スタブ（ESX 環境のみ）

---

## クレジット・ライセンス

- **原作:** [alfaben12/z-phone](https://github.com/alfaben12/z-phone) by Alfaben — [DWYWDBM](LICENSE)
- **フォーク:** [matrix9neonebuchadnezzar2199-sketch/z-phone](https://github.com/matrix9neonebuchadnezzar2199-sketch/z-phone)

---

<p align="center">
  <sub>Based on <a href="https://github.com/alfaben12/z-phone">alfaben12/z-phone</a> · <a href="docs/GUIDE-JA.md">詳細ガイド</a></sub>
</p>
