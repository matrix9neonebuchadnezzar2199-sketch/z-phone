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

    -- From labels
    notify_from_wallet = "ウォレット",
    notify_from_phone = "電話",
    notify_from_message = "メッセージ",
    notify_from_contact = "連絡先",
    notify_from_loops = "Loops",
    notify_from_inetmax = "InetMax",
    notify_from_ads = "広告",
    notify_from_services = "サービス",

    -- Wallet / bank
    notify_wallet_failed_pay_bill = "請求書の支払いに失敗しました",
    notify_wallet_balance_not_enough = "残高が不足しています",
    notify_wallet_success_pay_bill = "請求書の支払いが完了しました",
    notify_wallet_failed_check_receiver = "受取人の確認に失敗しました",
    notify_wallet_iban_not_registered = "IBAN が登録されていません",
    notify_wallet_cannot_transfer_self = "自分自身への送金はできません",
    notify_wallet_receiver_offline = "受取人がオフラインです",
    notify_wallet_min_transfer = "送金の最低金額は $%s です",
    notify_wallet_transfer_success = "送金が完了しました",
    notify_wallet_transfer_received = "送金を受け取りました",

    -- InetMax
    notify_inetmax_bank_balance_not_enough = "銀行残高が不足しています",
    notify_inetmax_purchase_successful = "購入が完了しました",

    -- Calls
    notify_call_phone_not_registered = "電話番号が登録されていません",
    notify_call_person_busy = "相手は取り込み中です",
    notify_call_person_in_call = "相手は通話中です",
    notify_call_unavailable = "相手は現在電話に出られません",
    notify_call_anonymous = "非通知",
    notify_call_incoming = "着信中..",
    notify_call_waiting = "応答を待っています",
    notify_call_declined = "通話が拒否されました",
    notify_call_ended = "通話が終了しました",

    -- Chat
    notify_chat_cannot_chat_self = "自分自身とはチャットできません",
    notify_chat_invalid_phone = "無効な電話番号です",
    notify_chat_group_invited = "%s グループに招待されました",
    notify_message_group_created = "グループチャットを作成しました",

    -- Ads / Services
    notify_ads_new_posted = "新しい広告が投稿されました",
    notify_services_message_sent = "メッセージを送信しました",
    notify_services_solved = "サービス対応を完了しました",

    -- Contact
    notify_contact_delete_success = "連絡先を削除しました",
    notify_contact_update_success = "連絡先を更新しました",
    notify_contact_phone_not_registered = "電話番号が登録されていません",
    notify_contact_duplicate = "重複する連絡先 (%s)",
    notify_contact_save_success = "連絡先を保存しました",
    notify_contact_request_received = "新しい連絡先リクエストを受信しました",
    notify_contact_share_failed = "連絡先の共有に失敗しました",
    notify_contact_share_success = "連絡先を共有しました",
    garage_unknown_vehicle = "不明な車両",

    -- Profile / News
    notify_profile_update_success = "プロフィールを更新しました",
    notify_news_from = "%s からのニュース",

    -- Loops
    notify_loops_incorrect_credentials = "ユーザー名またはパスワードが正しくありません",
    notify_loops_welcome_back = "おかえりなさい @%s",
    notify_loops_try_again = "しばらくしてから再度お試しください",
    notify_loops_username_unavailable = "@%s は使用できません",
    notify_loops_signup_prompt = "登録してログインしましょう",
    notify_loops_account_created = "Loops %s が作成されました",
    notify_loops_find_username = "他のユーザー名を探してください",
    notify_loops_relogin_tweet = "ツイートするには再ログインしてください",
    notify_loops_tweet_posted = "ツイートを投稿しました",
    notify_loops_relogin_comment = "コメントするには再ログインしてください",
    notify_loops_reply_tweet = "@%s があなたのツイートに返信しました",
    notify_loops_relogin_profile = "プロフィール更新には再ログインしてください",
    notify_loops_profile_updated = "アカウントを更新しました",

    notify_from_setting = "設定",
    notify_outside_format = "[%s] %s",

    -- Bank transfer ledger reasons
    bank_transfer_reason_send = "送金: %s → %s",
    bank_transfer_reason_receive = "送金受取 - %s",

    -- Email templates
    email_wallet_transfer_subject = "送金完了の確認",
    email_wallet_transfer_body = [[
送金が正常に完了しました。

取引詳細:
金額: %s
IBAN: %s
メモ: %s

ご不明点があればお問い合わせください。
]],
    email_inetmax_purchase_subject = "InetMax データパッケージ購入確認",
    email_inetmax_purchase_body = [[
InetMax データパッケージの購入が完了しました。

合計: %s
レート: $%s / %sKB
ステータス: %s

データパッケージはまもなく有効化されます。
]],
    email_inetmax_status_success = "成功",
    email_loops_signup_subject = "Loops アカウント %s が作成されました",
    email_loops_signup_body = [[
Loops へようこそ！

ユーザー名: @%s
表示名: %s
パスワード: %s
電話番号: %s

ログインしてツイートをお楽しみください。
]],
}

for key, value in pairs(ja) do
    Locale[key] = value
end
