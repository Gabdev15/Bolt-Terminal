/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

include("realistic_fastfood/sh_config.lua")
include("realistic_fastfood/sh_materials.lua")
include("realistic_fastfood/sh_advanced_config.lua")
include("realistic_fastfood/shared/sh_functions.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2

local files, directories = file.Find("realistic_fastfood/languages/*", "LUA")
for k,v in ipairs(files) do
    include("realistic_fastfood/languages/"..v)
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

if SERVER then
    include("realistic_fastfood/sv_sql.lua")
    include("realistic_fastfood/server/sv_functions.lua")
    include("realistic_fastfood/server/sv_nets.lua")
    include("realistic_fastfood/server/sv_hooks.lua")
    include("realistic_fastfood/server/sv_cooking.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46
    
    for k,v in ipairs(files) do
        AddCSLuaFile("realistic_fastfood/languages/"..v)
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
    
    AddCSLuaFile("realistic_fastfood/sh_config.lua")
    AddCSLuaFile("realistic_fastfood/sh_materials.lua")
    AddCSLuaFile("realistic_fastfood/sh_advanced_config.lua")
    AddCSLuaFile("realistic_fastfood/shared/sh_functions.lua")
    
    AddCSLuaFile("realistic_fastfood/client/cl_fonts.lua")
    AddCSLuaFile("realistic_fastfood/client/cl_main.lua")
    AddCSLuaFile("realistic_fastfood/client/cl_notify.lua")
    AddCSLuaFile("realistic_fastfood/client/cl_terminal.lua")
    AddCSLuaFile("realistic_fastfood/client/cl_cooking.lua")
    AddCSLuaFile("realistic_fastfood/client/cl_halo.lua")
    AddCSLuaFile("realistic_fastfood/client/cl_screen.lua")
else
    include("realistic_fastfood/client/cl_fonts.lua")
    include("realistic_fastfood/client/cl_main.lua")
    include("realistic_fastfood/client/cl_notify.lua")
    include("realistic_fastfood/client/cl_terminal.lua")
    include("realistic_fastfood/client/cl_cooking.lua")
    include("realistic_fastfood/client/cl_halo.lua")
    include("realistic_fastfood/client/cl_screen.lua")
end
