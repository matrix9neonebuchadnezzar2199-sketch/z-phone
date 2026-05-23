--- Server-authoritative InetMax deduction (C-03). Load before server/feature/*.

local MAX_USAGE_KB = 500000000

local function isAllowedInetMaxApp(app)
    if type(app) ~= 'string' or app == '' then
        return false
    end
    for _, cfg in pairs(Config.App) do
        if type(cfg) == 'table' and cfg.Name == app then
            return true
        end
    end
    return false
end

local function applyInetMaxUsage(citizenid, app, usageInKB)
    local queryHistories = "INSERT INTO zp_inetmax_histories (citizenid, flag, label, total) VALUES (?, ?, ?, ?)"
    MySQL.Async.insert(queryHistories, {
        citizenid,
        "USAGE",
        app,
        usageInKB,
    })

    MySQL.Async.execute([[
        UPDATE zp_users SET inetmax_balance = GREATEST(0, inetmax_balance - ?) WHERE citizenid = ?
    ]], {
        usageInKB,
        citizenid,
    })
end

--- Deduct InetMax for a player after a successful server-side action.
--- Returns true when deducted (or InetMax disabled).
function DeductInetMaxUsage(source, app, usageInKB)
    if not Config.App.InetMax.IsUseInetMax then
        return true
    end

    local Player = xCore.GetPlayerBySource(source)
    if Player == nil then
        return false
    end

    usageInKB = tonumber(usageInKB)
    if not usageInKB or usageInKB <= 0 or usageInKB > MAX_USAGE_KB then
        return false
    end

    if not isAllowedInetMaxApp(app) then
        return false
    end

    local citizenid = Player.citizenid
    local balance = MySQL.scalar.await(
        'SELECT inetmax_balance FROM zp_users WHERE citizenid = ?',
        { citizenid }
    )

    if not balance or balance < usageInKB then
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = Config.App.InetMax.Name,
            message = Config.MsgNotEnoughInternetData,
        })
        return false
    end

    applyInetMaxUsage(citizenid, app, usageInKB)
    TriggerClientEvent("z-phone:client:usage-internet-data", source, app, usageInKB)
    return true
end
