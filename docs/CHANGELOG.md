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

### Configuration

Add to `server.cfg`:

```cfg
setr zphone_discord_webhook "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE"
```

### Known remaining

- **M-06–M-08** Call ring duplication, notification visibility helper, group chat `conversationid` — see jp-z-phone `docs/KNOWN-ISSUES.md` and `docs/VERIFICATION.md`.
- **H-01** Requires `phone_invoices` table populated on your server `[runtime verify]`.
