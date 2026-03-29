/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

BT = BT or {}

--[[ Vector and Angle chache ]]
BT.Constants = {
    ["vector0"] = Vector(0, 0, 0),
    ["vector100"] = Vector(0, 0, 100),
    ["vector75"] = Vector(0, 0, 75),
    ["vector10"] = Vector(0, 0, 10),
    ["vector20"] = Vector(0, 0, 20),
    ["vector2010"] = Vector(20, 0, 10),
    ["vector101022"] = Vector(10, 10, 22),
    ["vector553"] = Vector(5, -5, 3),
    ["vector020"] = Vector(0, 20, 0),
    ["vector22"] = Vector(-2, 0, 2.5),
    ["vector111"] = Vector(1, 1, 1),
    ["vector175"] = Vector(0, 0, 1.75),
    ["vector20010"] = Vector(-20, 0, 10),
    ["vector010"] = Vector(0, -1, 0),
    ["vector10010"] = Vector(10, 0, 10),
    ["vector100102"] = Vector(-10, 0, 10),
    ["vector550"] = Vector(5, -5, 0),
    ["angle0"] = Angle(0, 0, 0),
    ["angle090"] = Angle(0, -90, 0),
    ["angle60"] = Angle(-60, 0, -0),
    ["angle0902"] = Angle(0, 90, 0),
    ["angle025"] = Angle(0, 0, -25),
}

--[[ All status of customers ]]
BT.Status = {
    "smileyAngry",
    "smileySad",
    "smileyHappy",
}

--[[ Convert a model to a string used on my function BT.GetSentence ]]
BT.ModelsToName = {
    ["models/bolt_terminal/burger_top_bun.mdl"] = "bun",
    ["models/bolt_terminal/burger_salad.mdl"] = "salad",
    ["models/bolt_terminal/burger_tomato.mdl"] = "tomato",
    ["models/bolt_terminal/burger_onion.mdl"] = "onion",
    ["models/bolt_terminal/burger_cheese.mdl"] = "cheese",
    ["models/bolt_terminal/burger_steak.mdl"] = "steak",
    ["models/bolt_terminal/burger_bottom_bun.mdl"] = "bun2",
    ["models/bolt_terminal/burger_bottom_bun.mdl"] = "bun2",
    ["models/bolt_terminal/fries_bag.mdl"] = "fries",
    ["models/bolt_terminal/cup.mdl"] = "soda",
}

--[[ All tray position ]]
BT.TrayPosition = {
    {
        ["pos"] = Vector(-5, -10, 0),
        ["ang"] = Angle(0, -90, 0),
    },
    {
        ["pos"] = Vector(-5, 0, 0),
        ["ang"] = Angle(0, -90, 0),
    },
    {
        ["pos"] = Vector(-5, 10, 0),
        ["ang"] = Angle(0, -90, 0),
    },
    {
        ["pos"] = Vector(5, -10, 0),
        ["ang"] = Angle(0, -90, 0),
    },
    {
        ["pos"] = Vector(5, 0, 0),
        ["ang"] = Angle(0, -90, 0),
    },
    {
        ["pos"] = Vector(5, 10, 0),
        ["ang"] = Angle(0, -90, 0),
    },
}

--[[ Allowed ent and function to detect if the entity can be place ]]
BT.TrayAllowedEnt = {
    ["bt_burger"] = function(ent)
        local parent = ent:GetParent()
        if IsValid(parent) then return end

        return true
    end,
    ["bt_sodacup"] = function(ent)
        local color = BT.GetNWVariables("bt_soda_color", ent)
        if not color then return end

        return true
    end,
    ["bt_friesbag"] = function(ent)
        if ent:GetBodygroup(1) != 1 then return end

        return true
    end,
}

--[[ Ajust some position on the tray ]]
BT.TrayCustomPosition = {
    ["bt_burger"] = Vector(0, 0, -1.5),
}

--[[
    mat --> path of the material.
    size --> size of the material.
    posId --> Use a posId different of the key to do a stack aspect.
    uniqueName --> Used for the order and the translation.
]]
BT.BurgerElements = {
    {
        ["mat"] = BT.Materials["prius"],
        ["size"] = {160, 105},
        ["posId"] = 1,
        ["changeQuantity"] = true,
        ["uniqueName"] = "prius",
        ["canModify"] = true,
    },
}

--[[
    uniqueName --> Used for identify the object.
    class --> class of the entity.
    price --> price of the object.
    sizeIcon --> Size of the render target.
    returnValue --> Models used for the object "table for burger".
    func --> func to set some params on the render target.
]]

BT.Distributor = {
    ["fries01"] = {
        ["uniqueName"] = "fries01",
        ["class"] = "bt_friesbag",
        ["price"] = 500,
        ["sizeIcon"] = {500, 500},
        ["ingredientsTable"] = {
            "models/bolt_terminal/fries_bag.mdl",
        },
        ["func"] = function(ent, dModel)
            if CLIENT then
                if not IsValid(ent) then return end

                dModel:SetFOV(50)
                ent:SetBodygroup(1, 1)
            end
        end,
    },
    ["soda01"] = {
        ["uniqueName"] = "soda01",
        ["class"] = "bt_sodacup",
        ["price"] = 500,
        ["sizeIcon"] = {500, 500},
        ["ingredientsTable"] = {
            "models/bolt_terminal/cup.mdl",
            Color(255, 153, 0),
        },
        ["func"] = function(ent, dModel)
            if CLIENT then
                if not IsValid(ent) then return end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2
    
                ent:SetBodygroup(1, 5)

                local vectorColor = Vector(1, 0.6, 0, 1)
                vectorColor:Normalize()

                ent.fluidcolor = vectorColor
    
                local getCamPos = dModel:GetCamPos()
                getCamPos.z = 15
    
                dModel:SetFOV(40)
                dModel:SetCamPos(getCamPos)
            end
        end,
    },
    ["burger01"] = {
        ["uniqueName"] = "burger01",
        ["class"] = "bt_burger",
        ["price"] = 500,
        ["sizeIcon"] = {500, 500},
        ["amountFood"] = 40,
        ["ingredientsTable"] = {
            "models/bolt_terminal/burger_bottom_bun.mdl",
            "models/bolt_terminal/burger_steak.mdl",
            "models/bolt_terminal/burger_cheese.mdl",
            "models/bolt_terminal/burger_onion.mdl",
            "models/bolt_terminal/burger_tomato.mdl",
            "models/bolt_terminal/burger_salad.mdl",
            "models/bolt_terminal/burger_top_bun.mdl",
        },
    },
}

BT.BaseBurger = {
    "models/bolt_terminal/burger_bottom_bun.mdl",
    "models/bolt_terminal/burger_steak.mdl",
    "models/bolt_terminal/burger_cheese.mdl",
    "models/bolt_terminal/burger_onion.mdl",
    "models/bolt_terminal/burger_tomato.mdl",
    "models/bolt_terminal/burger_salad.mdl",
    "models/bolt_terminal/burger_top_bun.mdl",
}

--[[
    get --> function to get the correct table to save into the inventories.
    create --> function to re create the entities with good parameters.
]]
BT.Inventories = {
    ["bt_burger"] = {
        ["get"] = function(ent)
            ent.BT = ent.BT or {}
            ent.BT["condiments"] = ent.BT["condiments"] or {}        
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f
            
            local returnTable = {
                ["class"] = ent:GetClass(),
                ["ingredientsTable"] = ent.BT["condiments"],
                ["distributor"] = ent.BT["distributor"],
                ["amountFood"] = (ent.BT["amountFood"] or 0),
            }
    
            return returnTable
        end,
        ["create"] = function(bag, itemTable, distributor, allTable)
            local burger = BT.Cooking.CreateBurger(nil, nil, bag:GetPos(), BT.Constants["angle0"], true, nil, itemTable)
            burger:SetPos(bag:GetPos() + BT.Constants["vector10"])
            burger:SetAngles(BT.Constants["angle090"])
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

            burger.BT = burger.BT or {}
            burger.BT["cooldownToEnter"] = CurTime() + 3

            burger.BT["amountFood"] = (allTable["amountFood"] or 0)

            return burger
        end,
    },
    ["bt_friesbag"] = {
        ["get"] = function(ent, distributor)
            if ent:GetBodygroup(1) != 1 then return end
    
            local returnTable = {
                ["class"] = ent:GetClass(),
                ["ingredientsTable"] = {"models/bolt_terminal/fries_bag.mdl"},
                ["distributor"] = ent.BT["distributor"],
            }
    
            return returnTable
        end,
        ["create"] = function(bag, itemTable, distributor)            
            local friesBag = ents.Create("bt_friesbag")
            friesBag:SetPos(bag:GetPos() + BT.Constants["vector20"])
            friesBag:SetAngles(BT.Constants["angle090"])
            friesBag:Spawn()
            friesBag:SetBodygroup(1, 1)

            friesBag.BT = friesBag.BT or {}
            friesBag.BT["cooldownToEnter"] = CurTime() + 3

            return friesBag
        end,
    },
    ["bt_sodacup"] = {
        ["get"] = function(ent, distributor)
            local color = BT.GetNWVariables("bt_soda_color", ent)
            if not color then return end
    
            color.a = 255
            
            local returnTable = {
                ["class"] = ent:GetClass(),
                ["ingredientsTable"] = {"models/bolt_terminal/cup.mdl", color},
                ["distributor"] = ent.BT["distributor"],
            }
            
            return returnTable
        end,
        ["create"] = function(bag, itemTable, distributor)
            local color = itemTable[2]
            if not IsColor(color) then color = BT.Colors["white"] end

            local sodaCup = ents.Create("bt_sodacup")
            sodaCup:SetPos(bag:GetPos() + BT.Constants["vector10"])
            sodaCup:SetAngles(BT.Constants["angle090"])
            sodaCup:Spawn()
            sodaCup:SetBodygroup(1, 5)
            sodaCup:SetColor(color)

            sodaCup.BT = sodaCup.BT or {}
            sodaCup.BT["cooldownToEnter"] = CurTime() + 3
            sodaCup.BT["distributor"] = distributor

            BT.SetNWVariable("bt_soda_color", color, sodaCup, true, nil, true)

            return sodaCup
        end,
    },
}

BT.SpaceCondiment = {
    ["models/bolt_terminal/burger_top_bun.mdl"] = Vector(0, 0, 2),
    ["models/bolt_terminal/burger_salad.mdl"] = Vector(0, 0, 0.5),
    ["models/bolt_terminal/burger_tomato.mdl"] = Vector(0, 0, 0.6),
    ["models/bolt_terminal/burger_onion.mdl"] = Vector(0, 0, 0.6),
    ["models/bolt_terminal/burger_cheese.mdl"] = Vector(0, 0, 0.08),
    ["models/bolt_terminal/burger_bottom_bun.mdl"] = Vector(0, 0, 1.7),
    ["models/bolt_terminal/burger_steak.mdl"] = Vector(0, 0, 1.55),
}

--[[
    key --> model of the condiment
    func --> function of the condiment
]]
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46

BT.ComposeBurger = {
    ["models/bolt_terminal/burger_bottom_bun.mdl"] = {
        ["func"] = function(plank)
            if not IsValid(plank.burger) then
                BT.Cooking.CreateBurger(plank)
            end
        end
    },
    ["models/bolt_terminal/burger_top_bun.mdl"] = {
        ["func"] = function(plank)
            timer.Simple(0.5, function()
                BT.Cooking.FinishBurger(plank)
            end)
        end
    },
}

--[[
    mat --> path of the material.
    color --> backGround color of the soda brand.
    uniqueName --> uniqueName of the soda.
]]
BT.SodaList = {
    {
        ["mat"] = BT.Materials["peache"],
        ["color"] = Color(255, 182, 46, 200),
        ["uniqueName"] = "peache",
    },
    {
        ["mat"] = BT.Materials["lime"],
        ["color"] = Color(46, 204, 113, 200),
        ["uniqueName"] = "limea",
    },
    {
        ["mat"] = BT.Materials["orange"],
        ["color"] = Color(243, 156, 18, 200),
        ["uniqueName"] = "orangejuice",
    },
    {
        ["mat"] = BT.Materials["cherries"],
        ["color"] = Color(231, 76, 60, 200),
        ["uniqueName"] = "cherry",
    },
}

--[[
    pos --> Position of the steak.
    ang --> Angle of the steak.
]]
BT.SteakPosition = {
    {
        ["pos"] = Vector(18,-7,12.5),
        ["ang"] = Angle(0,-90,0),
    },
    {
        ["pos"] = Vector(5,-7,12.5),
        ["ang"] = Angle(0,-90,0),
    },
    {
        ["pos"] = Vector(-8,-7,12.5),
        ["ang"] = Angle(0,-90,0),
    },
    {
        ["pos"] = Vector(-20,-7,12.5),
        ["ang"] = Angle(0,-90,0),
    },
    {
        ["pos"] = Vector(18,6,12.5),
        ["ang"] = Angle(0,-90,0),
    },
    {
        ["pos"] = Vector(5,6,12.5),
        ["ang"] = Angle(0,-90,0),
    },
    {
        ["pos"] = Vector(-8,6,12.5),
        ["ang"] = Angle(0,-90,0),
    },
    {
        ["pos"] = Vector(-20,6,12.5),
        ["ang"] = Angle(0,-90,0),
    },
}

--[[
    mat --> path of the material.
    key --> uniqueKey linked of a language key.
    action --> Clientside and Serverside action.

    clienSideModel {
        mdl --> model of the clientside model.
        filter --> where clientside model can be place.
        func --> function to know if it's possible to place the model clientside.
    }
]]
BT.CookingElement = {
    ["bun"] = {
        ["forSale"] = true,
        ["mat"] = BT.Materials["bun"],
        ["desc"] = "bunDesc",
        ["multiple"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["bt_plank_burger"] = true,
            },
            ["mdl"] = "models/bolt_terminal/burger_top_bun.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if RFSClientside.parentCase == ent then return end

                local class = ent:GetClass()
                if class == "bt_condiment_container" then
                    
                    RFSClientside:SetPos(ent:LocalToWorld(BT.Constants["vector2010"]))
                elseif class == "bt_plank_burger" then
                    local placeToSet = BT.GetSpaceBurger(ent, true)
                    if not isvector(placeToSet) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(placeToSet))
                end

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                BT.Cooking.AddBurgerCondiment(ent, "models/bolt_terminal/burger_top_bun.mdl")
            end
        end,
    },
    ["steak"] = {
        ["forSale"] = true,
        ["mat"] = BT.Materials["steak"],
        ["desc"] = "steakDesc",
        ["multiple"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["bt_grill"] = true,
                ["bt_condiment_container"] = true,
                ["bt_plank_burger"] = true,
            },
            ["mdl"] = "models/bolt_terminal/burger_steak.mdl",
            ["func"] = function(ent, steak)
                if not IsValid(RFSClientside) then return end
                if RFSClientside.parentCase == ent then return end
     
                local class = ent:GetClass()
                local steakTable = nil
                
                if IsValid(steak) && steak:GetClass() == "bt_steak" then
                    steakTable = BT.Cooking.GetTableBySteakId(steak:GetParent(), steak:EntIndex())
                end
                
                if class == "bt_condiment_container" && not steakTable then
                    if ent:GetBodygroup(5) >= (ent:GetBodygroupCount(5)-1) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(BT.Constants["vector20010"]))
                    RFSClientside:SetAngles(ent:LocalToWorldAngles(BT.Constants["angle60"]))
                    
                    return true
                elseif class == "bt_grill" && not steakTable then
                    
                    local steakTable = BT.SteakPosition[BT.Cooking.GetSteakPlace(ent)]
                    if not steakTable or not isvector(steakTable["pos"]) then return false end
                    
                    RFSClientside:SetPos(ent:LocalToWorld(steakTable["pos"]))
                    RFSClientside:SetAngles(ent:LocalToWorldAngles(steakTable["ang"]))
                    
                    return true
                elseif class == "bt_plank_burger" && steakTable then
                    if not steakTable["flipped"] then return end
                    
                    local placeToSet = BT.GetSpaceBurger(ent)
                    if not isvector(placeToSet) then return false end
                    if not BT.Cooking.CheckMaxSizeBurger(ent) then return false end
                    if ent:GetColor() == BT.Colors["black2"] then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(placeToSet))

                    return true
                end
            end,
            ["canInteract"] = function(ent)
                if ent:GetClass() == "bt_condiment_container" then
                    return (ent:GetBodygroup(5) > 0)
                end

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                local entClass = ent:GetClass()
                local linkedClass = linkedEnt:GetClass()

                if (entClass == "bt_condiment_container" or entClass == "bt_grill") && linkedClass != "bt_box" then
                    local removed = BT.Cooking.ChangeQuantity(linkedEnt, "steak", 5, -1)
                    if removed then
                        BT.Cooking.AddSteak(ent)
                    end
                else
                    if entClass == "bt_condiment_container" then
                        
                        BT.Cooking.ChangeQuantity(ent, "steak", 5, 1)
                    elseif entClass == "bt_grill" then

                        BT.Cooking.AddSteak(ent)
                    elseif entClass == "bt_plank_burger" then
                        if not IsValid(linkedEnt) or linkedClass != "bt_steak" then return end
                        if linkedEnt.BT["carbonised"] then return end
                        
                        BT.Cooking.AddBurgerCondiment(ent, "models/bolt_terminal/burger_steak.mdl", linkedEnt:GetColor())
                        linkedEnt:Remove()
                    end
                end
            end
        end,
    },
    ["onion"] = {
        ["forSale"] = true,
        ["mat"] = BT.Materials["onion"],
        ["desc"] = "onionsDesc",
        ["clientSideModel"] = {
            ["filter"] = {
                ["bt_plank"] = true,
            },
            ["mdl"] = "models/bolt_terminal/onion.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if ent:GetBodygroup(2) != 0 then return false end

                RFSClientside:SetPos(ent:LocalToWorld(BT.Constants["vector010"]))

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                if ent:GetBodygroup(2) != 0 then return end

                ent:SetSkin(1)
                ent:ResetSequence("cutting")
                ent:SetSequence("cutting")

                ent.BT = ent.BT or {}
                ent.BT["entCutted"] = true
            end
        end,
    },
    ["salad"] = {
        ["forSale"] = true,
        ["mat"] = BT.Materials["lettuce"],
        ["desc"] = "saladDesc",
        ["multiple"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["bt_condiment_container"] = true,
                ["bt_plank_burger"] = true,
            },
            ["mdl"] = "models/bolt_terminal/burger_salad.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if RFSClientside.parentCase == ent then return end
                
                if ent:GetClass() == "bt_condiment_container" then
                    if ent:GetBodygroup(2) >= (ent:GetBodygroupCount(2)-1) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(BT.Constants["vector10010"]))
                elseif ent:GetClass() == "bt_plank_burger" then
                    if not BT.Cooking.CheckMaxSizeBurger(ent) then return false end

                    local placeToSet = BT.GetSpaceBurger(ent)
                    if not isvector(placeToSet) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(placeToSet))
                end

                return true
            end,
            ["canInteract"] = function(ent)
                if ent:GetClass() == "bt_condiment_container" then
                    return (ent:GetBodygroup(2) > 0)
                end

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                if linkedEnt:GetClass() == "bt_condiment_container" then
                    local removed = BT.Cooking.ChangeQuantity(linkedEnt, "salad", 2, -1)
                    if removed then
                        BT.Cooking.AddBurgerCondiment(ent, "models/bolt_terminal/burger_salad.mdl")
                    end
                else
                    if ent:GetClass() == "bt_condiment_container" then

                        BT.Cooking.ChangeQuantity(ent, "salad", 2, 1)
                    elseif ent:GetClass() == "bt_plank_burger" then

                        BT.Cooking.AddBurgerCondiment(ent, "models/bolt_terminal/burger_salad.mdl")
                    end
                end
            end
        end,
    },
    ["tomato"] = {
        ["forSale"] = true,
        ["mat"] = BT.Materials["tomato"],
        ["desc"] = "tomatoDesc",
        ["clientSideModel"] = {
            ["filter"] = {
                ["bt_plank"] = true,
            },
            ["mdl"] = "models/bolt_terminal/tomato.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if ent:GetBodygroup(2) != 0 then return false end

                RFSClientside:SetPos(ent:LocalToWorld(BT.Constants["vector010"]))

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                if ent:GetBodygroup(2) != 0 then return end

                ent:SetSkin(2)
                ent:ResetSequence("cutting")
                ent:SetSequence("cutting")

                ent.BT = ent.BT or {}
                ent.BT["entCutted"] = true
            end
        end,
    },
    ["cheese"] = {
        ["forSale"] = true,
        ["mat"] = BT.Materials["cheese"],
        ["desc"] = "cheeseDesc",
        ["multiple"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["bt_condiment_container"] = true,
                ["bt_plank_burger"] = true,
            },
            ["mdl"] = "models/bolt_terminal/burger_cheese.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if RFSClientside.parentCase == ent then return end

                if ent:GetClass() == "bt_condiment_container" then
                    if ent:GetBodygroup(4) >= (ent:GetBodygroupCount(4)-1) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(BT.Constants["vector100102"]))
                elseif ent:GetClass() == "bt_plank_burger" then
                    if not BT.Cooking.CheckMaxSizeBurger(ent) then return false end

                    local placeToSet = BT.GetSpaceBurger(ent)
                    if not isvector(placeToSet) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(placeToSet))
                end
                
                return true
            end,
            ["canInteract"] = function(ent)
                if ent:GetClass() == "bt_condiment_container" then
                    return (ent:GetBodygroup(4) > 0)
                end

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                if linkedEnt:GetClass() == "bt_condiment_container" then
                    local removed = BT.Cooking.ChangeQuantity(linkedEnt, "cheese", 4, -1)
                    if removed then
                        BT.Cooking.AddBurgerCondiment(ent, "models/bolt_terminal/burger_cheese.mdl")
                    end
                else
                    if ent:GetClass() == "bt_condiment_container" then

                        BT.Cooking.ChangeQuantity(ent, "cheese", 4, 1)
                    elseif ent:GetClass() == "bt_plank_burger" then

                        BT.Cooking.AddBurgerCondiment(ent, "models/bolt_terminal/burger_cheese.mdl")
                    end
                end
            end
        end,
    },
    ["bun2"] = {
        ["forSale"] = true,
        ["mat"] = BT.Materials["bun2"],
        ["desc"] = "bun2Desc",
        ["multiple"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["bt_plank_burger"] = true,
            },
            ["mdl"] = "models/bolt_terminal/burger_bottom_bun.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end

                if ent:GetClass() == "bt_condiment_container" then
                    
                    RFSClientside:SetPos(ent:LocalToWorld(BT.Constants["vector2010"]))
                elseif ent:GetClass() == "bt_plank_burger" then
                    if not BT.Cooking.CheckMaxSizeBurger(ent) then return false end

                    local placeToSet = BT.GetSpaceBurger(ent)
                    if not isvector(placeToSet) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(placeToSet))
                end

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                BT.Cooking.AddBurgerCondiment(ent, "models/bolt_terminal/burger_bottom_bun.mdl")
            end
        end,
    },
    ["fries"] = {
        ["forSale"] = true,
        ["mat"] = BT.Materials["fries"],
        ["desc"] = "friesDesc",
        ["multiple"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["bt_fryer"] = true,
            },
            ["mdl"] = "models/bolt_terminal/fries.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if ent:GetSkin() == 1 or ent:GetBodygroup(1) != 0 then return false end

                RFSClientside:SetPos(ent:LocalToWorld(BT.Constants["vector10"]))
                RFSClientside:SetAngles(ent:LocalToWorldAngles(BT.Constants["angle025"]))

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                BT.Cooking.StartFries(ent)
            end
        end,
    },
    ["soda"] = {
        ["forSale"] = true,
        ["mat"] = BT.Materials["soda"],
        ["desc"] = "sodaCupDesc",
        ["multiple"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["bt_fountain"] = true,
            },
            ["mdl"] = "models/bolt_terminal/cup.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if ent:GetBodygroup(1) == 1 then return false end

                RFSClientside:SetPos(ent:LocalToWorld(BT.Constants["vector22"]))
                
                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                BT.Cooking.CreateSodaCup(ent, ply)
            end
        end,
    },
    ["friesCup"] = {
        ["forSale"] = true,
        ["mat"] = BT.Materials["emptyFriesBag"],
        ["desc"] = "friesCupDesc",
        ["multiple"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["bt_fryer"] = true,
            },
            ["mdl"] = "models/bolt_terminal/fries_bag.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if ent:GetSkin() != 1 then return end

                local count = (ent:GetBodygroupCount(1)-1)
                local getBodyGroup = ent:GetBodygroup(1)
            
                if getBodyGroup >= count then return false end

                RFSClientside:SetPos(ent:LocalToWorld(BT.Constants["vector020"]))
                RFSClientside:SetAngles(ent:LocalToWorldAngles(BT.Constants["angle0"]))

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                BT.Cooking.FillFriesBag(ent, ply)
            end
        end,
    },
    ["cuttedTomato"] = {
        ["forSale"] = false,
        ["noNeedMoney"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["bt_condiment_container"] = true,
                ["bt_plank_burger"] = true,
            },
            ["mdl"] = "models/bolt_terminal/burger_tomato.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if RFSClientside.parentCase == ent then return end

                if ent:GetClass() == "bt_condiment_container" then
                    if ent:GetBodygroup(1) >= (ent:GetBodygroupCount(1)-1) then return false end
                    
                    RFSClientside:SetPos(ent:LocalToWorld(BT.Constants["vector2010"]))
                elseif ent:GetClass() == "bt_plank_burger" then
                    if not BT.Cooking.CheckMaxSizeBurger(ent) then return false end

                    local placeToSet = BT.GetSpaceBurger(ent)
                    if not isvector(placeToSet) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(placeToSet))
                end
                
                return true
            end,
            ["canInteract"] = function(ent)
                if ent:GetClass() == "bt_condiment_container" then
                    return (ent:GetBodygroup(1) > 0)
                end

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                if linkedEnt:GetClass() == "bt_condiment_container" then
                    local removed = BT.Cooking.ChangeQuantity(linkedEnt, "cuttedTomato", 1, -1)
                    if removed then
                        BT.Cooking.AddBurgerCondiment(ent, "models/bolt_terminal/burger_tomato.mdl")
                    end
                else
                    ent.BT = ent.BT or {}
                    if ent:GetClass() == "bt_condiment_container" && linkedEnt.BT["entCutted"] then
                        
                        BT.Cooking.ChangeQuantity(ent, "cuttedTomato", 1, 3)
                        linkedEnt.BT["entCutted"] = false
                    elseif ent:GetClass() == "bt_plank_burger" && linkedEnt.BT["entCutted"] then

                        BT.Cooking.AddBurgerCondiment(ent, "models/bolt_terminal/burger_tomato.mdl")
                        ent.BT["entCutted"] = false
                    end
                    linkedEnt:ResetSequence("idle")
                end
            end
        end,
    },
    ["cuttedOnion"] = {
        ["forSale"] = false,
        ["noNeedMoney"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["bt_condiment_container"] = true,
                ["bt_plank_burger"] = true,
            },
            ["mdl"] = "models/bolt_terminal/burger_onion.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if RFSClientside.parentCase == ent then return end

                if ent:GetClass() == "bt_condiment_container" then
                    if ent:GetBodygroup(3) >= (ent:GetBodygroupCount(3)-1) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(BT.Constants["vector10"]))
                elseif ent:GetClass() == "bt_plank_burger" then
                    if not BT.Cooking.CheckMaxSizeBurger(ent) then return false end

                    local placeToSet = BT.GetSpaceBurger(ent)
                    if not isvector(placeToSet) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(placeToSet))
                end
                
                return true
            end,
            ["canInteract"] = function(ent)
                if ent:GetClass() == "bt_condiment_container" then
                    return (ent:GetBodygroup(3) > 0)
                end

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt)
            if SERVER then
                if linkedEnt:GetClass() == "bt_condiment_container" then
                    local removed = BT.Cooking.ChangeQuantity(linkedEnt, "cuttedOnion", 3, -1)
                    if removed then
                        BT.Cooking.AddBurgerCondiment(ent, "models/bolt_terminal/burger_onion.mdl")
                    end
                else
                    ent.BT = ent.BT or {}
                    if ent:GetClass() == "bt_condiment_container" && linkedEnt.BT["entCutted"] then

                        BT.Cooking.ChangeQuantity(ent, "cuttedOnion", 3, 3)
                    elseif ent:GetClass() == "bt_plank_burger" && linkedEnt.BT["entCutted"] then

                        BT.Cooking.AddBurgerCondiment(ent, "models/bolt_terminal/burger_onion.mdl")
                    end
                    linkedEnt:ResetSequence("idle")
                end
            end
        end,
    },
    ["previousSoda"] = {
        ["forSale"] = false,
        ["notCheckUniqueName"] = true,
        ["noNeedMoney"] = true,
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                if timer.Exists("bt_sodacup:"..ent:EntIndex()) then return end
                local sodaId = BT.GetNWVariables("bt_soda_id", ent) or 1

                if sodaId == 1 then 
                    sodaId = #BT.SodaList
                else
                    sodaId = math.Clamp(sodaId - 1, 1, #BT.SodaList)
                end

                BT.SetNWVariable("bt_soda_id", sodaId, ent, true, nil, true)
            end
        end,
    },
    ["nextSoda"] = {
        ["forSale"] = false,
        ["notCheckUniqueName"] = true,
        ["noNeedMoney"] = true,
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                if timer.Exists("bt_sodacup:"..ent:EntIndex()) then return end
                local sodaId = BT.GetNWVariables("bt_soda_id", ent) or 1

                if sodaId == #BT.SodaList then 
                    sodaId = 1
                else
                    sodaId = math.Clamp(sodaId + 1, 1, #BT.SodaList)
                end

                BT.SetNWVariable("bt_soda_id", sodaId, ent, true, nil, true)
            end
        end,
    },
    ["startSoda"] = {
        ["forSale"] = false,
        ["notCheckUniqueName"] = true,
        ["noNeedMoney"] = true,
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                if timer.Exists("bt_sodacup:"..ent:EntIndex()) then return end
                local sodaId = BT.GetNWVariables("bt_soda_id", ent) or 1
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3

                BT.Cooking.StartSodaCup(ent, sodaId, ply)
            end
        end,
    },
}

--[[ List all type of value for the NW functions ]]
BT.TypeNet = BT.TypeNet or {
    ["Player"] = "Entity",
    ["Vector"] = "Vector",
    ["Angle"] = "Angle",
    ["Entity"] = "Entity",
    ["number"] = "Float",
    ["string"] = "String",
    ["table"] = "Table",
    ["color"] = "Color",
    ["boolean"] = "Bool",
}
