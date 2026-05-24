lib.callback.register('z-phone:server:GetInternetData', function(source)
    local Player = xCore.GetPlayerBySource(source)
    if Player == nil then return {} end

    local citizenid = Player.citizenid
    local queryTopupQuery = [[
        SELECT
        total,
        flag,
        label,
        DATE_FORMAT(created_at, '%d %b %Y') as created_at
        FROM zp_inetmax_histories WHERE citizenid = ? AND flag = ? ORDER BY id desc limit 50
    ]]

    local topups = MySQL.query.await(queryTopupQuery, {
        citizenid,
        "CREDIT"
    })

    local usages = MySQL.query.await(queryTopupQuery, {
        citizenid,
        "USAGE"
    })

    local queryUsageGroup = "SELECT label as app, total FROM zp_inetmax_histories WHERE flag = 'USAGE' and citizenid = ? GROUP BY label"
    local usageGroup = MySQL.query.await(queryUsageGroup, {
        citizenid,
    })

    return {
        topup_histories = topups,
        usage_histories = usages,
        group_usage = usageGroup
    }
end)

lib.callback.register('z-phone:server:TopupInternetData', function(source, body)
    local Player = xCore.GetPlayerBySource(source)
    if Player == nil then return 0 end

    local citizenid = Player.citizenid    
    if Player.money.bank < body.total then 
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = L("notify_from_inetmax"),
            message = L("notify_inetmax_bank_balance_not_enough")
        })
        return false
    end

    local IncrementBalance = math.floor(body.total / Config.App.InetMax.TopupRate.Price) * Config.App.InetMax.TopupRate.InKB
    local queryHistories = "INSERT INTO zp_inetmax_histories (citizenid, flag, label, total) VALUES (?, ?, ?, ?)"
    local id = MySQL.insert.await(queryHistories, {
        citizenid,
        "CREDIT",
        body.label,
        IncrementBalance
    })

    local queryIncrementBalance = [[
        UPDATE zp_users SET inetmax_balance = inetmax_balance + ? WHERE citizenid = ?
    ]]

    MySQL.update.await(queryIncrementBalance, {
        IncrementBalance,
        citizenid
    })

    Player.removeAccountMoney('bank', body.total, "InetMax purchase")
    xCore.AddMoneyBankSociety(Config.App.InetMax.SocietySeller, body.total, "InetMax purchase")

    TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
        type = "Notification",
        from = L("notify_from_inetmax"),
        message = L("notify_inetmax_purchase_successful")
    })

    MySQL.Async.insert('INSERT INTO zp_emails (institution, citizenid, subject, content) VALUES (?, ?, ?, ?)', {
        "inetmax",
        Player.citizenid,
        L("email_inetmax_purchase_subject"),
        string.format(
            L("email_inetmax_purchase_body"),
            body.total,
            Config.App.InetMax.TopupRate.Price,
            Config.App.InetMax.TopupRate.InKB,
            L("email_inetmax_status_success")
        ),
    })
    
    return IncrementBalance
end)

-- C-03: client NetEvent removed; use DeductInetMaxUsage from server callbacks only.