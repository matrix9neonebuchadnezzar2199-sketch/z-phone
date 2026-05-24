lib.callback.register('z-phone:server:GetBank', function(source)
    local Player = xCore.GetPlayerBySource(source)
    if Player ~= nil then
        local citizenid = Player.citizenid

        local histories = xCore.bankHistories(citizenid)
        local bills = xCore.bankInvoices(citizenid)

        return {
            histories = histories,
            bills = bills,
            balance = Player.money.bank
        }
    end
    return {}
end)

lib.callback.register('z-phone:server:PayInvoice', function(source, body)
    local Player = xCore.GetPlayerBySource(source)
    if Player == nil then 
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = L("notify_from_wallet"),
            message = L("notify_wallet_failed_pay_bill")
        })
        return false
    end

    local citizenid = Player.citizenid
    local invoice = xCore.bankInvoiceByCitizenID(body.id, citizenid)

    if not invoice then 
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = L("notify_from_wallet"),
            message = L("notify_wallet_failed_pay_bill")
        })
        return false
    end

    if Player.money.bank < invoice.amount then 
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = L("notify_from_wallet"),
            message = L("notify_wallet_balance_not_enough")
        })
        return false
    end

    Player.removeAccountMoney('bank', invoice.amount, invoice.reason)
    
    xCore.AddMoneyBankSociety(invoice.society, invoice.amount, invoice.reason)
    xCore.deleteBankInvoiceByID(invoice.id)
    
    TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
        type = "Notification",
        from = L("notify_from_wallet"),
        message = L("notify_wallet_success_pay_bill")
    })
    return true
end)

lib.callback.register('z-phone:server:TransferCheck', function(source, body)
    local Player = xCore.GetPlayerBySource(source)
    if Player == nil then 
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = L("notify_from_wallet"),
            message = L("notify_wallet_failed_check_receiver")
        })
        return {
            isValid = false,
            name = ""
        }
    end

    local citizenid = Player.citizenid
    local queryGetCitizenByIban = "select citizenid from zp_users where iban = ?"
    local receiverCitizenid = MySQL.scalar.await(queryGetCitizenByIban, {
        body.iban
    })

    if not receiverCitizenid then
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = L("notify_from_wallet"),
            message = L("notify_wallet_iban_not_registered")
        })
        return {
            isValid = false,
            name = ""
        }
    end

    if receiverCitizenid == citizenid then
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = L("notify_from_wallet"),
            message = L("notify_wallet_cannot_transfer_self")
        })
        return {
            isValid = false,
            name = ""
        }
    end

    local ReceiverPlayer = xCore.GetPlayerByIdentifier(receiverCitizenid)
    if ReceiverPlayer == nil then 
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = L("notify_from_wallet"),
            message = L("notify_wallet_receiver_offline")
        })
        return {
            isValid = false,
            name = ""
        }
    end

    DeductInetMaxUsage(source, Config.App.Wallet.Name, Config.App.InetMax.InetMaxUsage.BankCheckTransferReceiver)

    return {
        isValid = true,
        name = ReceiverPlayer.name
    }
end)

lib.callback.register('z-phone:server:Transfer', function(source, body)
    local Player = xCore.GetPlayerBySource(source)
    if Player == nil then 
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = L("notify_from_wallet"),
            message = L("notify_wallet_failed_check_receiver")
        })
        return false
    end

    local citizenid = Player.citizenid
    local total = tonumber(body.total)
    local minTransfer = Config.Wallet.MinTransfer or 0

    if not total or total < minTransfer then
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = L("notify_from_wallet"),
            message = L("notify_wallet_min_transfer", minTransfer)
        })
        return false
    end

    if Player.money.bank < total then 
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = L("notify_from_wallet"),
            message = L("notify_wallet_balance_not_enough")
        })
        return false
    end
    
    local queryGetCitizenByIban = "select citizenid from zp_users where iban = ?"
    local receiverCitizenid = MySQL.scalar.await(queryGetCitizenByIban, {
        body.iban
    })

    if not receiverCitizenid then
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = L("notify_from_wallet"),
            message = L("notify_wallet_iban_not_registered")
        })
        return false
    end

    if receiverCitizenid == citizenid then
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = L("notify_from_wallet"),
            message = L("notify_wallet_cannot_transfer_self")
        })
        return false
    end

    local ReceiverPlayer = xCore.GetPlayerByIdentifier(receiverCitizenid)
    if ReceiverPlayer == nil then 
        TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
            type = "Notification",
            from = L("notify_from_wallet"),
            message = L("notify_wallet_receiver_offline")
        })
        return false
    end

    local senderReason = string.format(L("bank_transfer_reason_send"), body.note, body.iban)
    local receiverReason = string.format(L("bank_transfer_reason_receive"), body.iban)
    Player.removeAccountMoney('bank', total, senderReason)
    ReceiverPlayer.addAccountMoney('bank', total, receiverReason)

    MySQL.Async.insert('INSERT INTO zp_emails (institution, citizenid, subject, content) VALUES (?, ?, ?, ?)', {
        "wallet",
        Player.citizenid,
        L("email_wallet_transfer_subject"),
        string.format(L("email_wallet_transfer_body"), total, body.iban, body.note),
    })

    TriggerClientEvent("z-phone:client:sendNotifInternal", source, {
        type = "Notification",
        from = L("notify_from_wallet"),
        message = L("notify_wallet_transfer_success")
    })

    TriggerClientEvent("z-phone:client:sendNotifInternal", ReceiverPlayer.source, {
        type = "Notification",
        from = L("notify_from_wallet"),
        message = L("notify_wallet_transfer_received")
    })

    DeductInetMaxUsage(source, Config.App.Wallet.Name, Config.App.InetMax.InetMaxUsage.BankTransfer)
    return true
end)