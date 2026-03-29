/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

BT = BT or {}

--[[ Vector and Angle cache ]]
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
