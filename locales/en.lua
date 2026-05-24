if Config.Locale ~= "en" then
    return
end

Locale = {}

local en = {
    msg_not_enough_inet = "Not enough mobile data",
    msg_no_signal = "No signal",
    phone_weapon = "Cannot open phone while holding a weapon",
    phone_no_item = "You don't have a phone",
    call_in_progress = "Already in a call",
    call_not_answered = "No answer",
    gps_set = "GPS set to %s",
    camera_not_setup = "Camera is not set up",
    gallery_save_ok = "Saved to gallery",
    gallery_delete_ok = "Deleted from gallery",
    new_message_preview = "New message",
    notify_from_wallet = "Wallet",
    notify_from_phone = "Phone",
    notify_from_message = "Message",
    notify_from_contact = "Contact",
    notify_from_loops = "Loops",
    notify_from_inetmax = "InetMax",
    notify_from_ads = "Ads",
    notify_from_services = "Services",
    notify_from_setting = "Settings",
    notify_outside_format = "[%s] %s",
    notify_wallet_failed_pay_bill = "Failed to pay bill",
    notify_wallet_balance_not_enough = "Balance is not enough",
    notify_wallet_success_pay_bill = "Bill paid successfully",
    notify_wallet_failed_check_receiver = "Failed to verify receiver",
    notify_wallet_iban_not_registered = "IBAN not registered",
    notify_wallet_cannot_transfer_self = "Cannot transfer to yourself",
    notify_wallet_receiver_offline = "Receiver is offline",
    notify_wallet_min_transfer = "Minimum transfer amount is $%s",
    notify_wallet_transfer_success = "Transfer completed",
    notify_wallet_transfer_received = "Transfer received",
    notify_inetmax_bank_balance_not_enough = "Bank balance is not enough",
    notify_inetmax_purchase_successful = "Purchase successful",
    notify_call_phone_not_registered = "Phone number not registered",
    notify_call_person_busy = "Person is busy",
    notify_call_person_in_call = "Person is in a call",
    notify_call_unavailable = "Person is unavailable",
    notify_call_anonymous = "Anonymous",
    notify_call_incoming = "Incoming call..",
    notify_call_waiting = "Waiting for response",
    notify_call_declined = "Call declined",
    notify_call_ended = "Call ended",
    notify_chat_cannot_chat_self = "Cannot chat with yourself",
    notify_chat_invalid_phone = "Invalid phone number",
    notify_chat_group_invited = "You were invited to group %s",
    notify_message_group_created = "Group chat created",
    notify_ads_new_posted = "New ad posted",
    notify_services_message_sent = "Message sent",
    notify_services_solved = "Service request resolved",
    notify_contact_delete_success = "Contact deleted",
    notify_contact_update_success = "Contact updated",
    notify_contact_phone_not_registered = "Phone number not registered",
    notify_contact_duplicate = "Duplicate contact (%s)",
    notify_contact_save_success = "Contact saved",
    notify_contact_request_received = "New contact request received",
    notify_contact_share_failed = "Cannot share contact",
    notify_contact_share_success = "Contact shared",
    garage_unknown_vehicle = "Unknown vehicle",
    notify_profile_update_success = "Profile updated",
    notify_news_from = "News from %s",
    notify_loops_incorrect_credentials = "Incorrect username or password",
    notify_loops_welcome_back = "Welcome back @%s",
    notify_loops_try_again = "Please try again later",
    notify_loops_username_unavailable = "@%s is not available",
    notify_loops_signup_prompt = "Awesome, let's sign in",
    notify_loops_account_created = "Loops %s has been created",
    notify_loops_find_username = "Try another username",
    notify_loops_relogin_tweet = "Please re-login to post a tweet",
    notify_loops_tweet_posted = "Tweet posted",
    notify_loops_relogin_comment = "Please re-login to comment",
    notify_loops_reply_tweet = "@%s replied to your tweet",
    notify_loops_relogin_profile = "Please re-login to update profile",
    notify_loops_profile_updated = "Account updated",
    bank_transfer_reason_send = "Transfer send: %s - to %s",
    bank_transfer_reason_receive = "Transfer received - %s",
    email_wallet_transfer_subject = "Successful Money Transfer Confirmation",
    email_wallet_transfer_body = [[
Your money transfer has been completed.

Total: %s
IBAN: %s
Note: %s

Contact us if you need assistance.
]],
    email_inetmax_purchase_subject = "Internet Data Package Purchase Confirmation",
    email_inetmax_purchase_body = [[
Your internet data package purchase was successful.

Total: %s
Rate: $%s / %sKB
Status: %s

Your data package will be activated shortly.
]],
    email_inetmax_status_success = "Success",
    email_loops_signup_subject = "Your Loops account %s has been created",
    email_loops_signup_body = [[
Welcome to Loops!

Username: @%s
Full name: %s
Password: %s
Phone: %s

Log in and start exploring.
]],
}

for key, value in pairs(en) do
    Locale[key] = value
end
