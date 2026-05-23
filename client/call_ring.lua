--- Shared call ring helpers (M-06).
--- Caller owns timeout → CancelCall; callee only plays incoming ring until call ends.

--- Repeat incoming ring tone until answered or call state clears.
function PlayIncomingCallRing()
    CreateThread(function()
        while PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall do
            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'ringing', 0.2)
            Wait(Config.RepeatTimeout)
        end
    end)
end

--- Ringback + no-answer timeout for the caller. Single owner of CancelCall on timeout.
function RunOutgoingCallTimeout(toSource)
    CreateThread(function()
        local repeatCount = 0
        for _ = 1, Config.CallRepeats + 1 do
            if PhoneData.CallData.AnsweredCall then
                return
            end
            if not PhoneData.CallData.InCall then
                return
            end

            if repeatCount + 1 == Config.CallRepeats + 1 then
                PhoneData.CallData.CallId = nil
                PhoneData.CallData.InCall = false

                TriggerEvent("z-phone:client:sendNotifInternal", {
                    type = "Notification",
                    from = Config.App.Phone.Name,
                    message = L("call_not_answered"),
                })

                lib.callback('z-phone:server:CancelCall', false, function(_) end, {
                    to_source = toSource,
                })
                return
            end

            repeatCount = repeatCount + 1
            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'zpcall', 0.2)
            Wait(Config.RepeatTimeout)
        end
    end)
end
