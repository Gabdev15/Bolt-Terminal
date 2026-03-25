/*
    Addon id: f837e53b-2de7-43c1-b931-9d2ce02bcf47
    Version: v2.0.2 (stable)
*/

RFS.Cooking = RFS.Cooking or {}

local scrolLBarY = 0
function RFS.Cooking.IngredientsCase(ent)
    if IsValid(ingredientFrame) then ingredientFrame:Remove() return end
    
    ingredientFrame = vgui.Create("DFrame")
    ingredientFrame:SetSize(RFS.ScrW*0.3, RFS.ScrH*0.7)
    ingredientFrame:SetPos(RFS.ScrW*0.5-RFS.ScrW*0.15, RFS.ScrW*1.5)
    ingredientFrame:MoveTo(ingredientFrame:GetX(), RFS.ScrH*0.2, 0.25, 0, 1)
    ingredientFrame:ShowCloseButton(false)
    ingredientFrame:SetDraggable(false)
    ingredientFrame:SetTitle("")
    ingredientFrame:MakePopup()
    ingredientFrame.startTime = SysTime()
    ingredientFrame.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur(self, self.startTime)
        draw.RoundedBox(4, 0, 0, w, h, RFS.Colors["white246"])
                            
        draw.DrawText(RFS.GetSentence("deliveryBox"), "RFS:Font:04", w/2, h*0.027, RFS.Colors["grey2"], TEXT_ALIGN_CENTER)
        draw.DrawText(RFS.GetSentence("deliveryBoxDesc"), "RFS:Font:05", w/2, h*0.075, RFS.Colors["grey2"], TEXT_ALIGN_CENTER)

        draw.RoundedBox(8, w/2-w*0.4, h*0.12, w*0.8, 1, RFS.Colors["grey4"])
    end
    
    local scroll = vgui.Create("DScrollPanel", ingredientFrame)
    scroll:Dock(FILL)
    scroll:DockMargin(RFS.ScrW*0.01, RFS.ScrH*0.075, RFS.ScrW*0.008, RFS.ScrH*0.1)
    scroll:GetVBar():SetSize(0,0)

    local bar = scroll:GetVBar()
    ingredientFrame.OnRemove = function()
        scrolLBarY = bar:GetScroll()
    end
    
    for k, v in pairs(RFS.CookingElement) do
        if not v.forSale then continue end
        local maxQuantity = RFS.MaxQuantity[k] or 1

        local elements = vgui.Create("DPanel", scroll)
        elements:Dock(TOP)
        elements:DockMargin(0,0,0,6)
        elements:SetSize(0, RFS.ScrH*0.09)
        elements.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, RFS.Colors["black50"])
            draw.RoundedBox(4, -5, -5, w, h, RFS.Colors["white"])

            draw.DrawText((RFS.GetSentence(k).." - %s"):format(RFS.formatMoney(RFS.PriceForCooker[k])), "RFS:Font:02", w*0.19, h*0.15, RFS.Colors["grey2"], TEXT_ALIGN_LEFT)
            draw.DrawText(RFS.GetSentence(v.desc), "RFS:Font:01", w*0.19, h*0.4, RFS.Colors["grey3"], TEXT_ALIGN_LEFT)
    
            surface.SetMaterial(v.mat)
            surface.SetDrawColor(RFS.Colors["white"])
            surface.DrawTexturedRect(w*0.025, h*0.5-RFS.ScrH*0.06/2, RFS.ScrH*0.06, RFS.ScrH*0.06)
        end

        local takeOut = vgui.Create("DImageButton", elements)
        takeOut:SetSize(RFS.ScrH*0.06, RFS.ScrH*0.06)
        takeOut:SetPos(RFS.ScrW*0.225, RFS.ScrH*0.01)
        takeOut:SetText("")
        takeOut:SetMaterial(RFS.Materials["getOut"])

        takeOut.DoClick = function()
            net.Start("RFS:Cooking")
                net.WriteUInt(2, 5)
                net.WriteEntity(ent)
                net.WriteString(k)
            net.SendToServer()
        end
    end
    
    timer.Simple(0.1, function()
        if isnumber(scrolLBarY) && IsValid(bar) then
            bar:SetScroll(scrolLBarY)
        end
    end)

    local lerpButton = 0
    local closeButton = vgui.Create("DButton", ingredientFrame)
    closeButton:SetSize(RFS.ScrW*0.275, RFS.ScrH*0.06)
    closeButton:SetPos(RFS.ScrW*0.15-RFS.ScrW*0.275/2, RFS.ScrH*0.615)
    closeButton:SetFont("RFS:Font:04")
    closeButton:SetText(RFS.GetSentence("closeBox"))
    closeButton:SetTextColor(RFS.Colors["white246"])
    closeButton.Paint = function(self, w, h)
        lerpButton = Lerp(FrameTime()*5, lerpButton, (closeButton:IsHovered() and 255 or 220))
        draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(RFS.Colors["orange"], lerpButton))
    end
    closeButton.DoClick = function()
        ingredientFrame:MoveTo(ingredientFrame:GetX(), RFS.ScrH*1.5, 0.25, 0, 1, function()
            if IsValid(ingredientFrame) then ingredientFrame:Remove() end
        end)
        
        scrolLBarY = bar:GetScroll()
    end
end

local function paintDModel(dModel, renderTargetName, renderModel)
    dModel.Paint = function(self, w, h)
        self.renderTarget = self.renderTarget or nil

        local createRender = (isstring(renderTargetName) && not self.renderTarget)

        if createRender then
            self.renderTarget = GetRenderTarget(renderTargetName, w, h)
        end

        if createRender then
            render.PushRenderTarget(self.renderTarget)
            render.OverrideAlphaWriteEnable(true, true)
            render.ClearDepth()
            
            render.Clear(234, 216, 206, 255)
        end
            local x, y = self:LocalToScreen(0, 0)
        
            self:LayoutEntity(self.Entity)
        
            local ang = self.aLookAngle
            if !ang then
                ang = (self.vLookatPos-self.vCamPos):Angle()
            end
        
            local posCondiment = Vector(0, 0, 0)
            cam.Start3D(self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ)
            
                self.condiments = self.condiments or nil
                
                if self.condiments then
                    for k, v in pairs(self.condiments) do
                        v:SetPos(self.Entity:WorldToLocal(posCondiment))

                        posCondiment = posCondiment + RFS.SpaceCondiment[v:GetModel()]
                        
                        local color = (v:GetModel() == "models/realistic_food_system/burger_steak.mdl" and RFS.Colors["grilledSteak"] or RFS.Colors["white"])
                        local oldColorR, oldColorG, oldColorB = render.GetColorModulation()
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

                        render.SuppressEngineLighting(true)
                        render.SetColorModulation(color.r/255, color.g/255, color.b/255, color.a/255)
                            v:DrawModel()
                        render.SetColorModulation(oldColorR, oldColorG, oldColorB)
                        render.SuppressEngineLighting(false)
                    end
                end

                if renderModel then
                    render.SuppressEngineLighting(true)
                        self:DrawModel()
                    render.SuppressEngineLighting(false)
                end
        
                render.SuppressEngineLighting(true)
                render.SetLightingOrigin(self.Entity:GetPos())
                render.ResetModelLighting(self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255)
                render.SetColorModulation(self.colColor.r/255, self.colColor.g/255, self.colColor.b/255)
                render.SetBlend((self:GetAlpha()/255) * (self.colColor.a/255))
                
                for i=0, 6 do
                    local col = self.DirectionalLight[i]
                    if col then
                        render.SetModelLighting(i, col.r/255, col.g/255, col.b/255)
                    end
                end
                
                render.SuppressEngineLighting(false)
            cam.End3D()
        
        if createRender then
            render.OverrideAlphaWriteEnable(false)
            render.PopRenderTarget()

            if not RFS.RenderTarget[renderTargetName] then
                local customMaterial = CreateMaterial(renderTargetName, "UnlitGeneric", {
                    ["$basetexture"] = renderTargetName,
                    ["$vertexcolor"] = 1,
                })
    
                RFS.RenderTarget[renderTargetName] = customMaterial
            end
    
            self.condiments = self.condiments or {}
            for k, v in pairs(self.condiments) do
                if IsValid(v) then v:Remove() end
            end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cac3e41cd971a71c7f3ddee7a8048bfba941a4f0d8e62f4f2ce5f98de1f3ccf2

            self:Remove()
        end
    end

    dModel.OnRemove = function(self)
        self.condiments = self.condiments or {}
        for k, v in pairs(self.condiments) do
            if IsValid(v) then v:Remove() end
        end
                
        if IsValid(dModelTable[self.tableIndex]) then
            dModelTable[self.tableIndex]:Remove()
        end
        dModelTable[self.tableIndex].Entity:Remove()
    end
end

--[[ Create a DModel with clientside of the burger ]]
function RFS.CreateBurgerModel(parent, burgerTable, renderTargetName)
    local burgerModel = vgui.Create("DModelPanel", parent)
    burgerModel:SetModel("models/hunter/blocks/cube075x075x075.mdl")
    
    local spaceBurger = RFS.Constants["vector0"]

    burgerModel.condiments = burgerModel.condiments or {}
    burgerTable = burgerTable or {}
    
    for k, v in ipairs(burgerTable) do
        if not isstring(v) then continue end

        local vectorToAdd = RFS.SpaceCondiment[v]
        if not isvector(vectorToAdd) then continue end
        
        local condiment = ClientsideModel(v)
        if not IsValid(condiment) then continue end

        condiment:SetPos(RFS.Constants["vector0"])
        condiment:Spawn()
        condiment:SetNoDraw(true)
    
        burgerModel.condiments[#burgerModel.condiments + 1] = condiment
        spaceBurger = spaceBurger + RFS.SpaceCondiment[v]
    end
    
    local mn = RFS.Constants["vector550"]
    local mx = Vector(-5, 5, spaceBurger.z)
    
    local size = 0
    size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
    size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
    size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
    
    burgerModel:SetFOV(52)
    burgerModel:SetCamPos(Vector(size, size, size))
    burgerModel:SetLookAt((mn + mx) * 0.5)
    burgerModel:DockMargin(0, 0, RFS.ScrH*0.005, RFS.ScrH*0.005)

    paintDModel(burgerModel, renderTargetName)
    burgerModel.LayoutEntity = function() end

    return burgerModel, renderTargetName
end

dModelTable = dModelTable or {}

--[[ Generate render target for distributor ]]
function RFS.CreateRenderTarget(tbl, key)
    RFS.RenderTarget = RFS.RenderTarget or {}
    
    for k, v in pairs(tbl) do
        local sizeIcon = v.sizeIcon

        local dModel
        local uniqueName = (isstring(key) and key..k or k)

        if v.class == "rfs_burger" then
            dModel = RFS.CreateBurgerModel(nil, v.ingredientsTable, uniqueName)
        else
            dModel = vgui.Create("DModelPanel")
            dModel:SetModel(v.ingredientsTable[1])
            
            local mn, mx = dModel.Entity:GetRenderBounds()
            local size = 0
            size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
            size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
            size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
            
            dModel:SetFOV(45)
            dModel:SetCamPos(Vector(size, size, size))
            dModel:SetLookAt((mn + mx) * 0.5)

            paintDModel(dModel, uniqueName, true)
        end
        
        dModel:SetSize(sizeIcon[1], sizeIcon[2])
        dModel:DockMargin(0, 0, RFS.ScrH*0.005, RFS.ScrH*0.005)
        dModel.tableIndex = #dModelTable + 1

        if isfunction(v.func) then
            v.func(dModel.Entity, dModel)
        end

        dModel.LayoutEntity = function() end
        dModelTable[dModel.tableIndex] = dModel
    end
end

function RFS.Cooking.ReloadBag(bag, inventoryList, inventoryTable)
    inventoryList:Clear()
    
    local elements = {}
    for i=1, RFS.MaxInventories do
        local elementId = (#elements + 1)
        elements[elementId] = vgui.Create("DPanel", inventoryList)
        elements[elementId]:SetSize(RFS.ScrH*0.12, RFS.ScrH*0.12)
        elements[elementId].Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, RFS.Colors["white234"])
        end
    end

    local position = 1
    for k, v in ipairs(inventoryTable) do
        local class = v.class

        for id, tableEnt in pairs(v) do
            if not istable(tableEnt) then continue end

            if class == "rfs_burger" then
                local burger = RFS.CreateBurgerModel(elements[position], v.tableItem)
                burger:Dock(FILL)
                burger.position = position
                burger.DoClick = function()
                    net.Start("RFS:Cooking")
                        net.WriteUInt(3, 5)
                        net.WriteEntity(bag)
                        net.WriteUInt(burger.position, 16)
                    net.SendToServer()
                end
                burger.tableIndex = #dModelTable + 1

                dModelTable[burger.tableIndex] = burger
            else
                local model = tableEnt[1]

                local dModel = vgui.Create("DModelPanel", elements[position])
                dModel:Dock(FILL)
                dModel:SetModel(model)
 
                local mn, mx = dModel.Entity:GetRenderBounds()

                local size = 0
                size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
                size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
                size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

                dModel:SetFOV(52)
                dModel:SetCamPos(Vector(size, size, size))
                dModel:SetLookAt((mn + mx) * 0.5)
                dModel.position = position
                dModel.tableIndex = #dModelTable + 1

                dModelTable[dModel.tableIndex] = dModel
 
                dModel.LayoutEntity = function() end
                dModel.DoClick = function()
                    net.Start("RFS:Cooking")
                        net.WriteUInt(3, 5)
                        net.WriteEntity(bag, 16)
                        net.WriteUInt(dModel.position, 16)
                    net.SendToServer()
                end

                --[[ Exception ]]
                if model == "models/realistic_food_system/fries_bag.mdl" then
                    dModel.Entity:SetBodygroup(1, 1)
                    dModel:DockMargin(0, 0, RFS.ScrH*0.005, RFS.ScrH*0.005)

                elseif model == "models/realistic_food_system/cup.mdl" then
                    dModel:SetCamPos(Vector(size, size, 15))
                    dModel:SetFOV(45)
                    dModel.Entity:SetBodygroup(1, 5)

                    if IsColor(tableEnt[2]) then
                        dModel:SetColor(tableEnt[2])
                    end
                end
            end
            position = position + 1
        end
    end
end

local inventoryList
function RFS.Cooking.Bag(bag, inventoryTable)
    if not IsValid(bag) then return end
    
    if not IsValid(ingredientFrame) then
        ingredientFrame = vgui.Create("DFrame")
        ingredientFrame:SetSize(RFS.ScrW*0.3075, RFS.ScrH*0.7)
        ingredientFrame:SetPos(RFS.ScrW*0.5-RFS.ScrW*0.15, RFS.ScrW*1.5)
        ingredientFrame:MoveTo(ingredientFrame:GetX(), RFS.ScrH*0.2, 0.25, 0, 1)
        ingredientFrame:ShowCloseButton(false)
        ingredientFrame:SetDraggable(false)
        ingredientFrame:SetTitle("")
        ingredientFrame:MakePopup()
        ingredientFrame.startTime = SysTime()
        ingredientFrame.Paint = function(self, w, h)
            Derma_DrawBackgroundBlur(self, self.startTime)
            draw.RoundedBox(4, 0, 0, w, h, RFS.Colors["white246"])
                                
            draw.DrawText(RFS.GetSentence("foodBagPack"), "RFS:Font:04", w/2, h*0.027, RFS.Colors["grey2"], TEXT_ALIGN_CENTER)
            draw.DrawText(RFS.GetSentence("storeFood"), "RFS:Font:05", w/2, h*0.075, RFS.Colors["grey2"], TEXT_ALIGN_CENTER)

            draw.RoundedBox(8, w/2-w*0.4, h*0.12, w*0.8, 1, RFS.Colors["grey4"])
        end

        local scroll = vgui.Create("DScrollPanel", ingredientFrame)
        scroll:Dock(FILL)
        scroll:DockMargin(RFS.ScrW*0.01, RFS.ScrH*0.07, RFS.ScrW*0.008, RFS.ScrH*0.09)
        scroll:GetVBar():SetSize(0, 0)

        inventoryList = vgui.Create("DIconLayout", scroll)
        inventoryList:Dock(FILL)
        inventoryList:SetSpaceY(5)
        inventoryList:SetSpaceX(5)

        local lerpButton = 0
        local closeButton = vgui.Create("DButton", ingredientFrame)
        closeButton:SetSize(RFS.ScrW*0.28, RFS.ScrH*0.06)
        closeButton:SetPos(RFS.ScrW*0.308/2-RFS.ScrW*0.28/2, RFS.ScrH*0.615)
        closeButton:SetFont("RFS:Font:04")
        closeButton:SetText(RFS.GetSentence("closeBag"))
        closeButton:SetTextColor(RFS.Colors["white246"])
        closeButton.Paint = function(self, w, h)
            lerpButton = Lerp(FrameTime()*5, lerpButton, (closeButton:IsHovered() and 255 or 220))
            draw.RoundedBox(4, 0, 0, w, h, ColorAlpha(RFS.Colors["orange"], lerpButton))
        end
        closeButton.DoClick = function()
            ingredientFrame:MoveTo(ingredientFrame:GetX(), RFS.ScrH*1.5, 0.25, 0, 1, function()
                if IsValid(ingredientFrame) then ingredientFrame:Remove() end
            end)
        end
    end

    RFS.Cooking.ReloadBag(bag, inventoryList, inventoryTable)
end

--[[ Create clientside model ]]
function RFS.Cooking.ClientSide(ent, key, mdl)
    if IsValid(RFSClientside) then RFSClientside:Remove() end

    local trace = RFS.LocalPlayer:GetEyeTrace()

    local clientSide = ClientsideModel(mdl, RENDERGROUP_BOTH)
	clientSide:SetPos(trace.HitPos)
	clientSide:Spawn()
    clientSide.elementId = key
    clientSide.parentCase = ent
    clientSide.entityFilter = nil

    RFSClientside = clientSide
end

--[[ Get the correct place of the steak ]]
function RFS.Cooking.GetSteakPlace(ent)
    local steaksTable = RFS.GetNWVariables("steaks", ent) or {}

    for i=1, 8 do
        local steakTable = steaksTable[i] or {}
        if not isnumber(steakTable["entIndex"]) then return i end

        local ent = Entity(steakTable["entIndex"])
        if not IsValid(ent) then return i end
    end
end

--[[ Get table of the steak by his id ]]
function RFS.Cooking.GetTableBySteakId(ent, entIndex)
    local steaksTable = RFS.GetNWVariables("steaks", ent) or {}
    
    for k, v in pairs(steaksTable) do
        if v.entIndex == entIndex then return v end
    end
end

--[[ Update clientside model position, angle, and color ]]
hook.Add("Think", "RFS:Think:ClientSide", function()
    if not IsValid(RFSClientside) then return end
    if not IsValid(RFSClientside.parentCase) then RFSClientside:Remove() end

    local traceEnt = RFS.LocalPlayer:GetEyeTrace().Entity
		
	if IsValid(traceEnt:GetParent()) && traceEnt:GetParent():GetClass() == "rfs_plank_burger" then
		traceEnt = traceEnt:GetParent()
	end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- cc730fea56651a2f58f71217edee9cc3d8e88105144a63103b4cdff76fc2b0b3
		
    local traceClass = traceEnt:GetClass()
    
    local trace = util.TraceLine({
        start = RFS.LocalPlayer:EyePos(),
        endpos = (IsValid(traceEnt) && traceClass == "rfs_terminal" && traceEnt:GetModel() == "") and traceEnt:LocalToWorld(traceEnt:OBBCenter()) or RFS.LocalPlayer:EyePos() + RFS.LocalPlayer:EyeAngles():Forward() * 120,
        filter = function(ent) if ent:GetClass() != "player" then return true end end
    })
    
    RFS.CookingElement[RFSClientside.elementId] = RFS.CookingElement[RFSClientside.elementId] or {}
    local clientSideTable = RFS.CookingElement[RFSClientside.elementId]["clientSideModel"]
    
    RFSClientside.entityFilter = nil

    if IsValid(traceEnt) && clientSideTable["filter"] && clientSideTable["filter"][traceClass] && isfunction(clientSideTable.func) then
        local result = clientSideTable.func(traceEnt, RFSClientside.parentCase)

        if result then
            RFSClientside.entityFilter = traceEnt
        else
            RFSClientside:SetPos(trace.HitPos)
            RFSClientside:SetAngles(RFS.Constants["angle0"])
        end
    else
        RFSClientside:SetPos(trace.HitPos)
        RFSClientside:SetAngles(RFS.Constants["angle0"])
    end
end)

--[[ Draw beam for connection ]]
hook.Add("PostDrawTranslucentRenderables", "RFS:PostDrawTranslucentRenderables:ClientSide", function()
    if not IsValid(RFSClientside) or not IsValid(RFSClientside.parentCase) then return end

    local validFilter = IsValid(RFSClientside.entityFilter)
    local tooFar = RFS.LocalPlayer:GetPos():DistToSqr((validFilter and RFSClientside.entityFilter:GetPos() or RFSClientside.parentCase:GetPos())) > 200000

    local color = validFilter && not tooFar and RFS.Colors["green"] or RFS.Colors["red2"]
    RFS.Halo.Add(RFSClientside, color, OUTLINE_MODE_VISIBLE)

    if IsValid(RFSClientside) then
        RFS.DrawBeam(RFSClientside.parentCase, RFSClientside, color)
    end
end)

local antiSpam
hook.Add("PlayerButtonDown", "RFS:PlayerButtonDown:CookingUse", function(ply, button)
    if IsValid(RFSClientside) then
        if button == MOUSE_LEFT or ply:KeyDown(IN_USE) then
            local ent = ply:GetEyeTrace().Entity
	
            if IsValid(ent:GetParent()) && ent:GetParent():GetClass() == "rfs_plank_burger" then
                ent = ent:GetParent()
            end

            local key = RFSClientside.elementId

            RFS.CookingElement[key] = RFS.CookingElement[key] or {}
            local actionTable = RFS.CookingElement[key]
            local clientSideTable = actionTable["clientSideModel"]
        
            if IsValid(ent) && clientSideTable["filter"] && clientSideTable["filter"][ent:GetClass()] && isfunction(actionTable.action) then
                local curTime = CurTime()
                
                antiSpam = antiSpam or 0
                if antiSpam > curTime then return end
                antiSpam = curTime + 0.5
                
                local result = clientSideTable.func(ent, RFSClientside.parentCase)
                if result then
                    actionTable.action(ent)

                    net.Start("RFS:Cooking")
                        net.WriteUInt(1, 5)
                        net.WriteEntity(ent, 16)
                        net.WriteString(key)
                        net.WriteEntity(RFSClientside.parentCase, 16)
                    net.SendToServer()
                end
            end
        elseif button == MOUSE_RIGHT then
            if RFS.DrawScreenLink then
                RFS.LinkTerminal = {}
                RFS.DrawScreenLink = nil
            end

            if IsValid(RFSClientside) then
                RFSClientside:Remove()
            end
        end
    end
end)

--[[ Get space of all condiments ]]
function RFS.GetSpaceBurger(burger, notCheckBottom)
    if burger:GetClass() == "rfs_plank_burger" then
        local children = burger:GetChildren()

        burger = children[1]
    end
    
    local validBurger = IsValid(burger)
    if not validBurger && RFSClientside:GetModel() == "models/realistic_food_system/burger_bottom_bun.mdl" then
        return RFS.Constants["vector175"]
    end
    if not IsValid(burger) && not validBurger then return end
    
    RFS.BurgerCreated = RFS.BurgerCreated or {}

    local burgerEntIndex = burger:EntIndex()
    local burgerTable = RFS.BurgerCreated[burgerEntIndex] or {}
    local bottom = burgerTable[1]

    local placeToSet = RFS.Constants["vector175"]
    for k, v in ipairs(burgerTable) do
        if not IsValid(v) then continue end

        local model = v:GetModel()
        if not isvector(RFS.SpaceCondiment[model]) then continue end

        placeToSet = placeToSet + RFS.SpaceCondiment[model]
    end

    local count = RFS.BurgerCreated[burgerEntIndex] and #RFS.BurgerCreated[burgerEntIndex] or 0
    local previousCondiment = burgerTable[count] or {}

    if IsValid(RFSClientside) then
        if IsValid(previousCondiment) && previousCondiment:GetModel() == RFSClientside:GetModel() then
            RFSClientside:SetAngles(burger:LocalToWorldAngles(previousCondiment:GetAngles() + RFS.Constants["angle0902"]))
        else
            RFSClientside:SetAngles(burger:LocalToWorldAngles(RFS.Constants["angle090"]))
        end
    end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461264

    return placeToSet
end

function RFS.Cooking.CheckMaxSizeBurger(ent)
    if not IsValid(ent) then return end
    
    local childrens = ent:GetChildren()
    if istable(childrens) && IsValid(childrens[1]) then
        local burgerEntIndex = ent:GetChildren()[1]:EntIndex()
        
        local condiments = RFS.BurgerCreated[burgerEntIndex]
        if istable(condiments) then
            if #condiments > RFS.MaxBurgerSize && model != "models/realistic_food_system/burger_bottom_bun.mdl" then return false end
        end
    end

    return true
end

net.Receive("RFS:Cooking", function()
    local uInt = net.ReadUInt(5)

    --[[ Remove clientside model when you right click or do the action ]]
    if uInt == 1 then
        if IsValid(RFSClientside) then 
            RFSClientside.entityFilter = nil
            RFSClientside:Remove() 
        end
        
    --[[ Create the clientside model ]]
    elseif uInt == 2 then
        local ent = net.ReadEntity()
        if not IsValid(ent) then return end

        local key = net.ReadString()
        
        local cookingTable = RFS.CookingElement[key]
        if not cookingTable then return end

        local clientSideTable = cookingTable["clientSideModel"]
        if not clientSideTable then return end

        if isfunction(clientSideTable["canInteract"]) then
            if not clientSideTable["canInteract"](ent) then
                return
            end
        end
                                                                                                                                                                                                                                                                                                                                                                                                                                                       -- 76561199814461257

        RFS.Cooking.ClientSide(ent, key, clientSideTable["mdl"])

        if IsValid(ingredientFrame) then
            ingredientFrame:MoveTo(ingredientFrame:GetX(), RFS.ScrH*1.5, 0.25, 0, 1, function()
                if IsValid(ingredientFrame) then ingredientFrame:Remove() end
            end)
        end
        
    --[[ Create the condiments ]]
    elseif uInt == 3 then
        local count = net.ReadUInt(16)
        
        for i=1, count do
            local burger = net.ReadEntity()
            if not IsValid(burger) then continue end

            local model = net.ReadString()

            local burgerEntIndex = burger:EntIndex()

            RFS.BurgerCreated = RFS.BurgerCreated or {}
            RFS.BurgerCreated[burgerEntIndex] = RFS.BurgerCreated[burgerEntIndex] or {}
            
            local placeToSet = RFS.GetSpaceBurger(burger, true)
            local previousCondiment = RFS.BurgerCreated[burgerEntIndex][#RFS.BurgerCreated[burgerEntIndex]]
            local parent = burger:GetInternalVariable("m_hNetworkMoveParent")

            local condiment = ClientsideModel(model)
            condiment:SetPos(burger:LocalToWorld(placeToSet))
            condiment:SetAngles(burger:LocalToWorldAngles(RFS.Constants["angle090"]))
            condiment:Spawn()
            condiment.localPos = placeToSet

            if condiment:GetModel() == "models/realistic_food_system/burger_steak.mdl" then
                condiment:SetColor(RFS.Colors["grilledSteak"])
            end

            RFS.BurgerCreated[burgerEntIndex][#RFS.BurgerCreated[burgerEntIndex] + 1] = condiment

            burger:CallOnRemove("rfs_reset_variables:"..burger:EntIndex(), function(burger)
                timer.Simple(0, function()
                    if not IsValid(burger) then
                        for k, v in ipairs(RFS.BurgerCreated[burgerEntIndex]) do
                            if IsValid(v) then v:Remove() end
        
                            RFS.BurgerCreated[burgerEntIndex] = nil
                        end
                    end
                end)
            end) 
        end
        
    --[[ Add something into the inventory ]]
    elseif uInt == 4 then
        local inventoryTable = {}

        local bag = net.ReadEntity()
        local tableCount = net.ReadUInt(16)
        for i=1, tableCount do
            local class = net.ReadString()

            local tableItem = {}
            local tableCount = net.ReadUInt(16)
            for i=1, tableCount do
                local valueType = net.ReadString()
                local value = net["Read"..RFS.TypeNet[valueType]](((RFS.TypeNet[valueType] == "Int") and 32))

                tableItem[#tableItem + 1] = value
            end
            
            inventoryTable[#inventoryTable + 1] = {
                ["tableItem"] = tableItem,
                ["class"] = class,
            }
        end

        RFS.Cooking.Bag(bag, inventoryTable)
    elseif uInt == 5 then
        local ent = net.ReadEntity()
        local uniqueName = net.ReadString()

        net.Start("RFS:Cooking")
            net.WriteUInt(2, 5)
            net.WriteEntity(ent)
            net.WriteString(uniqueName)
        net.SendToServer()
    end
end)
