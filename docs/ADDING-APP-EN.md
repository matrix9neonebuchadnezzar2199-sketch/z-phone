# Z-Phone — Adding a New App (Developer Guide)

**Languages:** [日本語 (ADDING-APP)](ADDING-APP.md) · **English**

> **Canonical guide** for shipping a new Z-Phone app.  
> Overview: [GUIDE-EN.md](GUIDE-EN.md) · Repo TOP: [README.en.md](../README.en.md).

---

## Big picture

```
React NUI (web/)  ←axios POST→  Client Lua (client/feature/)  ←lib.callback→  Server Lua (server/feature/)  → oxmysql (zp_*)
```

| Layer | Role | Key files |
|-------|------|-----------|
| **NUI** | UI | `config.json`, `menu.js`, `*Component.jsx`, `DynamicComponent.jsx`, `App.jsx` |
| **Client** | NUI ↔ game | `client/feature/*.lua` — `RegisterNUICallback` |
| **Server** | Auth, DB, InetMax | `server/feature/*.lua` — `lib.callback.register` |

**8-step checklist**

```
[ ] 0. Design (ID, DB, jobs, InetMax, notifications)
[ ] 1. config.json     — APPS + MENUS
[ ] 2. menu.js         — export constants
[ ] 3. React component — UI
[ ] 4. DynamicComponent + App.jsx + MenuContext
[ ] 5. client/feature  — RegisterNUICallback
[ ] 6. server/feature  — lib.callback + DB (00a_schema optional)
[ ] 7. i18n            — ja.json / en.json + locales/*.lua
[ ] 8. npm run build   — refresh html/ · live test
```

---

## Step 0: Design first

| Item | Example | Notes |
|------|---------|-------|
| **App ID** | `MENU_WEATHER` | `APPS` key in `config.json` |
| **Label** | `Weather` / i18n | `MENUS[].label` must **match** `APPS` value |
| **Icon** | `web/public/images/weather.svg` | Built to `html/images/` |
| **DB** | `zp_weather_logs` | Prefix `zp_`; add to `server/00a_schema.lua` |
| **Server API** | yes / no | External HTTP **server only** (C-03 mindset) |
| **InetMax** | per action | `Config.App.InetMax.InetMaxUsage` + `DeductInetMaxUsage` |
| **Job gate** | police-only | Validate on **server**, not NUI-only |
| **Notifications** | push? | `z-phone:client:sendNotifInternal` |

---

## Step 1: `web/public/static/config.json`

```json
{
  "APPS": {
    "MENU_WEATHER": "Weather"
  },
  "MENUS": [
    {
      "icon": "./images/weather.svg",
      "label": "Weather"
    }
  ]
}
```

Use `BOTTOM_MENUS` for dock icons (Phone, Messages, etc.).

Job-restricted apps: mirror `SERVICES` / `NEWS` with `ALLOWED_JOBS` and enforce the same list on the server.

Always `npm run build` after edits.

---

## Step 2: `web/src/constant/menu.js`

```javascript
export const MENU_WEATHER = config.APPS.MENU_WEATHER;
```

---

## Step 3: React component

Place under `web/src/components/WeatherComponent.jsx` (flat layout like Wallet; subfolders for large apps e.g. `loops/`).

```jsx
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
      <div className="p-4">{/* render weatherData */}</div>
    </div>
  );
};

export default WeatherComponent;
```

**Conventions**

- Routing via `DynamicComponent` + `menu === MENU_*`
- Prefer fetching in **App.jsx** menu switch → `axios.post` → `MenuContext` (matches Wallet / Contact)
- This repo uses **`axios.post("/kebab-case")`**, not `fetchNui`
- Match Tailwind layout of existing apps

---

## Step 4: `DynamicComponent.jsx` & `App.jsx`

```jsx
<WeatherComponent isShow={menu === menus.APPS.MENU_WEATHER} />
```

```javascript
case MENU_WEATHER:
  getWeatherData();
  break;

const getWeatherData = async () => {
  const response = await axios.post("/get-weather");
  setWeatherData(response.data);
};
```

Extend `MenuContext.jsx` with `weatherData` / `setWeatherData`.

`HomeComponent` reads `MENUS` from config — Step 1 is enough for the home grid icon.

---

## Step 5: `client/feature/weather.lua`

```lua
RegisterNUICallback('get-weather', function(_, cb)
    lib.callback('z-phone:server:GetWeather', false, function(result)
        cb(result)
    end)
end)
```

Callback path must match `axios.post("/get-weather")`. `client/feature/**` is auto-loaded.

---

## Step 6: `server/feature/weather.lua`

```lua
lib.callback.register('z-phone:server:GetWeather', function(source)
    local Player = xCore.GetPlayerBySource(source)
    if not Player then return nil end

    if not DeductInetMaxUsage(source, Config.App.Weather.Name, Config.App.InetMax.InetMaxUsage.WeatherFetch) then
        return { error = 'no_inet' }
    end

    return { temp = 22, cond = 'sunny' }
end)
```

Add to `config/config.lua`:

```lua
Config.App.Weather = { Name = "Weather" }
Config.App.InetMax.InetMaxUsage.WeatherFetch = math.random(5000, 15000)
```

`DeductInetMaxUsage` lives in `server/00_inetmax_usage.lua` — never deduct from client (C-03).

**DB:** append `CREATE TABLE IF NOT EXISTS zp_weather_*` to `server/00a_schema.lua` `SCHEMA` array when `Config.AutoInstallSchema = true`.

---

## Step 7: i18n

- NUI: `web/src/i18n/locales/ja.json` / `en.json`
- Lua: `locales/ja.lua` / `en.lua` — `L("notify_*")`

---

## Step 8: Build & verify

```powershell
cd web
npm run build
```

**Pre-release checklist:** server InetMax only · nil Player on drop (H-05) · server job checks · webhook convar · path name parity · rebuilt `html/`.

---

## Reference patterns

| Pattern | Example apps |
|---------|----------------|
| List + detail | Email, News |
| CRUD | Contact, Ads |
| SNS | Loops |
| Real-time | Message, Phone |
| Framework data | Garage, Houses |

---

## App ideas (RP / trends)

| Idea | Notes |
|------|-------|
| Weather / alerts | Server-only API or static JSON |
| Fitness / steps | `zp_*` logs |
| Ride share | Extend Services or custom notify |
| Marketplace | Extend Ads + ox_inventory |
| Crypto / stocks | Wallet integration, server balance |
| Guild chat | Group messaging extension |
| Events / tickets | Email + simple QR UI |
| Notes / todo | DB only, no InetMax |
| Translation helper | Fits existing i18n stack |
| Race leaderboard | Use unimplemented `MENU_RACE` slot |

Community PRs welcome via [GitHub Issues](https://github.com/matrix9neonebuchadnezzar2199-sketch/z-phone/issues).

---

## Related docs

| File | Description |
|------|-------------|
| [GUIDE-EN.md](GUIDE-EN.md) | Install, config, TS |
| [GUIDE-JA.md](GUIDE-JA.md) | 日本語ガイド |
| [ADDING-APP.md](ADDING-APP.md) | 日本語版 |
| [../README.en.md](../README.en.md) | TOP (English) |
