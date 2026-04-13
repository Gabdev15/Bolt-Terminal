/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

BT = BT or {}

                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

--[[ URL du PDF des conditions d'utilisation affiché dans le terminal (http:// ou file://) ]]
BT.CGUPdfUrl = "https://docs.google.com/document/d/1-pLnzKsjvopjq7mhEEDXA0wSMJnJcFZ4/preview"

--[[ Admin rank ]]
BT.AdminRank = {
    ["superadmin"] = true,
    ["admin"] = true,
}

--[[ Language available fr, en ]]
BT.Lang = "fr"

--[[ Do you want to use custom notify ? ]]
BT.UseNotify = true

--[[ Do you want to use mysql ]]
BT.Mysql = false

--[[ Which job can interact with screen and modify terminal settings ]]
BT.FastFoodJob = setmetatable({}, {__index = function() return true end})

--[[ This feature permit to enable/disable the service of the cooker to permit to order on the terminal or not ]]
BT.ServiceSystem = false

--[[ Max menu per command ]]
BT.MaxMenu = 5

--[[ Max order by player (0 = illimité) ]]
BT.MaxOrder = 0

--[[ Price for the cooker for each vehicle ]]
BT.PriceForCooker = {
    ["prius"] = 700,
}

-- [[ Base price without options ]]
BT.BasePriceWithoutIngredients = 0

--[[ Max price per vehicle for the terminal ]]
BT.MaxPrice = {
    ["prius"] = 700,
}

--[[ Max quantity per vehicle for the terminal ]]
BT.MaxQuantity = {
    ["prius"] = 5,
}

--[[ Currencies available €, $ ]]
BT.Currency = "$"
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

--[[ You can add more currency here ]]
BT.Currencies = {
    ["$"] = function(money)
        return "$"..money
    end,
    ["€"] = function(money)
        return money.."€"
    end
}

--[[ All colors used on the addon ]]
BT.Colors = {
    ["white"] = Color(248, 247, 252),
    ["white100"] = Color(248, 247, 252, 150),
    ["grey"] = Color(51, 51, 55, 80),
    ["grey2"] = Color(51, 51, 55, 225),
    ["grey3"] = Color(51, 51, 55, 150),
    ["grey4"] = Color(51, 51, 55, 50),
    ["black25"] = Color(51, 51, 55, 25),
    ["black50"] = Color(51, 51, 55, 50),
    ["black0255"] = Color(0, 0, 0, 240),
    ["black200"] = Color(51, 51, 55, 220),
    ["black2"] = Color(0, 0, 0),
    ["black25200"] = Color(25, 25, 25, 200),
    ["black"] = Color(51, 51, 55),
    ["purple"] = Color(81, 56, 237),
    ["black18220"] = Color(18, 30, 42, 220),
    ["black18100"] = Color(18, 30, 42, 100),
    ["white246"] = Color(246, 237, 232),
    ["white246200"] = Color(246, 237, 232, 200),
    ["white246100"] = Color(246, 237, 232, 120),
    ["white255100"] = Color(255, 255, 255, 100),
    ["white25510"] = Color(255, 255, 255, 10),
    ["white234"] = Color(234, 216, 206),
    ["orange100"] = Color(50, 187, 120, 100),
    ["orange2"] = Color(50, 187, 120, 200),
    ["orange"] = Color(50, 187, 120),
    ["red"] = Color(255, 50, 109, 200),
    ["red2"] = Color(255, 30, 30, 200),
    ["red3"] = Color(255, 30, 30, 150),
    ["red4"] = Color(255, 30, 30, 255),
    ["red5"] = Color(255, 30, 30, 50),
    ["green"] = Color(125,247,109,200),
    ["green2"] = Color(125,247,109,255),
    ["green3"] = Color(125,247,109,50),
    ["grilledSteak"] = Color(100,100,100),
} 
