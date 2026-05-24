# Z-Phone（日本語 RP 向けフォーク）

[![License: DWYWDBM](https://img.shields.io/badge/License-DWYWDBM-blue.svg)](LICENSE)
[![FiveM](https://img.shields.io/badge/FiveM-Resource-6c3fb5.svg)](https://docs.fivem.net/)
[![GitHub](https://img.shields.io/badge/GitHub-matrix9neonebuchadnezzar2199--sketch%2Fz--phone-181717.svg?logo=github)](https://github.com/matrix9neonebuchadnezzar2199-sketch/z-phone)
[![Based on](https://img.shields.io/badge/Based%20on-alfaben12%2Fz--phone-181717.svg?logo=github)](https://github.com/alfaben12/z-phone)
[![Framework](https://img.shields.io/badge/Framework-QBCore%20%7C%20ESX%20%7C%20QBX-green.svg)](config/config.lua)
[![UI](https://img.shields.io/badge/UI-React%2018%20%2B%20Tailwind-61DAFB.svg?logo=react&logoColor=white)](web/)
[![SQL](https://img.shields.io/badge/SQL-oxmysql-orange.svg)](https://github.com/overextended/oxmysql)
[![Voice](https://img.shields.io/badge/Voice-pma--voice-blueviolet.svg)](https://github.com/AvarianKnight/pma-voice)
[![i18n](https://img.shields.io/badge/i18n-Phase%201%20done-3fb950.svg)](docs/CHANGELOG.md)
[![Locale](https://img.shields.io/badge/Locale-ja%20%2F%20Asia%2FTokyo-red.svg)](locales/ja.lua)

[alfaben12/z-phone](https://github.com/alfaben12/z-phone) をベースに、**日本語 RP サーバー向けのバグ修正・i18n 基盤**を加えた FiveM スマホリソースです。  
iPhone 15 風 NUI で、連絡先・メッセージ・通話・銀行・SNS・ニュースなど RP 機能を 1 つに集約します。

| 読者 | 最初に読むセクション |
|------|----------------------|
| **サーバー管理者** | [インストール](#インストール) → [server.cfg](#servercfg) → [トラブルシューティング](#トラブルシューティング) |
| **開発者** | [開発](#開発) → [CHANGELOG](docs/CHANGELOG.md) |

---

## 目次

- [概要](#概要)
- [本家からの改善点](#本家からの改善点)
- [アプリ一覧](#アプリ一覧)
- [必要条件](#必要条件)
- [インストール](#インストール)
- [server.cfg](#servercfg)
- [設定](#設定)
- [開発](#開発)
- [トラブルシューティング](#トラブルシューティング)
- [既知の残課題](#既知の残課題)
- [クレジット・ライセンス](#クレジットライセンス)
- [GitHub Topics](#github-topics)

---

## 概要

| 項目 | 内容 |
|------|------|
| ベース | [alfaben12/z-phone](https://github.com/alfaben12/z-phone) |
| UI | React 18 + Vite + Tailwind |
| DB | oxmysql（`zp_*`） |
| デフォルト | QBX（`Config.Core` で切替） |

---

## 本家からの改善点

詳細: [docs/CHANGELOG.md](docs/CHANGELOG.md)

### Critical / High

| ID | 問題 | 対応 |
|----|------|------|
| C-01 | 送金時 `addAccountMoney` が `RemoveMoney` を呼ぶ | `AddMoney` に修正 |
| C-02 | Discord Webhook ハードコード | convar `zphone_discord_webhook` |
| H-01 | QBX 請求書スタブ | `phone_invoices` 接続 |
| H-02 | IBAN 確認の charinfo エラー | `ReceiverPlayer.name` 使用 |
| H-03 | goverment / government 表記ゆれ | 両エイリアス追加 |

### Medium + i18n

M-01〜M-08（NUI リファクタ・着信リング統合・conversationid）、i18n Phase 1（config 日本語、`locales/ja.lua`、react-i18next スケルトン）

---

## アプリ一覧

| カテゴリ | アプリ | 説明 |
|----------|--------|------|
| 通信 | 電話 / メッセージ / 連絡先 | 通話（pma-voice）、DM・グループ、共有 |
| 金融 | ウォレット | 残高・送金・履歴・請求書 |
| SNS | Loops | タイムライン・コメント・プロフィール |
| 情報 | ニュース / メール / 広告 | 記事・ライブ・受信メール・掲示板 |
| 生活 | ガレージ / 物件 / サービス | 車両・住宅・職業問い合わせ |
| メディア | カメラ / 写真 | 撮影 → Discord → ギャラリー |
| インフラ | InetMax | 通信量・トップアップ |
| 設定 | 設定 | アバター・壁紙・匿名/DND |

---

## 必要条件

| リソース | 用途 |
|----------|------|
| ox_lib | callback / notify |
| oxmysql | DB |
| ox_inventory | 電話アイテム |
| qb-core | QBX / QB |
| qb-banking | 銀行 |
| pma-voice | 通話 |
| screenshot-basic | カメラ |
| interact-sound | 着信音 |

---

## インストール

### 1. 配置

```powershell
git clone https://github.com/matrix9neonebuchadnezzar2199-sketch/z-phone.git
```

`resources` 配下に配置。フォルダ名 = ensure 名。

> リネームする場合は `web/src/main.jsx` の `resourceName` も一致させ、`npm run build` すること。

### 2. ensure 順

```cfg
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

### 3. データベース

```bash
mysql -u USER -p DATABASE < z-phone.sql
```

QBX/QB で請求書を使う場合は `phone_invoices` テーブルも必要。

### 4. 着信音

[本家手順](https://github.com/alfaben12/z-phone#required-import-sound) に従い `html/sounds/` を interact-sound へコピー。

---

## server.cfg

```cfg
setr zphone_discord_webhook "https://discord.com/api/webhooks/YOUR_ID/YOUR_TOKEN"
```

---

## 設定

`config/config.lua`:

```lua
Config.Core = "QBX"
Config.OpenPhone = 'M'
Config.Locale = "ja"   -- "en" で英語 UI（NUI + Lua 通知）
```

`web/public/static/config.json` — メニューラベル・`Asia/Tokyo` 等。変更後は `npm run build`。

`server/core/qbx.lua` — 車両/住宅/銀行/請求書クエリ（サーバー固有）。

---

## 開発

```powershell
cd web
npm install
npm run build
```

出力: `html/`（本番 NUI）

---

## トラブルシューティング

| 症状 | 対処 |
|------|------|
| 電話が開かない | 武器をしまう / phone アイテム確認 |
| カメラ失敗 | `zphone_discord_webhook` convar 設定 |
| 請求書が空 | `phone_invoices` テーブル・データ確認 |
| 着信音なし | interact-sound + sounds コピー確認 |
| NUI 真っ白 | `npm run build` / `resourceName` 一致確認 |

---

## 既知の残課題

- FiveM 実機検証（管理者側で要確認）
- `Config.Locale = "en"` で英語 UI に切替可能（NUI + Lua 通知）
- L-02 Lovy / Play TV はホーム未配置（仕様通り未実装）
- I-02 ESX `AddMoneyBankSociety` スタブ（ESX 環境のみ）

---

## クレジット・ライセンス

- **原作:** [alfaben12/z-phone](https://github.com/alfaben12/z-phone) by Alfaben — [DWYWDBM](LICENSE)
- **フォーク:** [matrix9neonebuchadnezzar2199-sketch/z-phone](https://github.com/matrix9neonebuchadnezzar2199-sketch/z-phone)

---

## GitHub Topics

```
fivem, fivem-script, fivem-resource, qbcore, qbox, qbx, esx,
ox-lib, oxmysql, react, tailwindcss, nui, phone, smartphone,
roleplay, japanese, i18n, z-phone, jp-mods, pma-voice
```

---

<p align="center">
  <sub>Based on <a href="https://github.com/alfaben12/z-phone">alfaben12/z-phone</a></sub>
</p>
