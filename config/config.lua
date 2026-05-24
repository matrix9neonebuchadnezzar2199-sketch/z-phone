Config = {}

Config.Debug = false
Config.Core = "QBX" -- QB,ESX or QBX
Config.OpenPhone = 'M'
Config.RepeatTimeout = 3000
Config.CallRepeats = 5

Config.Locale = "ja"

Config.App = {
    InetMax = {
        Name = "InetMax",
        IsUseInetMax = true,
        TopupRate = {
            InKB = 1000000, -- 1 GB
            Price = 100
        },
        InetMaxUsage = {
            -- IN KB
            MessageSend = math.random(10000, 15000),
            LoopsPostTweet = math.random(50000, 150000),
            LoopsPostComment = math.random(10000, 30000),
            AdsPost = math.random(50000, 150000),
            PhoneCall = math.random(300000, 800000),
            ServicesMessage = math.random(5000, 10000),
            BankCheckTransferReceiver = math.random(5000, 15000),
            BankTransfer = math.random(100000, 200000),
        },
        SocietySeller = "government"
    },
    Phone = {
        Name = "Phone"
    },
    Ads = {
        Name = "Ads"
    },
    Loops = {
        Name = "Loops"
    },
    Services = {
        Name = "Services"
    },
    Message = {
        Name = "Message"
    },
    Wallet = {
        Name = "Wallet",
        MinTransfer = 20000,
    },
}

Config.MsgNotEnoughInternetData = L("msg_not_enough_inet")
Config.MsgSignalZone = L("msg_no_signal")

Config.Signal = {
    IsUse = false,
    DefaultSignalZones = "FULL_SIGNAL",
    Zones = {
        ["FULL_SIGNAL"] = {
            CenterCoords = vec3(49.58, -1560.84, 29.38),
            Radius = 3,
            ChanceSignal = 1 -- MAX = 1
        },
        ["0_SIGNAL_1"] = {
            CenterCoords = vec3(47.71, -1536.74, 29.29),
            Radius = 3,
            ChanceSignal = 0.0
        },
        ["1_SIGNAL_1"] = {
            CenterCoords = vec3(42.48, -1543.57, 29.27),
            Radius = 3,
            ChanceSignal = 0.25
        },
        ["2_SIGNAL_1"] = {
            CenterCoords = vec3(37.75, -1548.99, 29.28),
            Radius = 3,
            ChanceSignal = 0.5
        },
        ["3_SIGNAL_1"] = {
            CenterCoords = vec3(43.09, -1555.95, 29.28),
            Radius = 3,
            ChanceSignal = 0.75
        }
    }
}

Config.Services = {
    goverment = {
        job = "goverment",
        name = "市政府",
        type = "General",
        logo = "https://raw.githubusercontent.com/alfaben12/kmrp-assets/main/logo/business/goverment.png",
    },
    government = {
        job = "government",
        name = "市政府",
        type = "General",
        logo = "https://raw.githubusercontent.com/alfaben12/kmrp-assets/main/logo/business/government.png",
    },
    police = {
        job = "police",
        name = "警察",
        type = "General",
        logo = "https://raw.githubusercontent.com/alfaben12/kmrp-assets/main/logo/business/police.png",
    },
    ambulance = {
        job = "ambulance",
        name = "救急",
        type = "Health",
        logo = "https://raw.githubusercontent.com/alfaben12/kmrp-assets/main/logo/business/ambulance.png",
    },
    realestate = {
        job = "realestate",
        name = "不動産",
        type = "Property",
        logo = "https://raw.githubusercontent.com/alfaben12/kmrp-assets/main/logo/business/realestate.png",
    },
    taxi = {
        job = "taxi",
        name = "タクシー",
        type = "Transport",
        logo = "https://raw.githubusercontent.com/alfaben12/kmrp-assets/main/logo/business/taxi.png",
    },
    burgershot = {
        job = "burgershot",
        name = "バーガーショット",
        type = "Food",
        logo = "https://raw.githubusercontent.com/alfaben12/kmrp-assets/main/logo/business/burgershot.png",
    },
    kfc = {
        job = "kfc",
        name = "KFC",
        type = "Food",
        logo = "https://raw.githubusercontent.com/alfaben12/kmrp-assets/main/logo/business/kfc.png",
    },
}

Config.DefaultServiceLogo = "https://raw.githubusercontent.com/alfaben12/kmrp-assets/main/logo/business/goverment.png"