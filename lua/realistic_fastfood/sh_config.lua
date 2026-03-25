/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

RFS = RFS or {}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

--[[ Admin rank ]]
RFS.AdminRank = {
    ["superadmin"] = true,
    ["admin"] = false,
}

--[[ Language available fr, en ]]
RFS.Lang = "fr"

--[[ Do you want to use custom notify ? ]]
RFS.UseNotify = true

--[[ Do you want to use mysql ]]
RFS.Mysql = false

--[[ Which job can interact with screen and modify terminal settings ]]
RFS.FastFoodJob = {
    ["Fast Food Cooker"] = true,
}

--[[ Which job is considered to not be able to buy food on the distributor ]]
RFS.FastFoodJobDistributor = {
    ["Fast Food Cooker"] = true,
}

--[[ Does it give health or food ]]
RFS.GiveHealth = false
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

--[[ Give swep when he try to eat something ]]
RFS.GiveSwep = true

--[[ Enable this feature permit to put multiple ingredients without need to open the box again (not for all ingredients) ]]
RFS.MultipleAlimentWithSwep = false

--[[ This feature permit to enable/disable the service of the cooker to permit to order on the terminal or not ]]
RFS.ServiceSystem = false

--[[ Amount of food or health that give entities ]]
RFS.AmountFood = {
    --[[ Amount of swep ]]
    ["rfs_hand_burger"] = 50, 
    ["rfs_cup"] = 15,
    ["rfs_fries"] = 25,

    --[[ Amount of entities ]]
    ["rfs_burger"] = 50, 
    ["rfs_sodacup"] = 15,
    ["rfs_friesbag"] = 25,
}

--[[ Max bag by player ]]
RFS.MaxBagByPlayer = 2

--[[ Max burger size (10 = 10 condiments) ]]
RFS.MaxBurgerSize = 15

--[[ Time cooking of the steak ]]
RFS.SteakTime = 10

--[[ Time to wait before the steak carbonise ]]
RFS.CarboniseTime = 10

--[[ Disable sound when eating food ]]
RFS.DisableSoundWhenEating = true

--[[ Max menu per command ]]
RFS.MaxMenu = 5

--[[ Max order by player ]]
RFS.MaxOrder = 1

--[[ Max inventories items ]]
RFS.MaxInventories = 12

--[[ Does you accept player to do mission ]]
RFS.MissionAccepted = true
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2

--[[ Max and min time for a mission appear]]
RFS.MaxMinNewMissionTime = {2, 5}

--[[ 
    class --> You can only put rfs_burger, rfs_friesbag, rfs_sodacup.
    price --> Price earn by the player if he complete perfectly the command.
    maxTime --> Min and Max time for the command.
    sizeIcon --> Size of the icon when we create the renderTarget.
    returnValue --> Multiple models for the dModel draw on the mission.
]]
RFS.Missions = {
    {
        ["class"] = "rfs_burger",
        ["price"] = 1000,
        ["maxTime"] = {180, 220},
        ["sizeIcon"] = {500, 500}, -- You don't need to touch to this params (you can increase if you want a better quality)
        ["ingredientsTable"] = { --[[ Start by the bottom and finish by the top ]]
            "models/realistic_food_system/burger_bottom_bun.mdl",
            "models/realistic_food_system/burger_steak.mdl",
            "models/realistic_food_system/burger_cheese.mdl",
            "models/realistic_food_system/burger_onion.mdl",
            "models/realistic_food_system/burger_tomato.mdl",
            "models/realistic_food_system/burger_salad.mdl",
            "models/realistic_food_system/burger_top_bun.mdl",
        },
    },
    {
        ["class"] = "rfs_burger",
        ["price"] = 2400,
        ["maxTime"] = {180, 220},
        ["sizeIcon"] = {500, 500}, -- You don't need to touch to this params (you can increase if you want a better quality)
        ["ingredientsTable"] = { --[[ Start by the bottom and finish by the top ]]
            "models/realistic_food_system/burger_bottom_bun.mdl",
            "models/realistic_food_system/burger_steak.mdl",
            "models/realistic_food_system/burger_cheese.mdl",
            "models/realistic_food_system/burger_bottom_bun.mdl",
            "models/realistic_food_system/burger_steak.mdl",
            "models/realistic_food_system/burger_cheese.mdl",
            "models/realistic_food_system/burger_tomato.mdl",
            "models/realistic_food_system/burger_onion.mdl",
            "models/realistic_food_system/burger_salad.mdl",
            "models/realistic_food_system/burger_top_bun.mdl",
        },
    },
    {
        ["class"] = "rfs_friesbag",
        ["price"] = 500,
        ["maxTime"] = {20, 60}, --[[ Random time maximum to cook ]]
        ["sizeIcon"] = {500, 500}, -- You don't need to touch to this params (you can increase if you want a better quality)
        ["ingredientsTable"] = { --[[ Start by the bottom and finish by the top ]]
            "models/realistic_food_system/fries_bag.mdl",
        },
        ["check"] = function(ent)
            if ent:GetBodygroup(1) != 1 then return false end

            return true
        end,
        ["func"] = function(ent)
            ent:SetBodygroup(1, 1)
        end,
    },
    {
        ["class"] = "rfs_sodacup",
        ["price"] = 500,
        ["maxTime"] = {20, 60}, --[[ Random time maximum to cook ]]
        ["sizeIcon"] = {500, 500}, -- You don't need to touch to this params (you can increase if you want a better quality)
        ["ingredientsTable"] = { --[[ Start by the bottom and finish by the top ]]
            "models/realistic_food_system/cup.mdl",
        },
        ["check"] = function(ent)
            if ent:GetBodygroup(1) == 0 then return false end

            return true
        end,
        ["func"] = function(ent)
            ent:SetBodygroup(1, 1)
        end,
    },
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

--[[ Price for the cooker for each ingredients ]] 
RFS.PriceForCooker = {
    ["fries"] = 100,
    ["tomato"] = 100,
    ["salad"] = 100,
    ["onion"] = 100,
    ["cheese"] = 100,
    ["fries"] = 100,
    ["steak"] = 100,
    ["soda"] = 50,
    ["bun"] = 50,
    ["bun2"] = 50,
    ["friesCup"] = 50,
}

-- [[ Base price for the burger without ingredients ]]
RFS.BasePriceWithoutIngredients = 200

--[[ Max price per ingredients for the terminal ]]
RFS.MaxPrice = {
    ["fries"] = 100,
    ["tomato"] = 100,
    ["salad"] = 100,
    ["onion"] = 100,
    ["cheese"] = 100,
    ["fries"] = 100,
    ["steak"] = 100,
    ["soda"] = 50,
}

--[[ Max quantity per ingredients for the terminal ]]
RFS.MaxQuantity = {
    ["fries"] = 3,
    ["tomato"] = 3,
    ["salad"] = 3,
    ["onion"] = 3,
    ["cheese"] = 3,
    ["fries"] = 3,
    ["steak"] = 3,
    ["soda"] = 1,
}

--[[ Set the amount food that give product for your burger ]]
RFS.FoodPerModelBurger = {
    ["models/realistic_food_system/burger_top_bun.mdl"] = 5,
    ["models/realistic_food_system/burger_cheese.mdl"] = 5,
    ["models/realistic_food_system/burger_bottom_bun.mdl"] = 5,
    ["models/realistic_food_system/burger_onion.mdl"] = 5,
    ["models/realistic_food_system/burger_salad.mdl"] = 5,
    ["models/realistic_food_system/burger_steak.mdl"] = 5,
}

--[[ Currencies available €, $ ]]
RFS.Currency = "$"
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

--[[ You can add more currency here ]]
RFS.Currencies = {
    ["$"] = function(money)
        return "$"..money
    end,
    ["€"] = function(money)
        return money.."€"
    end
}

--[[ All colors used on the addon ]]
RFS.Colors = {
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
