Locale = Locale or {}

local ja = {
    -- Config.Msg*
    msg_not_enough_inet = "通信データが不足しています",
    msg_no_signal = "圏外です",

    -- Phone open (client/main.lua)
    phone_weapon = "武器を持ったままでは開けません",
    phone_no_item = "スマートフォンを所持していません",

    -- Calls (client)
    call_in_progress = "通話中です",
    call_not_answered = "応答がありませんでした",

    -- Misc client
    gps_set = "GPSを %s に設定しました",
    camera_not_setup = "カメラが設定されていません",
    gallery_save_ok = "ギャラリーに保存しました",
    gallery_delete_ok = "ギャラリーから削除しました",

    -- Outside message preview
    new_message_preview = "新着メッセージ",
}

for key, value in pairs(ja) do
    Locale[key] = value
end
