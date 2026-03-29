/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

include("bolt_terminal/sh_config.lua")
include("bolt_terminal/sh_materials.lua")
include("bolt_terminal/sh_advanced_config.lua")
include("bolt_terminal/shared/sh_functions.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2

local files, directories = file.Find("bolt_terminal/languages/*", "LUA")
for k,v in ipairs(files) do
    include("bolt_terminal/languages/"..v)
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017

if SERVER then
    include("bolt_terminal/sv_sql.lua")
    include("bolt_terminal/server/sv_functions.lua")
    include("bolt_terminal/server/sv_nets.lua")
    include("bolt_terminal/server/sv_hooks.lua")
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 9df8a41e67be64bef2e3a0ecea717cb3cf78369cf6ecfcb6b671f6aa5106af46
    
    for k,v in ipairs(files) do
        AddCSLuaFile("bolt_terminal/languages/"..v)
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 1283ca0e9ceddd2d5e4f3ce0ed12f2ad0d5f173ee5648228bba71b519f799017
    
    AddCSLuaFile("bolt_terminal/sh_config.lua")
    AddCSLuaFile("bolt_terminal/sh_materials.lua")
    AddCSLuaFile("bolt_terminal/sh_advanced_config.lua")
    AddCSLuaFile("bolt_terminal/shared/sh_functions.lua")
    
    AddCSLuaFile("bolt_terminal/client/cl_fonts.lua")
    AddCSLuaFile("bolt_terminal/client/cl_main.lua")
    AddCSLuaFile("bolt_terminal/client/cl_notify.lua")
    AddCSLuaFile("bolt_terminal/client/cl_terminal.lua")
    AddCSLuaFile("bolt_terminal/client/cl_halo.lua")
else
    include("bolt_terminal/client/cl_fonts.lua")
    include("bolt_terminal/client/cl_main.lua")
    include("bolt_terminal/client/cl_notify.lua")
    include("bolt_terminal/client/cl_terminal.lua")
    include("bolt_terminal/client/cl_halo.lua")
end
