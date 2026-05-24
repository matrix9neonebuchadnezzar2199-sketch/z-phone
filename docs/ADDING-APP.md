# Z-Phone アプリ追加 — 開発者ガイド

**Languages:** **日本語** · [English (ADDING-APP-EN)](ADDING-APP-EN.md)

> 新規アプリを Z-Phone に追加するための**正本**ドキュメント。  
> 概要は [GUIDE-JA.md](GUIDE-JA.md)、リポジトリ全体は [README.md](../README.md) / [README.en.md](../README.en.md)。

---

## 全体像

Z-Phone は次の 3 層で動きます。

```
React NUI (web/)  ←axios POST→  Client Lua (client/feature/)  ←lib.callback→  Server Lua (server/feature/)  → oxmysql (zp_*)
```

| 層 | 役割 | 主なファイル |
|----|------|-------------|
| **NUI** | 画面・入力 | `config.json`, `menu.js`, `*Component.jsx`, `DynamicComponent.jsx`, `App.jsx` |
| **Client** | NUI ↔ ゲーム | `client/feature/*.lua` — `RegisterNUICallback` |
| **Server** | 権限・DB・InetMax | `server/feature/*.lua` — `lib.callback.register` |

**8 ステップ（チェックリスト）**

```
[ ] 0. 設計（ID・DB・権限・InetMax・通知）
[ ] 1. config.json     — APPS + MENUS
[ ] 2. menu.js         — export 定数
[ ] 3. React Component — UI
[ ] 4. DynamicComponent + App.jsx + MenuContext
[ ] 5. client/feature  — RegisterNUICallback
[ ] 6. server/feature  — lib.callback + DB（00a_schema 任意）
[ ] 7. i18n            — ja.json / en.json + locales/*.lua
[ ] 8. npm run build   — html/ 更新・実機確認
```

---

## Step 0: 設計を固める

手を動かす前に決めておくこと。

| 項目 | 例 | 備考 |
|------|-----|------|
| **アプリ ID** | `MENU_WEATHER` | `config.json` の `APPS` キー。英大文字 + アンダースコア |
| **表示名** | `天気` / i18n キー | `MENUS[].label` は `APPS` の**値**と完全一致 |
| **アイコン** | `web/public/images/weather.svg` | ビルド後 `html/images/` |
| **DB** | `zp_weather_logs` | 接頭辞 `zp_` 必須。`server/00a_schema.lua` に追記推奨 |
| **サーバー API** | 有 / 無 | 外部 API は **server のみ**（C-03 と同思想） |
| **他リソース** | qb-banking 等 | `server/core/*.lua` 経由が無難 |
| **InetMax** | 消費する操作 | `Config.App.InetMax.InetMaxUsage` + `DeductInetMaxUsage` |
| **職種制限** | 警察専用など | **server 側**でも job 検証（NUI だけではバイパス可） |
| **通知** | プッシュ要否 | `z-phone:client:sendNotifInternal` |

---

## Step 1: `web/public/static/config.json`

**APPS** に画面 ID を追加:

```json
{
  "APPS": {
    "MENU_WEATHER": "天気"
  }
}
```

**ホームグリッドに出す** — `MENUS` に追加（`label` は APPS の値と一致）:

```json
{
  "MENUS": [
    {
      "icon": "./images/weather.svg",
      "label": "天気"
    }
  ]
}
```

ドック常駐にしたい場合は `BOTTOM_MENUS`（電話・メッセージ等と同列）。

職種で NUI 表示を絞る場合は `SERVICES` / `NEWS` と同様に `ALLOWED_JOBS` 配列を足す設計が分かりやすい（**サーバーでも同じリストを検証すること**）。

> 変更後は必ず `npm run build`。成果物は `html/static/config.json`。

---

## Step 2: `web/src/constant/menu.js`

```javascript
export const MENU_WEATHER = config.APPS.MENU_WEATHER;
```

`DynamicComponent.jsx` / `App.jsx` から import する。

---

## Step 3: React コンポーネント

既存は `web/src/components/` 直下に `XxxComponent.jsx` が並ぶ構成（サブフォルダは `loops/` 等の大きいアプリのみ）。

**最小スケルトン**（既存パターン: `isShow` + `MenuContext`）:

```jsx
// web/src/components/WeatherComponent.jsx
import React, { useContext } from "react";
import { useTranslation } from "react-i18next";
import MenuContext from "../context/MenuContext";
import { MENU_DEFAULT } from "../constant/menu";

const WeatherComponent = ({ isShow }) => {
  const { t } = useTranslation();
  const { weatherData, setMenu } = useContext(MenuContext);

  return (
    <div
      className="relative flex flex-col w-full h-full bg-black text-white"
      style={{ display: isShow ? "block" : "none" }}
    >
      <div className="flex items-center px-4 py-3 border-b border-gray-800">
        <button type="button" onClick={() => setMenu(MENU_DEFAULT)}>
          {t("common.back")}
        </button>
        <span className="ml-2 font-semibold">{t("weather.title")}</span>
      </div>
      <div className="p-4">
        {/* weatherData を表示 */}
      </div>
    </div>
  );
};

export default WeatherComponent;
```

**規約**

- ルーティングは `DynamicComponent` が `menu === MENU_*` で切替
- データ取得は原則 **App.jsx の `useEffect`（menu switch）** で `axios.post` → `MenuContext` に格納（Wallet / Contact と同型）
- コンポーネント内で直接 `axios.post` してもよいが、既存アプリと揃えると保守しやすい
- Tailwind。`WalletComponent` / `ServicesComponent` をレイアウト参考にする
- `fetchNui` ラッパは本リポジトリ未使用。**`axios.post("/kebab-case")`** が標準

---

## Step 4: `DynamicComponent.jsx` と `App.jsx`

### DynamicComponent.jsx

```jsx
import WeatherComponent from "./WeatherComponent";

// 他コンポーネントと並べて:
<WeatherComponent isShow={menu === menus.APPS.MENU_WEATHER} />
```

### App.jsx

```javascript
import { MENU_WEATHER } from "./constant/menu";

// useEffect 内 menu switch:
case MENU_WEATHER:
  getWeatherData();
  break;

const getWeatherData = async () => {
  try {
    const response = await axios.post("/get-weather");
    setWeatherData(response.data);
  } catch (error) {
    console.error("error /get-weather", error);
  }
};
```

### MenuContext.jsx

```javascript
const [weatherData, setWeatherData] = useState(null);
// Provider の value に weatherData, setWeatherData を追加
```

`HomeComponent` は `config.json` の `MENUS` を読んでアイコンを描画するため、Step 1 だけでグリッドに出る。

---

## Step 5: `client/feature/weather.lua`

```lua
RegisterNUICallback('get-weather', function(_, cb)
    lib.callback('z-phone:server:GetWeather', false, function(result)
        cb(result)
    end)
end)
```

| ルール | 内容 |
|--------|------|
| コールバック名 | NUI の `axios.post("/get-weather")` と**完全一致** |
| プレフィックス | server は `z-phone:server:*` が既存慣例 |
| fxmanifest | `client/feature/**` は再帰読込 — **ファイル追加のみ**で OK |

ネイティブ（座標・ブリップ・サウンド）は client で。DB・金銭・外部 HTTP は server のみ。

---

## Step 6: `server/feature/weather.lua`

```lua
lib.callback.register('z-phone:server:GetWeather', function(source)
    local Player = xCore.GetPlayerBySource(source)
    if not Player then return nil end

    -- InetMax を使うアプリ（成功時のみ減算 — M-10）
    if not DeductInetMaxUsage(source, Config.App.Weather.Name, Config.App.InetMax.InetMaxUsage.WeatherFetch) then
        return { error = 'no_inet' }
    end

    -- DB 例
    local row = MySQL.single.await(
        'SELECT * FROM zp_weather_cache WHERE citizenid = ? LIMIT 1',
        { Player.citizenid }
    )
    return row or { temp = 22, cond = 'sunny' }
end)
```

**`config/config.lua` にアプリ名と消費量を追加:**

```lua
Config.App = {
    -- ...
    Weather = { Name = "Weather" },
    InetMax = {
        InetMaxUsage = {
            WeatherFetch = math.random(5000, 15000),
        },
    },
}
```

`DeductInetMaxUsage` は `server/00_inetmax_usage.lua` で定義。クライアントから減算させない（C-03）。

**外部 API** は `PerformHttpRequest` を **server のみ**で実行。

### DB テーブル追加

**推奨:** `server/00a_schema.lua` の `SCHEMA` 配列に `CREATE TABLE IF NOT EXISTS` を追記（`Config.AutoInstallSchema = true` で起動時作成）。

```lua
--[[CREATE TABLE IF NOT EXISTS `zp_weather_cache` (
    `citizenid` varchar(100) NOT NULL,
    `payload` text NOT NULL,
    `updated_at` timestamp NOT NULL DEFAULT current_timestamp,
    PRIMARY KEY (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
```

手動運用向けには `z-phone.sql` にも追記可（**DROP 付きダンプなので本番既存 DB には流さない**）。

---

## Step 7: i18n

| 対象 | ファイル |
|------|----------|
| NUI 文言 | `web/src/i18n/locales/ja.json` / `en.json` |
| 通知・メール | `locales/ja.lua` / `en.lua` — `L("notify_*")` |

```json
// ja.json
"weather": {
  "title": "天気",
  "forecast": "予報"
}
```

```lua
-- ja.lua
notify_weather_updated = "天気情報を更新しました",
```

本フォークは Phase 2 済み（NUI 32 画面 + 通知 ~60 件）。新アプリも同パターンで揃える。

---

## Step 8: ビルドと検証

```powershell
cd z-phone-main/web
npm install
npm run build
```

**開発中のホットリロード**（[GUIDE-JA.md § 開発](GUIDE-JA.md#開発)）:

```lua
-- fxmanifest.lua を一時変更
ui_page "http://localhost:5173"
```

```powershell
cd web
npm run dev
```

**リリース前チェックリスト**

| # | 項目 |
|---|------|
| 1 | InetMax は `DeductInetMaxUsage` で server のみ減算 |
| 2 | `playerDropped` / nil Player で callback が落ちない（H-05） |
| 3 | job 制限は server でも検証（クライアント表示だけは NG） |
| 4 | Discord 等の秘密は `zphone_discord_webhook` convar 経由 |
| 5 | `axios` パス ↔ `RegisterNUICallback` ↔ `lib.callback` 名の一致 |
| 6 | `npm run build` 後 `html/` が更新されている |
| 7 | ホーム → アプリ → Back → CLOSE → 再 OPEN で状態正常 |

`Config.Debug = true` で F8 追跡しやすくなる。

---

## 参考: 既存アプリのパターン

| パターン | 参考 | 特徴 |
|----------|------|------|
| 一覧 + 詳細 | Email, News | 2 画面 (`MENU_*_DETAIL`) |
| 一覧 + CRUD | Contact, Ads | 追加/編集/削除 |
| SNS | Loops | 認証 + タイムライン + サブ画面 |
| リアルタイム | Message, Phone | 通知・着信連携 |
| 外部連携 | Garage, Houses | `server/core` のクエリ |
| 閲覧のみ | Garage | シンプル |
| 通信量 | InetMax | トップアップ + 履歴 |

---

## アイコン

1. SVG を `web/public/images/myapp.svg` に配置
2. `npm run build` → `html/images/myapp.svg`
3. 既存 24×24 前後のトーンに合わせる

---

## 通知（任意）

```lua
TriggerClientEvent('z-phone:client:sendNotifInternal', targetSource, {
    type = 'Notification',
    from = Config.App.Weather.Name,
    message = L('notify_weather_updated'),
})
```

---

## やってはいけないこと

1. **APPS の値を変更**して既存 `menu ===` 比較を壊す
2. **`server/core` 返却 JSON のキー名だけ変更**（NUI 全体が連鎖修正）
3. **`html/` だけ編集**して `web/` を更新しない
4. **クライアントから InetMax 減算**や外部 API 直叩き
5. **`z-phone.sql` を本番 DB に DROP 付きで流す**

---

## ファイル変更サマリ（テンプレ）

| 操作 | パス |
|------|------|
| 編集 | `web/public/static/config.json` |
| 編集 | `web/src/constant/menu.js` |
| 新規 | `web/src/components/WeatherComponent.jsx` |
| 編集 | `web/src/components/DynamicComponent.jsx` |
| 編集 | `web/src/App.jsx` |
| 編集 | `web/src/context/MenuContext.jsx` |
| 新規 | `client/feature/weather.lua` |
| 新規 | `server/feature/weather.lua` |
| 追記 | `server/00a_schema.lua`（DB 時・推奨） |
| 編集 | `config/config.lua`（InetMax / App.Name） |
| 編集 | `locales/ja.lua`, `en.lua`, `i18n/locales/*.json` |
| 新規 | `web/public/images/weather.svg` |
| ビルド | `html/` 一式 |

---

## アプリ案（RP / 海外トレンド参考）

実装優先度はサーバー方針次第。技術的には上記 8 ステップで追加可能。

| アプリ案 | 概要 | 連携のヒント |
|----------|------|----------------|
| **天気 / 災害** | ゾーン天候・津波アラート RP | server のみで API or 静的 JSON。InetMax あり |
| **フィットネス / 歩数** | 日次歩数・ランキング | `zp_*` ログ + 既存 stat export |
| **配車 / ライドシェア** | Uber 風依頼 | Services 拡張 or 専用 job 通知 |
| **マーケットプレイス** | 個人間売買掲示板 | Ads 拡張 + ox_inventory |
| **暗号 / 株** | 仮想通貨・株価（RP 経済） | Wallet 連携。server 権威の残高 |
| **グループ / ギルド** | ギャング・会社チャット | Message のグループ拡張 |
| **イベント / チケット** | サーバーイベント予約 | メール通知 + QR 風 UI |
| **メモ / ToDo** | 個人メモ（オフライン可） | DB のみ。InetMax 不要 |
| **翻訳 / 辞書** | 多言語 RP 支援 | i18n 基盤と相性良い |
| **レース / リーダーボード** | `MENU_RACE` 未実装枠の活用 | タイム trial + `zp_*` |

コミュニティ PR 歓迎: [GitHub Issues](https://github.com/matrix9neonebuchadnezzar2199-sketch/z-phone/issues) で提案・議論後、本ガイドに沿って実装してください。

---

## 関連ドキュメント

| ファイル | 内容 |
|----------|------|
| [GUIDE-JA.md](GUIDE-JA.md) | インストール・設定・TS |
| [ADDING-APP-EN.md](ADDING-APP-EN.md) | 本ガイド（英語） |
| [DESIGN.md](DESIGN.md) | アーキテクチャ（monorepo 版は jp-z-phone/docs/DESIGN.md） |
| [KNOWN-ISSUES.md](KNOWN-ISSUES.md) | 既知問題（monorepo 版あり） |
| [I18N-PLAN.md](I18N-PLAN.md) | 日本語化計画（monorepo 版あり） |
