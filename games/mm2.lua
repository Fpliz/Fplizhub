--[[
  Fpliz Hub - Murder Mystery 2
  Script para o loader universal
]]

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua"))()

local Window = Luna:CreateWindow({
    Name = "Fpliz Hub",
    Subtitle = "Murder Mystery 2",
    LogoID = "82795327169782",
    LoadingEnabled = true,
    LoadingTitle = "Fpliz Hub",
    LoadingSubtitle = "Carregando...",
    ConfigSettings = { ConfigFolder = "FplizHub" },
    KeySystem = true,
    KeySettings = {
        Title = "Fpliz Hub Key",
        Subtitle = "Key System",
        Note = "Chave: FPLIZ",
        FileName = "FplizHubKey",
        SaveKey = true,
        Key = {"FPLIZ"}
    }
})

Window:CreateHomeTab({
    SupportedExecutors = {"Synapse X", "Krnl", "Fluxus", "Script-Ware", "Delta", "Wave", "Xeno"},
    DiscordInvite = "",
    Icon = 1
})

Luna:Notification({
    Title = "Fpliz Hub",
    Icon = "check_circle",
    ImageSource = "Material",
    Content = "Bem-vindo ao MM2!"
})

-- ==================== SERVIÇOS ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- Estados
local flyEnabled = false
local noclipEnabled = false
local espEnabled = false
local fullbrightEnabled = false
local antiAfkEnabled = false
local autoClickEnabled = false
local speedHackEnabled = false
local infiniteJumpEnabled = false
local aimbotEnabled = false

local flyConnection, noclipConnection, espConnection, antiAfkConnection = nil, nil, nil, nil
local autoClickConnection, speedHackConnection, infiniteJumpConnection = nil, nil, nil
local aimbotConnection = nil

-- Aimbot
local aimbotTarget = "Todos"
local aimbotPart = "Head"
local aimbotFOV = 120
local aimbotSmoothness = 0.5
local aimbotDistance = 500

local function notify(title, content, icon)
    icon = icon or "info"
    Luna:Notification({ Title = title, Icon = icon, ImageSource = "Material", Content = content })
end

-- ==================== MOVIMENTO ====================
local function startFly()
    if flyEnabled then return end
    flyEnabled = true
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = rootPart

    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyEnabled then return end
        local moveDirection = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection += camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection -= camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection -= camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection += camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection -= Vector3.new(0, 1, 0) end
        bodyVelocity.Velocity = moveDirection * 50
        bodyGyro.CFrame = camera.CFrame
    end)
    notify("Fly", "Ativado! WASD, Espaço, Shift", "flight")
end

local function stopFly()
    flyEnabled = false
    if flyConnection then flyConnection:Disconnect() end
    flyConnection = nil
    if rootPart:FindFirstChild("BodyGyro") then rootPart.BodyGyro:Destroy() end
    if rootPart:FindFirstChild("BodyVelocity") then rootPart.BodyVelocity:Destroy() end
    notify("Fly", "Desativado", "flight")
end

local function startNoclip()
    if noclipEnabled then return end
    noclipEnabled = true
    noclipConnection = RunService.Stepped:Connect(function()
        if noclipEnabled and character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
    notify("Noclip", "Ativado", "check_circle")
end

local function stopNoclip()
    noclipEnabled = false
    if noclipConnection then noclipConnection:Disconnect() end
    noclipConnection = nil
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
    notify("Noclip", "Desativado", "check_circle")
end

local function startSpeedHack()
    if speedHackEnabled then return end
    speedHackEnabled = true
    speedHackConnection = RunService.Heartbeat:Connect(function()
        if speedHackEnabled and humanoid then
            humanoid.WalkSpeed = 100
        end
    end)
    notify("Speed Hack", "Ativado", "bolt")
end

local function stopSpeedHack()
    speedHackEnabled = false
    if speedHackConnection then speedHackConnection:Disconnect() end
    speedHackConnection = nil
    humanoid.WalkSpeed = 16
    notify("Speed Hack", "Desativado", "bolt")
end

local function startInfiniteJump()
    if infiniteJumpEnabled then return end
    infiniteJumpEnabled = true
    infiniteJumpConnection = RunService.Heartbeat:Connect(function()
        if infiniteJumpEnabled and humanoid then
            humanoid.Jump = true
        end
    end)
    notify("Pulo Infinito", "Ativado", "arrow_upward")
end

local function stopInfiniteJump()
    infiniteJumpEnabled = false
    if infiniteJumpConnection then infiniteJumpConnection:Disconnect() end
    infiniteJumpConnection = nil
    notify("Pulo Infinito", "Desativado", "arrow_upward")
end

-- ==================== AIMBOT ====================
local function getPlayerRole(plr)
    if not plr.Character then return "Innocent" end
    local shirt = plr.Character:FindFirstChildOfClass("Shirt")
    if shirt and shirt.Color3 == Color3.fromRGB(255, 0, 0) then
        return "Murderer"
    elseif shirt and shirt.Color3 == Color3.fromRGB(0, 0, 255) then
        return "Sheriff"
    else
        return "Innocent"
    end
end

local function getBodyPart(plr, partName)
    local char = plr.Character
    if not char then return nil end
    
    local part = char:FindFirstChild(partName)
    if part and part:IsA("BasePart") then return part end
    
    if partName == "Head" then return char:FindFirstChild("Head") or char:FindFirstChild("Torso") end
    if partName == "Torso" then return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") end
    if partName == "Left Arm" then return char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm") end
    if partName == "Right Arm" then return char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm") end
    if partName == "Left Leg" then return char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg") end
    if partName == "Right Leg" then return char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg") end
    
    return nil
end

local function getAimbotTarget()
    local nearest = nil
    local nearestDist = aimbotDistance
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local role = getPlayerRole(plr)
            local podeMirar = true
            
            if aimbotTarget == "Assassinos" and role ~= "Murderer" then podeMirar = false end
            if aimbotTarget == "Xerifes" and role ~= "Sheriff" then podeMirar = false end
            
            if podeMirar then
                local targetPart = getBodyPart(plr, aimbotPart)
                if targetPart then
                    local dist = (targetPart.Position - camera.CFrame.Position).Magnitude
                    if dist < nearestDist then
                        local screenPos = camera:WorldToScreenPoint(targetPart.Position)
                        local screenCenter = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
                        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if screenDist < aimbotFOV then
                            nearest = targetPart
                            nearestDist = dist
                        end
                    end
                end
            end
        end
    end
    
    return nearest
end

local function startAimbot()
    if aimbotEnabled then return end
    aimbotEnabled = true
    
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not aimbotEnabled then return end
        
        local target = getAimbotTarget()
        if target then
            local targetVel = target.Velocity or Vector3.new(0, 0, 0)
            local predictedPos = target.Position + targetVel * 0.05
            local lookAt = CFrame.new(camera.CFrame.Position, predictedPos)
            camera.CFrame = camera.CFrame:Lerp(lookAt, aimbotSmoothness)
        end
    end)
    notify("Aimbot", "Ativado!", "my_location")
end

local function stopAimbot()
    aimbotEnabled = false
    if aimbotConnection then aimbotConnection:Disconnect() end
    aimbotConnection = nil
    notify("Aimbot", "Desativado", "my_location")
end

-- ==================== ESP ====================
local playerHighlights = {}
local function startESP()
    if espEnabled then return end
    espEnabled = true
    espConnection = RunService.Heartbeat:Connect(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local role = getPlayerRole(plr)
                if not playerHighlights[plr] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ESP_" .. plr.Name
                    hl.FillColor = role == "Murderer" and Color3.fromRGB(255, 0, 0) or role == "Sheriff" and Color3.fromRGB(0, 0, 255) or Color3.fromRGB(0, 255, 0)
                    hl.OutlineColor = hl.FillColor
                    hl.FillTransparency = 0.5
                    hl.Parent = plr.Character
                    playerHighlights[plr] = hl
                end
            end
        end
        
        for plr, hl in pairs(playerHighlights) do
            if not plr.Character or not hl.Parent then
                hl:Destroy()
                playerHighlights[plr] = nil
            end
        end
    end)
    notify("ESP", "Vermelho=Murder, Azul=Sheriff, Verde=Innocent", "visibility")
end

local function stopESP()
    espEnabled = false
    if espConnection then espConnection:Disconnect() end
    espConnection = nil
    for plr, hl in pairs(playerHighlights) do
        hl:Destroy()
    end
    playerHighlights = {}
    notify("ESP", "Desativado", "visibility")
end

-- ==================== FULLBRIGHT ====================
local function startFullbright()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    notify("Fullbright", "Ativado", "light_mode")
end

local function stopFullbright()
    Lighting.Brightness = 1
    Lighting.FogEnd = 1000
    Lighting.GlobalShadows = true
    notify("Fullbright", "Desativado", "light_mode")
end

-- ==================== AUTO CLICK ====================
local function startAutoClick()
    if autoClickEnabled then return end
    autoClickEnabled = true
    autoClickConnection = RunService.Heartbeat:Connect(function()
        if autoClickEnabled then
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
        end
    end)
    notify("Auto Click", "Ativado", "mouse")
end

local function stopAutoClick()
    autoClickEnabled = false
    if autoClickConnection then autoClickConnection:Disconnect() end
    autoClickConnection = nil
    notify("Auto Click", "Desativado", "mouse")
end

-- ==================== ANTI-AFK ====================
local function startAntiAfk()
    if antiAfkEnabled then return end
    antiAfkEnabled = true
    antiAfkConnection = RunService.Heartbeat:Connect(function()
        if antiAfkEnabled then
            task.wait(180)
            pcall(function()
                humanoid.Jump = true
            end)
        end
    end)
    notify("Anti-AFK", "Ativado", "timer")
end

local function stopAntiAfk()
    antiAfkEnabled = false
    if antiAfkConnection then antiAfkConnection:Disconnect() end
    antiAfkConnection = nil
    notify("Anti-AFK", "Desativado", "timer")
end

-- ==================== TELEPORTES ====================
local function rejoinServer()
    TeleportService:Teleport(game.PlaceId, player)
end

local function serverHop()
    local servers = {}
    pcall(function()
        servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
    end)
    if servers.data and #servers.data > 0 then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, servers.data[math.random(#servers.data)].id, player)
    else
        notify("Server Hop", "Nenhum servidor encontrado", "error")
    end
end

-- ==================== UI ====================
local AimbotTab = Window:CreateTab({ Name = "Aimbot", Icon = "my_location", ImageSource = "Material", ShowTitle = true })
local MovementTab = Window:CreateTab({ Name = "Movimento", Icon = "directions_run", ImageSource = "Material", ShowTitle = true })
local VisualTab = Window:CreateTab({ Name = "Visuals", Icon = "visibility", ImageSource = "Material", ShowTitle = true })
local TeleportTab = Window:CreateTab({ Name = "Teleportes", Icon = "location_on", ImageSource = "Material", ShowTitle = true })
local SettingsTab = Window:CreateTab({ Name = "Settings", Icon = "settings", ImageSource = "Material", ShowTitle = true })

-- Aimbot
AimbotTab:CreateSection("Aimbot")
AimbotTab:CreateToggle({
    Name = "Aimbot",
    Description = "Mira automaticamente",
    CurrentValue = false,
    Callback = function(v) if v then startAimbot() else stopAimbot() end end
}, "Aimbot")

AimbotTab:CreateDropdown({
    Name = "Alvo",
    Options = {"Todos", "Assassinos", "Xerifes"},
    CurrentOption = "Todos",
    MultipleOptions = false,
    Callback = function(v) aimbotTarget = v end
}, "AimbotTarget")

AimbotTab:CreateDropdown({
    Name = "Parte do Corpo",
    Options = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"},
    CurrentOption = "Head",
    MultipleOptions = false,
    Callback = function(v) aimbotPart = v end
}, "AimbotPart")

AimbotTab:CreateSlider({
    Name = "FOV",
    Range = {10, 360},
    Increment = 5,
    CurrentValue = 120,
    Callback = function(v) aimbotFOV = v end
}, "AimbotFOV")

AimbotTab:CreateSlider({
    Name = "Suavidade",
    Range = {0.1, 1},
    Increment = 0.05,
    CurrentValue = 0.5,
    Callback = function(v) aimbotSmoothness = v end
}, "AimbotSmoothness")

-- Movement
MovementTab:CreateSection("Movimento")
MovementTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(v) if v then startFly() else stopFly() end end
}, "Fly")

MovementTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(v) if v then startNoclip() else stopNoclip() end end
}, "Noclip")

MovementTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Callback = function(v) if v then startSpeedHack() else stopSpeedHack() end end
}, "SpeedHack")

MovementTab:CreateToggle({
    Name = "Pulo Infinito",
    CurrentValue = false,
    Callback = function(v) if v then startInfiniteJump() else stopInfiniteJump() end end
}, "InfiniteJump")

-- Visuals
VisualTab:CreateSection("ESP")
VisualTab:CreateToggle({
    Name = "ESP de Jogadores",
    Description = "Vermelho=Murder, Azul=Sheriff, Verde=Innocent",
    CurrentValue = false,
    Callback = function(v) if v then startESP() else stopESP() end end
}, "ESP")

VisualTab:CreateSection("Iluminação")
VisualTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Callback = function(v) if v then startFullbright() else stopFullbright() end end
}, "Fullbright")

-- Teleports
TeleportTab:CreateSection("Teleportes")
TeleportTab:CreateButton({
    Name = "Rejoin",
    Callback = rejoinServer
})

TeleportTab:CreateButton({
    Name = "Server Hop",
    Callback = serverHop
})

-- Settings
SettingsTab:CreateSection("Auto")
SettingsTab:CreateToggle({
    Name = "Auto Click",
    CurrentValue = false,
    Callback = function(v) if v then startAutoClick() else stopAutoClick() end end
}, "AutoClick")

SettingsTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Callback = function(v) if v then startAntiAfk() else stopAntiAfk() end end
}, "AntiAFK")

SettingsTab:BuildThemeSection()
SettingsTab:BuildConfigSection()

-- Handlers
humanoid.Died:Connect(function()
    stopFly()
    stopNoclip()
    stopESP()
    stopAntiAfk()
    stopAutoClick()
    stopSpeedHack()
    stopInfiniteJump()
    stopAimbot()
    task.wait(3)
    character = player.Character
    if character then
        humanoid = character:WaitForChild("Humanoid")
        rootPart = character:WaitForChild("HumanoidRootPart")
    end
end)
