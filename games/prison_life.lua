--[[
  Fpliz Hub - Prison Life
  UI: Luna
  Chave: FPLIZ
]]

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua"))()

local Window = Luna:CreateWindow({
    Name = "Fpliz Hub",
    Subtitle = "Prison Life",
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
    Content = "Bem-vindo ao Prison Life!"
})

-- ==================== SERVIÇOS ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

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
local speedEnabled = false
local infiniteJumpEnabled = false
local killAuraEnabled = false
local autoArrestEnabled = false
local godModeEnabled = false

local flyConnection, noclipConnection, espConnection, antiAfkConnection = nil, nil, nil, nil
local autoClickConnection, speedConnection, infiniteJumpConnection = nil, nil, nil
local killAuraConnection, autoArrestConnection = nil, nil

-- Kill Aura
local killAuraRange = 50
local killAuraDelay = 0.5

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

local function startSpeed()
    if speedEnabled then return end
    speedEnabled = true
    humanoid.WalkSpeed = 100
    
    speedConnection = RunService.Heartbeat:Connect(function()
        if not speedEnabled then return end
        local moveDirection = humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            rootPart.CFrame = rootPart.CFrame + (moveDirection * 1)
        end
    end)
    notify("Speed", "Ativado!", "bolt")
end

local function stopSpeed()
    speedEnabled = false
    if speedConnection then speedConnection:Disconnect() end
    speedConnection = nil
    humanoid.WalkSpeed = 16
    notify("Speed", "Desativado", "bolt")
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

-- ==================== GOD MODE ====================
local function startGodMode()
    if godModeEnabled then return end
    godModeEnabled = true
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    notify("God Mode", "Ativado!", "shield")
end

local function stopGodMode()
    godModeEnabled = false
    humanoid.MaxHealth = 100
    humanoid.Health = 100
    notify("God Mode", "Desativado", "shield")
end

-- ==================== KILL AURA ====================
local function getNearestPlayer()
    local nearest = nil
    local nearestDist = killAuraRange
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local plrHumanoid = plr.Character:FindFirstChild("Humanoid")
            if plrHumanoid and plrHumanoid.Health > 0 then
                local dist = (plr.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                if dist < nearestDist then
                    nearest = plr
                    nearestDist = dist
                end
            end
        end
    end
    
    return nearest
end

local function startKillAura()
    if killAuraEnabled then return end
    killAuraEnabled = true
    notify("Kill Aura", "Ativado!", "gavel")
    
    task.spawn(function()
        while killAuraEnabled do
            local target = getNearestPlayer()
            if target and target.Character then
                local targetHumanoid = target.Character:FindFirstChild("Humanoid")
                if targetHumanoid and targetHumanoid.Health > 0 then
                    -- Teleporta para o alvo
                    rootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
                    task.wait(0.1)
                    
                    -- Ataca
                    pcall(function()
                        game:GetService("ReplicatedStorage"):FindFirstChild("MeleeEvent"):FireServer(target)
                    end)
                    
                    pcall(function()
                        local tool = character:FindFirstChildOfClass("Tool")
                        if tool then
                            tool:Activate()
                            task.wait(0.1)
                            tool:Deactivate()
                        end
                    end)
                    
                    pcall(function()
                        targetHumanoid.Health = 0
                    end)
                end
            end
            task.wait(killAuraDelay)
        end
    end)
end

local function stopKillAura()
    killAuraEnabled = false
    if killAuraConnection then killAuraConnection:Disconnect() end
    killAuraConnection = nil
    notify("Kill Aura", "Desativado", "gavel")
end

-- ==================== AUTO ARREST ====================
local function startAutoArrest()
    if autoArrestEnabled then return end
    autoArrestEnabled = true
    notify("Auto Arrest", "Ativado!", "local_police")
    
    task.spawn(function()
        while autoArrestEnabled do
            local target = getNearestPlayer()
            if target and target.Character then
                local targetHumanoid = target.Character:FindFirstChild("Humanoid")
                if targetHumanoid and targetHumanoid.Health > 0 then
                    -- Teleporta para o alvo
                    rootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
                    task.wait(0.1)
                    
                    -- Tenta prender
                    pcall(function()
                        local tool = character:FindFirstChildOfClass("Tool")
                        if tool and tool.Name:lower():find("handcuff") then
                            tool:Activate()
                            task.wait(0.1)
                            tool:Deactivate()
                        end
                    end)
                    
                    pcall(function()
                        game:GetService("ReplicatedStorage"):FindFirstChild("ArrestEvent"):FireServer(target)
                    end)
                end
            end
            task.wait(1)
        end
    end)
end

local function stopAutoArrest()
    autoArrestEnabled = false
    if autoArrestConnection then autoArrestConnection:Disconnect() end
    autoArrestConnection = nil
    notify("Auto Arrest", "Desativado", "local_police")
end

-- ==================== ESP ====================
local playerHighlights = {}
local function startESP()
    if espEnabled then return end
    espEnabled = true
    espConnection = RunService.Heartbeat:Connect(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if not playerHighlights[plr] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ESP_" .. plr.Name
                    
                    -- Verifica se é guarda ou prisioneiro
                    local isGuard = false
                    pcall(function()
                        if plr.TeamColor == BrickColor.new("Bright blue") then
                            isGuard = true
                        end
                    end)
                    
                    hl.FillColor = isGuard and Color3.fromRGB(0, 0, 255) or Color3.fromRGB(255, 0, 0)
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
    notify("ESP", "Azul=Guarda, Vermelho=Prisioneiro", "visibility")
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

-- ==================== UI ====================
local MovementTab = Window:CreateTab({ Name = "Movimento", Icon = "directions_run", ImageSource = "Material", ShowTitle = true })
local CombatTab = Window:CreateTab({ Name = "Combate", Icon = "gavel", ImageSource = "Material", ShowTitle = true })
local VisualTab = Window:CreateTab({ Name = "Visuals", Icon = "visibility", ImageSource = "Material", ShowTitle = true })
local SettingsTab = Window:CreateTab({ Name = "Settings", Icon = "settings", ImageSource = "Material", ShowTitle = true })

-- Movement
MovementTab:CreateSection("Movimento")
MovementTab:CreateToggle({
    Name = "Fly",
    Description = "Controles: WASD, Espaço, Shift",
    CurrentValue = false,
    Callback = function(v) if v then startFly() else stopFly() end end
}, "Fly")

MovementTab:CreateToggle({
    Name = "Noclip",
    Description = "Atravessa paredes",
    CurrentValue = false,
    Callback = function(v) if v then startNoclip() else stopNoclip() end end
}, "Noclip")

MovementTab:CreateToggle({
    Name = "Speed",
    Description = "Velocidade aumentada",
    CurrentValue = false,
    Callback = function(v) if v then startSpeed() else stopSpeed() end end
}, "Speed")

MovementTab:CreateToggle({
    Name = "Pulo Infinito",
    Description = "Pula automaticamente",
    CurrentValue = false,
    Callback = function(v) if v then startInfiniteJump() else stopInfiniteJump() end end
}, "InfiniteJump")

-- Combat
CombatTab:CreateSection("Combate")
CombatTab:CreateToggle({
    Name = "God Mode",
    Description = "Vida infinita",
    CurrentValue = false,
    Callback = function(v) if v then startGodMode() else stopGodMode() end end
}, "GodMode")

CombatTab:CreateToggle({
    Name = "Kill Aura",
    Description = "Mata jogadores próximos",
    CurrentValue = false,
    Callback = function(v) if v then startKillAura() else stopKillAura() end end
}, "KillAura")

CombatTab:CreateSlider({
    Name = "Alcance",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(v) killAuraRange = v end
}, "KillAuraRange")

CombatTab:CreateToggle({
    Name = "Auto Arrest",
    Description = "Prende jogadores próximos",
    CurrentValue = false,
    Callback = function(v) if v then startAutoArrest() else stopAutoArrest() end end
}, "AutoArrest")

-- Visuals
VisualTab:CreateSection("ESP")
VisualTab:CreateToggle({
    Name = "ESP de Jogadores",
    Description = "Azul=Guarda, Vermelho=Prisioneiro",
    CurrentValue = false,
    Callback = function(v) if v then startESP() else stopESP() end end
}, "ESP")

VisualTab:CreateSection("Iluminação")
VisualTab:CreateToggle({
    Name = "Fullbright",
    Description = "Ilumina o mapa",
    CurrentValue = false,
    Callback = function(v) if v then startFullbright() else stopFullbright() end end
}, "Fullbright")

-- Settings
SettingsTab:CreateSection("Auto")
SettingsTab:CreateToggle({
    Name = "Anti-AFK",
    Description = "Previne kick por inatividade",
    CurrentValue = false,
    Callback = function(v) if v then startAntiAfk() else stopAntiAfk() end end
}, "AntiAFK")

SettingsTab:CreateToggle({
    Name = "Auto Click",
    Description = "Clica automaticamente",
    CurrentValue = false,
    Callback = function(v) if v then startAutoClick() else stopAutoClick() end end
}, "AutoClick")

SettingsTab:BuildThemeSection()
SettingsTab:BuildConfigSection()

-- Handler de morte
humanoid.Died:Connect(function()
    stopFly()
    stopNoclip()
    stopSpeed()
    stopInfiniteJump()
    stopKillAura()
    stopAutoArrest()
    stopESP()
    stopAntiAfk()
    stopAutoClick()
    task.wait(3)
    character = player.Character
    if character then
        humanoid = character:WaitForChild("Humanoid")
        rootPart = character:WaitForChild("HumanoidRootPart")
    end
end)

-- Handler de time
player:GetPropertyChangedSignal("Team"):Connect(function()
    notify("Time", "Você mudou de time!", "info")
end)
