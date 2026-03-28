/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

RFS = RFS or {}

--[[ Vector and Angle chache ]]
RFS.Constants = {
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
RFS.Status = {
    "smileyAngry",
    "smileySad",
    "smileyHappy",
}

--[[ Convert a model to a string used on my function RFS.GetSentence ]]
RFS.ModelsToName = {
    ["models/realistic_food_system/burger_top_bun.mdl"] = "bun",
    ["models/realistic_food_system/burger_salad.mdl"] = "salad",
    ["models/realistic_food_system/burger_tomato.mdl"] = "tomato",
    ["models/realistic_food_system/burger_onion.mdl"] = "onion",
    ["models/realistic_food_system/burger_cheese.mdl"] = "cheese",
    ["models/realistic_food_system/burger_steak.mdl"] = "steak",
    ["models/realistic_food_system/burger_bottom_bun.mdl"] = "bun2",
    ["models/realistic_food_system/burger_bottom_bun.mdl"] = "bun2",
    ["models/realistic_food_system/fries_bag.mdl"] = "fries",
    ["models/realistic_food_system/cup.mdl"] = "soda",
}

--[[ All tray position ]]
RFS.TrayPosition = {
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
RFS.TrayAllowedEnt = {
    ["rfs_burger"] = function(ent)
        local parent = ent:GetParent()
        if IsValid(parent) then return end

        return true
    end,
    ["rfs_sodacup"] = function(ent)
        local color = RFS.GetNWVariables("rfs_soda_color", ent)
        if not color then return end

        return true
    end,
    ["rfs_friesbag"] = function(ent)
        if ent:GetBodygroup(1) != 1 then return end

        return true
    end,
}

--[[ Ajust some position on the tray ]]
RFS.TrayCustomPosition = {
    ["rfs_burger"] = Vector(0, 0, -1.5),
}

--[[
    mat --> path of the material.
    size --> size of the material.
    posId --> Use a posId different of the key to do a stack aspect.
    uniqueName --> Used for the order and the translation.
]]
RFS.BurgerElements = {
    {
        ["mat"] = RFS.Materials["prius"],
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

RFS.Distributor = {
    ["fries01"] = {
        ["uniqueName"] = "fries01",
        ["class"] = "rfs_friesbag",
        ["price"] = 500,
        ["sizeIcon"] = {500, 500},
        ["ingredientsTable"] = {
            "models/realistic_food_system/fries_bag.mdl",
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
        ["class"] = "rfs_sodacup",
        ["price"] = 500,
        ["sizeIcon"] = {500, 500},
        ["ingredientsTable"] = {
            "models/realistic_food_system/cup.mdl",
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
        ["class"] = "rfs_burger",
        ["price"] = 500,
        ["sizeIcon"] = {500, 500},
        ["amountFood"] = 40,
        ["ingredientsTable"] = {
            "models/realistic_food_system/burger_bottom_bun.mdl",
            "models/realistic_food_system/burger_steak.mdl",
            "models/realistic_food_system/burger_cheese.mdl",
            "models/realistic_food_system/burger_onion.mdl",
            "models/realistic_food_system/burger_tomato.mdl",
            "models/realistic_food_system/burger_salad.mdl",
            "models/realistic_food_system/burger_top_bun.mdl",
        },
    },
}

RFS.BaseBurger = {
    "models/realistic_food_system/burger_bottom_bun.mdl",
    "models/realistic_food_system/burger_steak.mdl",
    "models/realistic_food_system/burger_cheese.mdl",
    "models/realistic_food_system/burger_onion.mdl",
    "models/realistic_food_system/burger_tomato.mdl",
    "models/realistic_food_system/burger_salad.mdl",
    "models/realistic_food_system/burger_top_bun.mdl",
}

--[[
    get --> function to get the correct table to save into the inventories.
    create --> function to re create the entities with good parameters.
]]
RFS.Inventories = {
    ["rfs_burger"] = {
        ["get"] = function(ent)
            ent.RFS = ent.RFS or {}
            ent.RFS["condiments"] = ent.RFS["condiments"] or {}        
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 6b45c6579bc41ec8ed9db9d8886850852aec4a7c4a86ae59243df7524725d54f
            
            local returnTable = {
                ["class"] = ent:GetClass(),
                ["ingredientsTable"] = ent.RFS["condiments"],
                ["distributor"] = ent.RFS["distributor"],
                ["amountFood"] = (ent.RFS["amountFood"] or 0),
            }
    
            return returnTable
        end,
        ["create"] = function(bag, itemTable, distributor, allTable)
            local burger = RFS.Cooking.CreateBurger(nil, nil, bag:GetPos(), RFS.Constants["angle0"], true, nil, itemTable)
            burger:SetPos(bag:GetPos() + RFS.Constants["vector10"])
            burger:SetAngles(RFS.Constants["angle090"])
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

            burger.RFS = burger.RFS or {}
            burger.RFS["cooldownToEnter"] = CurTime() + 3

            burger.RFS["amountFood"] = (allTable["amountFood"] or 0)

            return burger
        end,
    },
    ["rfs_friesbag"] = {
        ["get"] = function(ent, distributor)
            if ent:GetBodygroup(1) != 1 then return end
    
            local returnTable = {
                ["class"] = ent:GetClass(),
                ["ingredientsTable"] = {"models/realistic_food_system/fries_bag.mdl"},
                ["distributor"] = ent.RFS["distributor"],
            }
    
            return returnTable
        end,
        ["create"] = function(bag, itemTable, distributor)            
            local friesBag = ents.Create("rfs_friesbag")
            friesBag:SetPos(bag:GetPos() + RFS.Constants["vector20"])
            friesBag:SetAngles(RFS.Constants["angle090"])
            friesBag:Spawn()
            friesBag:SetBodygroup(1, 1)

            friesBag.RFS = friesBag.RFS or {}
            friesBag.RFS["cooldownToEnter"] = CurTime() + 3

            return friesBag
        end,
    },
    ["rfs_sodacup"] = {
        ["get"] = function(ent, distributor)
            local color = RFS.GetNWVariables("rfs_soda_color", ent)
            if not color then return end
    
            color.a = 255
            
            local returnTable = {
                ["class"] = ent:GetClass(),
                ["ingredientsTable"] = {"models/realistic_food_system/cup.mdl", color},
                ["distributor"] = ent.RFS["distributor"],
            }
            
            return returnTable
        end,
        ["create"] = function(bag, itemTable, distributor)
            local color = itemTable[2]
            if not IsColor(color) then color = RFS.Colors["white"] end

            local sodaCup = ents.Create("rfs_sodacup")
            sodaCup:SetPos(bag:GetPos() + RFS.Constants["vector10"])
            sodaCup:SetAngles(RFS.Constants["angle090"])
            sodaCup:Spawn()
            sodaCup:SetBodygroup(1, 5)
            sodaCup:SetColor(color)

            sodaCup.RFS = sodaCup.RFS or {}
            sodaCup.RFS["cooldownToEnter"] = CurTime() + 3
            sodaCup.RFS["distributor"] = distributor

            RFS.SetNWVariable("rfs_soda_color", color, sodaCup, true, nil, true)

            return sodaCup
        end,
    },
}

RFS.SpaceCondiment = {
    ["models/realistic_food_system/burger_top_bun.mdl"] = Vector(0, 0, 2),
    ["models/realistic_food_system/burger_salad.mdl"] = Vector(0, 0, 0.5),
    ["models/realistic_food_system/burger_tomato.mdl"] = Vector(0, 0, 0.6),
    ["models/realistic_food_system/burger_onion.mdl"] = Vector(0, 0, 0.6),
    ["models/realistic_food_system/burger_cheese.mdl"] = Vector(0, 0, 0.08),
    ["models/realistic_food_system/burger_bottom_bun.mdl"] = Vector(0, 0, 1.7),
    ["models/realistic_food_system/burger_steak.mdl"] = Vector(0, 0, 1.55),
}

--[[
    key --> model of the condiment
    func --> function of the condiment
]]
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46

RFS.ComposeBurger = {
    ["models/realistic_food_system/burger_bottom_bun.mdl"] = {
        ["func"] = function(plank)
            if not IsValid(plank.burger) then
                RFS.Cooking.CreateBurger(plank)
            end
        end
    },
    ["models/realistic_food_system/burger_top_bun.mdl"] = {
        ["func"] = function(plank)
            timer.Simple(0.5, function()
                RFS.Cooking.FinishBurger(plank)
            end)
        end
    },
}

--[[
    mat --> path of the material.
    color --> backGround color of the soda brand.
    uniqueName --> uniqueName of the soda.
]]
RFS.SodaList = {
    {
        ["mat"] = RFS.Materials["peache"],
        ["color"] = Color(255, 182, 46, 200),
        ["uniqueName"] = "peache",
    },
    {
        ["mat"] = RFS.Materials["lime"],
        ["color"] = Color(46, 204, 113, 200),
        ["uniqueName"] = "limea",
    },
    {
        ["mat"] = RFS.Materials["orange"],
        ["color"] = Color(243, 156, 18, 200),
        ["uniqueName"] = "orangejuice",
    },
    {
        ["mat"] = RFS.Materials["cherries"],
        ["color"] = Color(231, 76, 60, 200),
        ["uniqueName"] = "cherry",
    },
}

--[[
    pos --> Position of the steak.
    ang --> Angle of the steak.
]]
RFS.SteakPosition = {
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
RFS.CookingElement = {
    ["bun"] = {
        ["forSale"] = true,
        ["mat"] = RFS.Materials["bun"],
        ["desc"] = "bunDesc",
        ["multiple"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["rfs_plank_burger"] = true,
            },
            ["mdl"] = "models/realistic_food_system/burger_top_bun.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if RFSClientside.parentCase == ent then return end

                local class = ent:GetClass()
                if class == "rfs_condiment_container" then
                    
                    RFSClientside:SetPos(ent:LocalToWorld(RFS.Constants["vector2010"]))
                elseif class == "rfs_plank_burger" then
                    local placeToSet = RFS.GetSpaceBurger(ent, true)
                    if not isvector(placeToSet) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(placeToSet))
                end

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                RFS.Cooking.AddBurgerCondiment(ent, "models/realistic_food_system/burger_top_bun.mdl")
            end
        end,
    },
    ["steak"] = {
        ["forSale"] = true,
        ["mat"] = RFS.Materials["steak"],
        ["desc"] = "steakDesc",
        ["multiple"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["rfs_grill"] = true,
                ["rfs_condiment_container"] = true,
                ["rfs_plank_burger"] = true,
            },
            ["mdl"] = "models/realistic_food_system/burger_steak.mdl",
            ["func"] = function(ent, steak)
                if not IsValid(RFSClientside) then return end
                if RFSClientside.parentCase == ent then return end
     
                local class = ent:GetClass()
                local steakTable = nil
                
                if IsValid(steak) && steak:GetClass() == "rfs_steak" then
                    steakTable = RFS.Cooking.GetTableBySteakId(steak:GetParent(), steak:EntIndex())
                end
                
                if class == "rfs_condiment_container" && not steakTable then
                    if ent:GetBodygroup(5) >= (ent:GetBodygroupCount(5)-1) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(RFS.Constants["vector20010"]))
                    RFSClientside:SetAngles(ent:LocalToWorldAngles(RFS.Constants["angle60"]))
                    
                    return true
                elseif class == "rfs_grill" && not steakTable then
                    
                    local steakTable = RFS.SteakPosition[RFS.Cooking.GetSteakPlace(ent)]
                    if not steakTable or not isvector(steakTable["pos"]) then return false end
                    
                    RFSClientside:SetPos(ent:LocalToWorld(steakTable["pos"]))
                    RFSClientside:SetAngles(ent:LocalToWorldAngles(steakTable["ang"]))
                    
                    return true
                elseif class == "rfs_plank_burger" && steakTable then
                    if not steakTable["flipped"] then return end
                    
                    local placeToSet = RFS.GetSpaceBurger(ent)
                    if not isvector(placeToSet) then return false end
                    if not RFS.Cooking.CheckMaxSizeBurger(ent) then return false end
                    if ent:GetColor() == RFS.Colors["black2"] then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(placeToSet))

                    return true
                end
            end,
            ["canInteract"] = function(ent)
                if ent:GetClass() == "rfs_condiment_container" then
                    return (ent:GetBodygroup(5) > 0)
                end

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                local entClass = ent:GetClass()
                local linkedClass = linkedEnt:GetClass()

                if (entClass == "rfs_condiment_container" or entClass == "rfs_grill") && linkedClass != "rfs_box" then
                    local removed = RFS.Cooking.ChangeQuantity(linkedEnt, "steak", 5, -1)
                    if removed then
                        RFS.Cooking.AddSteak(ent)
                    end
                else
                    if entClass == "rfs_condiment_container" then
                        
                        RFS.Cooking.ChangeQuantity(ent, "steak", 5, 1)
                    elseif entClass == "rfs_grill" then

                        RFS.Cooking.AddSteak(ent)
                    elseif entClass == "rfs_plank_burger" then
                        if not IsValid(linkedEnt) or linkedClass != "rfs_steak" then return end
                        if linkedEnt.RFS["carbonised"] then return end
                        
                        RFS.Cooking.AddBurgerCondiment(ent, "models/realistic_food_system/burger_steak.mdl", linkedEnt:GetColor())
                        linkedEnt:Remove()
                    end
                end
            end
        end,
    },
    ["onion"] = {
        ["forSale"] = true,
        ["mat"] = RFS.Materials["onion"],
        ["desc"] = "onionsDesc",
        ["clientSideModel"] = {
            ["filter"] = {
                ["rfs_plank"] = true,
            },
            ["mdl"] = "models/realistic_food_system/onion.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if ent:GetBodygroup(2) != 0 then return false end

                RFSClientside:SetPos(ent:LocalToWorld(RFS.Constants["vector010"]))

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                if ent:GetBodygroup(2) != 0 then return end

                ent:SetSkin(1)
                ent:ResetSequence("cutting")
                ent:SetSequence("cutting")

                ent.RFS = ent.RFS or {}
                ent.RFS["entCutted"] = true
            end
        end,
    },
    ["salad"] = {
        ["forSale"] = true,
        ["mat"] = RFS.Materials["lettuce"],
        ["desc"] = "saladDesc",
        ["multiple"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["rfs_condiment_container"] = true,
                ["rfs_plank_burger"] = true,
            },
            ["mdl"] = "models/realistic_food_system/burger_salad.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if RFSClientside.parentCase == ent then return end
                
                if ent:GetClass() == "rfs_condiment_container" then
                    if ent:GetBodygroup(2) >= (ent:GetBodygroupCount(2)-1) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(RFS.Constants["vector10010"]))
                elseif ent:GetClass() == "rfs_plank_burger" then
                    if not RFS.Cooking.CheckMaxSizeBurger(ent) then return false end

                    local placeToSet = RFS.GetSpaceBurger(ent)
                    if not isvector(placeToSet) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(placeToSet))
                end

                return true
            end,
            ["canInteract"] = function(ent)
                if ent:GetClass() == "rfs_condiment_container" then
                    return (ent:GetBodygroup(2) > 0)
                end

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                if linkedEnt:GetClass() == "rfs_condiment_container" then
                    local removed = RFS.Cooking.ChangeQuantity(linkedEnt, "salad", 2, -1)
                    if removed then
                        RFS.Cooking.AddBurgerCondiment(ent, "models/realistic_food_system/burger_salad.mdl")
                    end
                else
                    if ent:GetClass() == "rfs_condiment_container" then

                        RFS.Cooking.ChangeQuantity(ent, "salad", 2, 1)
                    elseif ent:GetClass() == "rfs_plank_burger" then

                        RFS.Cooking.AddBurgerCondiment(ent, "models/realistic_food_system/burger_salad.mdl")
                    end
                end
            end
        end,
    },
    ["tomato"] = {
        ["forSale"] = true,
        ["mat"] = RFS.Materials["tomato"],
        ["desc"] = "tomatoDesc",
        ["clientSideModel"] = {
            ["filter"] = {
                ["rfs_plank"] = true,
            },
            ["mdl"] = "models/realistic_food_system/tomato.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if ent:GetBodygroup(2) != 0 then return false end

                RFSClientside:SetPos(ent:LocalToWorld(RFS.Constants["vector010"]))

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                if ent:GetBodygroup(2) != 0 then return end

                ent:SetSkin(2)
                ent:ResetSequence("cutting")
                ent:SetSequence("cutting")

                ent.RFS = ent.RFS or {}
                ent.RFS["entCutted"] = true
            end
        end,
    },
    ["cheese"] = {
        ["forSale"] = true,
        ["mat"] = RFS.Materials["cheese"],
        ["desc"] = "cheeseDesc",
        ["multiple"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["rfs_condiment_container"] = true,
                ["rfs_plank_burger"] = true,
            },
            ["mdl"] = "models/realistic_food_system/burger_cheese.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if RFSClientside.parentCase == ent then return end

                if ent:GetClass() == "rfs_condiment_container" then
                    if ent:GetBodygroup(4) >= (ent:GetBodygroupCount(4)-1) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(RFS.Constants["vector100102"]))
                elseif ent:GetClass() == "rfs_plank_burger" then
                    if not RFS.Cooking.CheckMaxSizeBurger(ent) then return false end

                    local placeToSet = RFS.GetSpaceBurger(ent)
                    if not isvector(placeToSet) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(placeToSet))
                end
                
                return true
            end,
            ["canInteract"] = function(ent)
                if ent:GetClass() == "rfs_condiment_container" then
                    return (ent:GetBodygroup(4) > 0)
                end

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                if linkedEnt:GetClass() == "rfs_condiment_container" then
                    local removed = RFS.Cooking.ChangeQuantity(linkedEnt, "cheese", 4, -1)
                    if removed then
                        RFS.Cooking.AddBurgerCondiment(ent, "models/realistic_food_system/burger_cheese.mdl")
                    end
                else
                    if ent:GetClass() == "rfs_condiment_container" then

                        RFS.Cooking.ChangeQuantity(ent, "cheese", 4, 1)
                    elseif ent:GetClass() == "rfs_plank_burger" then

                        RFS.Cooking.AddBurgerCondiment(ent, "models/realistic_food_system/burger_cheese.mdl")
                    end
                end
            end
        end,
    },
    ["bun2"] = {
        ["forSale"] = true,
        ["mat"] = RFS.Materials["bun2"],
        ["desc"] = "bun2Desc",
        ["multiple"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["rfs_plank_burger"] = true,
            },
            ["mdl"] = "models/realistic_food_system/burger_bottom_bun.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end

                if ent:GetClass() == "rfs_condiment_container" then
                    
                    RFSClientside:SetPos(ent:LocalToWorld(RFS.Constants["vector2010"]))
                elseif ent:GetClass() == "rfs_plank_burger" then
                    if not RFS.Cooking.CheckMaxSizeBurger(ent) then return false end

                    local placeToSet = RFS.GetSpaceBurger(ent)
                    if not isvector(placeToSet) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(placeToSet))
                end

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                RFS.Cooking.AddBurgerCondiment(ent, "models/realistic_food_system/burger_bottom_bun.mdl")
            end
        end,
    },
    ["fries"] = {
        ["forSale"] = true,
        ["mat"] = RFS.Materials["fries"],
        ["desc"] = "friesDesc",
        ["multiple"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["rfs_fryer"] = true,
            },
            ["mdl"] = "models/realistic_food_system/fries.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if ent:GetSkin() == 1 or ent:GetBodygroup(1) != 0 then return false end

                RFSClientside:SetPos(ent:LocalToWorld(RFS.Constants["vector10"]))
                RFSClientside:SetAngles(ent:LocalToWorldAngles(RFS.Constants["angle025"]))

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                RFS.Cooking.StartFries(ent)
            end
        end,
    },
    ["soda"] = {
        ["forSale"] = true,
        ["mat"] = RFS.Materials["soda"],
        ["desc"] = "sodaCupDesc",
        ["multiple"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["rfs_fountain"] = true,
            },
            ["mdl"] = "models/realistic_food_system/cup.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if ent:GetBodygroup(1) == 1 then return false end

                RFSClientside:SetPos(ent:LocalToWorld(RFS.Constants["vector22"]))
                
                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                RFS.Cooking.CreateSodaCup(ent, ply)
            end
        end,
    },
    ["friesCup"] = {
        ["forSale"] = true,
        ["mat"] = RFS.Materials["emptyFriesBag"],
        ["desc"] = "friesCupDesc",
        ["multiple"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["rfs_fryer"] = true,
            },
            ["mdl"] = "models/realistic_food_system/fries_bag.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if ent:GetSkin() != 1 then return end

                local count = (ent:GetBodygroupCount(1)-1)
                local getBodyGroup = ent:GetBodygroup(1)
            
                if getBodyGroup >= count then return false end

                RFSClientside:SetPos(ent:LocalToWorld(RFS.Constants["vector020"]))
                RFSClientside:SetAngles(ent:LocalToWorldAngles(RFS.Constants["angle0"]))

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                RFS.Cooking.FillFriesBag(ent, ply)
            end
        end,
    },
    ["cuttedTomato"] = {
        ["forSale"] = false,
        ["noNeedMoney"] = true,
        ["clientSideModel"] = {
            ["filter"] = {
                ["rfs_condiment_container"] = true,
                ["rfs_plank_burger"] = true,
            },
            ["mdl"] = "models/realistic_food_system/burger_tomato.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if RFSClientside.parentCase == ent then return end

                if ent:GetClass() == "rfs_condiment_container" then
                    if ent:GetBodygroup(1) >= (ent:GetBodygroupCount(1)-1) then return false end
                    
                    RFSClientside:SetPos(ent:LocalToWorld(RFS.Constants["vector2010"]))
                elseif ent:GetClass() == "rfs_plank_burger" then
                    if not RFS.Cooking.CheckMaxSizeBurger(ent) then return false end

                    local placeToSet = RFS.GetSpaceBurger(ent)
                    if not isvector(placeToSet) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(placeToSet))
                end
                
                return true
            end,
            ["canInteract"] = function(ent)
                if ent:GetClass() == "rfs_condiment_container" then
                    return (ent:GetBodygroup(1) > 0)
                end

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                if linkedEnt:GetClass() == "rfs_condiment_container" then
                    local removed = RFS.Cooking.ChangeQuantity(linkedEnt, "cuttedTomato", 1, -1)
                    if removed then
                        RFS.Cooking.AddBurgerCondiment(ent, "models/realistic_food_system/burger_tomato.mdl")
                    end
                else
                    ent.RFS = ent.RFS or {}
                    if ent:GetClass() == "rfs_condiment_container" && linkedEnt.RFS["entCutted"] then
                        
                        RFS.Cooking.ChangeQuantity(ent, "cuttedTomato", 1, 3)
                        linkedEnt.RFS["entCutted"] = false
                    elseif ent:GetClass() == "rfs_plank_burger" && linkedEnt.RFS["entCutted"] then

                        RFS.Cooking.AddBurgerCondiment(ent, "models/realistic_food_system/burger_tomato.mdl")
                        ent.RFS["entCutted"] = false
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
                ["rfs_condiment_container"] = true,
                ["rfs_plank_burger"] = true,
            },
            ["mdl"] = "models/realistic_food_system/burger_onion.mdl",
            ["func"] = function(ent)
                if not IsValid(RFSClientside) then return end
                if RFSClientside.parentCase == ent then return end

                if ent:GetClass() == "rfs_condiment_container" then
                    if ent:GetBodygroup(3) >= (ent:GetBodygroupCount(3)-1) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(RFS.Constants["vector10"]))
                elseif ent:GetClass() == "rfs_plank_burger" then
                    if not RFS.Cooking.CheckMaxSizeBurger(ent) then return false end

                    local placeToSet = RFS.GetSpaceBurger(ent)
                    if not isvector(placeToSet) then return false end

                    RFSClientside:SetPos(ent:LocalToWorld(placeToSet))
                end
                
                return true
            end,
            ["canInteract"] = function(ent)
                if ent:GetClass() == "rfs_condiment_container" then
                    return (ent:GetBodygroup(3) > 0)
                end

                return true
            end,
        },
        ["action"] = function(ent, linkedEnt)
            if SERVER then
                if linkedEnt:GetClass() == "rfs_condiment_container" then
                    local removed = RFS.Cooking.ChangeQuantity(linkedEnt, "cuttedOnion", 3, -1)
                    if removed then
                        RFS.Cooking.AddBurgerCondiment(ent, "models/realistic_food_system/burger_onion.mdl")
                    end
                else
                    ent.RFS = ent.RFS or {}
                    if ent:GetClass() == "rfs_condiment_container" && linkedEnt.RFS["entCutted"] then

                        RFS.Cooking.ChangeQuantity(ent, "cuttedOnion", 3, 3)
                    elseif ent:GetClass() == "rfs_plank_burger" && linkedEnt.RFS["entCutted"] then

                        RFS.Cooking.AddBurgerCondiment(ent, "models/realistic_food_system/burger_onion.mdl")
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
                if timer.Exists("rfs_sodacup:"..ent:EntIndex()) then return end
                local sodaId = RFS.GetNWVariables("rfs_soda_id", ent) or 1

                if sodaId == 1 then 
                    sodaId = #RFS.SodaList
                else
                    sodaId = math.Clamp(sodaId - 1, 1, #RFS.SodaList)
                end

                RFS.SetNWVariable("rfs_soda_id", sodaId, ent, true, nil, true)
            end
        end,
    },
    ["nextSoda"] = {
        ["forSale"] = false,
        ["notCheckUniqueName"] = true,
        ["noNeedMoney"] = true,
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                if timer.Exists("rfs_sodacup:"..ent:EntIndex()) then return end
                local sodaId = RFS.GetNWVariables("rfs_soda_id", ent) or 1

                if sodaId == #RFS.SodaList then 
                    sodaId = 1
                else
                    sodaId = math.Clamp(sodaId + 1, 1, #RFS.SodaList)
                end

                RFS.SetNWVariable("rfs_soda_id", sodaId, ent, true, nil, true)
            end
        end,
    },
    ["startSoda"] = {
        ["forSale"] = false,
        ["notCheckUniqueName"] = true,
        ["noNeedMoney"] = true,
        ["action"] = function(ent, linkedEnt, ply)
            if SERVER then
                if timer.Exists("rfs_sodacup:"..ent:EntIndex()) then return end
                local sodaId = RFS.GetNWVariables("rfs_soda_id", ent) or 1
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3

                RFS.Cooking.StartSodaCup(ent, sodaId, ply)
            end
        end,
    },
}

--[[ List all type of value for the NW functions ]]
RFS.TypeNet = RFS.TypeNet or {
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
