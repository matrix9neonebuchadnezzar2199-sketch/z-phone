-- Set in server.cfg: setr zphone_discord_webhook "https://discord.com/api/webhooks/..."
local WebHook = GetConvar('zphone_discord_webhook', '')

lib.callback.register('z-phone:server:HasPhone', function(source)
    return xCore.HasItemByName(source, 'phone')
end)

lib.callback.register('z-phone:server:GetWebhook', function(_)
    if WebHook ~= '' then
        return WebHook
    else
        print('[z-phone] zphone_discord_webhook convar is not set. Camera uploads will fail until configured.')
        return nil
    end
end)
