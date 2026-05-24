--- Auto-create zp_* tables on resource start when missing (Config.AutoInstallSchema).
--- Manual import via z-phone.sql remains supported when AutoInstallSchema = false.

if not Config.AutoInstallSchema then
    return
end

local SCHEMA = {
    [[CREATE TABLE IF NOT EXISTS `zp_ads` (
        `id` int NOT NULL AUTO_INCREMENT,
        `media` varchar(255) NOT NULL,
        `content` text NOT NULL,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp,
        `citizenid` varchar(100) NOT NULL,
        PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
    [[CREATE TABLE IF NOT EXISTS `zp_calls_histories` (
        `id` int NOT NULL AUTO_INCREMENT,
        `citizenid` varchar(100) NOT NULL,
        `to_citizenid` varchar(50) NOT NULL,
        `created_at` datetime NOT NULL DEFAULT current_timestamp,
        `flag` varchar(10) NOT NULL DEFAULT 'IN',
        `is_anonim` tinyint(1) NOT NULL DEFAULT 0,
        PRIMARY KEY (`id`),
        INDEX `citizenid` (`citizenid`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
    [[CREATE TABLE IF NOT EXISTS `zp_contacts` (
        `id` int NOT NULL AUTO_INCREMENT,
        `citizenid` varchar(100) NOT NULL,
        `contact_citizenid` varchar(100) NOT NULL,
        `contact_name` varchar(100) NOT NULL,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY (`id`),
        UNIQUE INDEX `unique_contact` (`citizenid`, `contact_citizenid`),
        INDEX `contact_citizenid` (`contact_citizenid`),
        INDEX `citizenid_contact_citizenid` (`citizenid`, `contact_citizenid`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
    [[CREATE TABLE IF NOT EXISTS `zp_contacts_requests` (
        `id` int NOT NULL AUTO_INCREMENT,
        `citizenid` varchar(100) NOT NULL,
        `from_citizenid` varchar(50) NOT NULL,
        `created_at` datetime NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY (`id`),
        INDEX `citizenid` (`citizenid`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
    [[CREATE TABLE IF NOT EXISTS `zp_conversation_messages` (
        `id` int NOT NULL AUTO_INCREMENT,
        `conversationid` int NOT NULL,
        `sender_citizenid` varchar(100) NOT NULL,
        `content` text NOT NULL,
        `media` text NULL,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp,
        `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
        PRIMARY KEY (`id`),
        INDEX `idx_conversationid` (`conversationid`),
        INDEX `idx_sender_citizenid` (`sender_citizenid`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
    [[CREATE TABLE IF NOT EXISTS `zp_conversation_participants` (
        `conversationid` int NOT NULL,
        `citizenid` varchar(100) NOT NULL,
        `join_at` timestamp NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY (`conversationid`, `citizenid`),
        INDEX `citizenid` (`citizenid`),
        INDEX `idx_conversationid_citizenid` (`conversationid`, `citizenid`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
    [[CREATE TABLE IF NOT EXISTS `zp_conversations` (
        `id` int NOT NULL AUTO_INCREMENT,
        `name` varchar(100) NULL DEFAULT NULL,
        `is_group` tinyint(1) NOT NULL,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp,
        `updated_at` timestamp NOT NULL DEFAULT current_timestamp ON UPDATE CURRENT_TIMESTAMP,
        `admin_citizenid` varchar(50) NULL DEFAULT NULL,
        PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
    [[CREATE TABLE IF NOT EXISTS `zp_emails` (
        `id` int NOT NULL AUTO_INCREMENT,
        `institution` varchar(255) NOT NULL,
        `citizenid` varchar(100) NOT NULL,
        `subject` varchar(255) NOT NULL,
        `content` text NULL,
        `is_read` tinyint(1) NOT NULL DEFAULT 0,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY (`id`),
        INDEX `citizenid` (`citizenid`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
    [[CREATE TABLE IF NOT EXISTS `zp_inetmax_histories` (
        `id` int NOT NULL AUTO_INCREMENT,
        `citizenid` varchar(100) NOT NULL,
        `flag` varchar(10) NOT NULL,
        `label` varchar(100) NOT NULL,
        `total` int NOT NULL,
        `created_at` datetime NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY (`id`),
        INDEX `citizenid` (`citizenid`),
        INDEX `citizenid_flag` (`citizenid`, `flag`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
    [[CREATE TABLE IF NOT EXISTS `zp_loops_users` (
        `id` int NOT NULL AUTO_INCREMENT,
        `citizenid` varchar(100) NOT NULL,
        `username` varchar(50) NOT NULL,
        `avatar` varchar(255) NOT NULL DEFAULT 'https://i.ibb.co.com/F3w0F5L/default-avatar-1.png',
        `password` varchar(255) NOT NULL,
        `fullname` varchar(100) NOT NULL,
        `phone_number` varchar(20) NOT NULL,
        `cover` varchar(255) NOT NULL DEFAULT 'https://d25yuvogekh0nj.cloudfront.net/2019/08/Twitter-Banner-Size-Guide-blog-banner-1250x500.png',
        `bio` varchar(255) NOT NULL DEFAULT 'Welcome to loopsverse!',
        `is_verified` tinyint NOT NULL DEFAULT 0,
        `is_allow_message` tinyint NOT NULL DEFAULT 0,
        `join_at` datetime NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY (`id`),
        UNIQUE INDEX `unique_username` (`username`),
        INDEX `citizenid` (`citizenid`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
    [[CREATE TABLE IF NOT EXISTS `zp_news` (
        `id` int NOT NULL AUTO_INCREMENT,
        `citizenid` varchar(100) NOT NULL,
        `reporter` varchar(255) NOT NULL,
        `company` varchar(255) NOT NULL,
        `image` varchar(255) NOT NULL,
        `title` varchar(255) NOT NULL,
        `body` text NOT NULL,
        `stream` varchar(255) NULL DEFAULT NULL,
        `is_stream` tinyint(1) NOT NULL,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY (`id`),
        INDEX `is_stream` (`is_stream`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
    [[CREATE TABLE IF NOT EXISTS `zp_photos` (
        `id` int NOT NULL AUTO_INCREMENT,
        `citizenid` varchar(100) NULL DEFAULT NULL,
        `location` varchar(255) NOT NULL,
        `media` varchar(255) NOT NULL,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY (`id`),
        INDEX `citizenid` (`citizenid`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
    [[CREATE TABLE IF NOT EXISTS `zp_service_messages` (
        `id` int NOT NULL AUTO_INCREMENT,
        `citizenid` varchar(100) NOT NULL,
        `solved_by_citizenid` varchar(50) NULL DEFAULT NULL,
        `service` varchar(255) NOT NULL,
        `message` text NOT NULL,
        `created_at` datetime NOT NULL DEFAULT current_timestamp,
        `solved_reason` text NOT NULL,
        PRIMARY KEY (`id`),
        INDEX `service` (`service`),
        INDEX `service_solved_by_citizenid` (`solved_by_citizenid`, `service`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
    [[CREATE TABLE IF NOT EXISTS `zp_tweet_comments` (
        `id` int NOT NULL AUTO_INCREMENT,
        `tweetid` int NOT NULL,
        `comment` text NOT NULL,
        `loops_userid` int NOT NULL,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
    [[CREATE TABLE IF NOT EXISTS `zp_tweets` (
        `id` int NOT NULL AUTO_INCREMENT,
        `loops_userid` int NOT NULL,
        `tweet` text NOT NULL,
        `media` text NOT NULL,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp,
        PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
    [[CREATE TABLE IF NOT EXISTS `zp_users` (
        `name` varchar(100) NOT NULL,
        `citizenid` varchar(100) NOT NULL,
        `phone_number` varchar(20) NOT NULL,
        `created_at` timestamp NOT NULL DEFAULT current_timestamp,
        `last_seen` timestamp NOT NULL DEFAULT current_timestamp,
        `avatar` varchar(255) NOT NULL DEFAULT 'https://i.ibb.co.com/F3w0F5L/default-avatar-1.png',
        `unread_message_service` int NOT NULL DEFAULT 0,
        `unread_message` int NOT NULL DEFAULT 0,
        `wallpaper` varchar(255) NOT NULL DEFAULT 'https://i.ibb.co.com/pftZvpY/peakpx-1.jpg',
        `is_anonim` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
        `is_donot_disturb` tinyint(1) NOT NULL DEFAULT 0,
        `frame` varchar(50) NOT NULL DEFAULT '1.svg',
        `iban` varchar(20) NOT NULL,
        `active_loops_userid` int NOT NULL DEFAULT 0,
        `inetmax_balance` int NOT NULL DEFAULT 5000000,
        `phone_height` float NOT NULL DEFAULT 610,
        PRIMARY KEY (`citizenid`),
        INDEX `citizenid` (`citizenid`),
        INDEX `phone_number` (`phone_number`),
        INDEX `active_loops_userid` (`active_loops_userid`),
        INDEX `iban` (`iban`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]],
}

MySQL.ready(function()
    for i = 1, #SCHEMA do
        MySQL.query.await(SCHEMA[i])
    end
    print(('[z-phone] Database schema ready (%d tables, AutoInstallSchema)'):format(#SCHEMA))
end)
