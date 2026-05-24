# Changelog

All notable fixes for [matrix9neonebuchadnezzar2199-sketch/z-phone](https://github.com/matrix9neonebuchadnezzar2199-sketch/z-phone) (fork of [alfaben12/z-phone](https://github.com/alfaben12/z-phone)).

## [Unreleased]

### Fixed

- **C-01** `addAccountMoney` in QBX/QB core adapters now calls `AddMoney` instead of `RemoveMoney` (bank transfers credited receiver correctly).
- **C-02** Discord camera webhook moved to convar `zphone_discord_webhook` (hardcoded URL removed).
- **H-02** `TransferCheck` uses `ReceiverPlayer.name` from xCore wrapper (fixes nil `charinfo` error).
- **H-03** Added `government` job alias alongside legacy `goverment` in config and NUI `config.json`.
- **M-05** Removed invalid `cb()` calls from incoming-call timeout handler in `notification.lua`.
- **M-01** Removed duplicate `SettingComponent` mount in `DynamicComponent.jsx`.
- **H-01** QBX invoice queries wired to `phone_invoices` (Bills tab / PayInvoice).
- **M-02** Removed duplicate `generateDimensions` in `App.jsx`.
- **M-03** Consolidated call notification type routing in `handleEventPhone`.
- **M-04** Active chat message append uses `from_citizenid` and group name matching.
- **M-06** Consolidated call ring logic in `client/call_ring.lua` (caller owns timeout; callee ring only).
- **M-07** Notification overlay visibility uses `notification.type` instead of broken `isNullOrUndefined`.
- **M-08** Message notifications include `conversationid`; active chat append matches by conversation ID.
- **i18n Phase 1** Japanese `config.json` labels, `Asia/Tokyo`, `locales/ja.lua` + `L()`, react-i18next skeleton.
- **C-03** InetMax usage deduction is server-authoritative (`DeductInetMaxUsage`); client `usage-internet-data` NetEvent removed; positive usage + app whitelist validated.
- **M-10** InetMax deducted only after successful server callbacks (not on client failure paths).
- **H-04** PayInvoice balance check uses `invoice.amount` from DB, not client `body.amount`.
- **M-09** Transfer enforces `Config.Wallet.MinTransfer` on server.
- **H-05** Call end callbacks guard nil players before accessing `citizenid`.
- **M-13** `InCalls` cleared on `playerDropped`.
- **M-12** GetChats groups by `c.id` instead of `conversation_name`.
- **M-11** Restoring outside incoming call notification preserves all fields via object spread.
- **I-05** NUI axios base URL uses `GetParentResourceName()` when available.
- **I-04** `fxmanifest.lua` declares dependencies: ox_lib, oxmysql, pma-voice.
- **i18n Phase 2** Full NUI Japanese via react-i18next (`ja.json` ~250 keys, 32 components). Server/client notifications use `L()` in `locales/ja.lua`. LockScreen weekday/month localized.
- **Email templates** Wallet/InetMax/Loops confirmation emails use `L("email_*")` keys.
- **i18n Phase 5 foundation** `en.json`, `locales/en.lua`, `Config.Locale` drives NUI via `profile.locale`.
- **Services logos** Per-job logo URLs in `Config.Services` (L-01).

### Configuration

Add to `server.cfg`:

```cfg
setr zphone_discord_webhook "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE"
```

```lua
Config.Core = "QBX"
Config.OpenPhone = 'M'
Config.Locale = "ja"   -- set to "en" for English UI
```

### Known remaining

- **Runtime verify** FiveM live server test only remaining item.
- **ESX** `AddMoneyBankSociety` stub when using ESX core.
