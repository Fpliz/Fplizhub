--[[
  Fpliz Hub - Ninja Legends
  UI: Luna
  Chave: FPLIZ
]]

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua"))()

local Window = Luna:CreateWindow({
    Name = "Fpliz Hub",
    Subtitle = "Ninja Legends",
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
    Content = "Bem-vindo ao Ninja Legends!"
})

-- ==================== SERVIÇOS ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
local autoFarmEnabled = false
local autoTrainEnabled = false
local autoSellEnabled = false
local autoBuyEnabled = false
local autoRebirthEnabled = false
local autoEquipBestEnabled = false
local autoSwingEnabled = false
local killAuraEnabled = false
local godModeEnabled = false

local flyConnection, noclipConnection, espConnection, antiAfkConnection = nil, nil, nil, nil
local autoClickConnection, speedConnection, infiniteJumpConnection = nil, nil, nil
local autoFarmConnection, autoTrainConnection, autoSellConnection = nil, nil, nil
local autoBuyConnection, autoRebirthConnection, autoEquipConnection = nil, nil, nil
local autoSwingConnection, killAuraConnection = nil, nil

-- Configurações
local farmDistance = 50
local swingSpeed = 0.1

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

-- ==================== FUNÇÕES DE NINJA LEGENDS ====================
local function getEnemies()
    local enemies = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            local objHumanoid = obj:FindFirstChild("Humanoid")
            if objHumanoid.Health > 0 and obj.Name ~= character.Name then
                local isNPC = true
                pcall(function()
                    local plr = Players:GetPlayerFromCharacter(obj)
                    if plr then isNPC = false end
                end)
                
                if isNPC then
                    table.insert(enemies, obj)
                end
            end
        end
    end
    return enemies
end

local function getNearestEnemy()
    local enemies = getEnemies()
    local nearest = nil
    local nearestDist = farmDistance
    
    for _, enemy in ipairs(enemies) do
        local dist = (enemy.HumanoidRootPart.Position - rootPart.Position).Magnitude
        if dist < nearestDist then
            nearest = enemy
            nearestDist = dist
        end
    end
    
    return nearest
end

local function getPlayerStats()
    local stats = {
        Strength = 0,
        Chakra = 0,
        Coins = 0,
        Gems = 0,
        Rebirths = 0,
        Level = 0
    }
    
    pcall(function()
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            if leaderstats:FindFirstChild("Strength") then stats.Strength = leaderstats.Strength.Value end
            if leaderstats:FindFirstChild("Chakra") then stats.Chakra = leaderstats.Chakra.Value end
            if leaderstats:FindFirstChild("Coins") then stats.Coins = leaderstats.Coins.Value end
            if leaderstats:FindFirstChild("Gems") then stats.Gems = leaderstats.Gems.Value end
            if leaderstats:FindFirstChild("Rebirths") then stats.Rebirths = leaderstats.Rebirths.Value end
            if leaderstats:FindFirstChild("Level") then stats.Level = leaderstats.Level.Value end
        end
    end)
    
    return stats
end

local function getSwords()
    local swords = {}
    pcall(function()
        for _, tool in ipairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Damage") then
                table.insert(swords, {name = tool.Name, damage = tool.Damage.Value, tool = tool})
            end
        end
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Damage") then
                table.insert(swords, {name = tool.Name, damage = tool.Damage.Value, tool = tool})
            end
        end
    end)
    
    table.sort(swords, function(a, b)
        return a.damage > b.damage
    end)
    
    return swords
end

local function equipSword(sword)
    pcall(function()
        humanoid:EquipTool(sword.tool)
    end)
end

-- ==================== AUTO FARM ====================
local function startAutoFarm()
    if autoFarmEnabled then return end
    autoFarmEnabled = true
    notify("Auto Farm", "Iniciado!", "play_arrow")
    
    task.spawn(function()
        while autoFarmEnabled do
            local target = getNearestEnemy()
            if target then
                -- Teleporta para o inimigo
                rootPart.CFrame = target.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
                task.wait(0.2)
                
                -- Ataca
                local swords = getSwords()
                if #swords > 0 then
                    equipSword(swords[1])
                    task.wait(0.1)
                    
                    pcall(function()
                        local tool = character:FindFirstChildOfClass("Tool")
                        if tool then
                            tool:Activate()
                            task.wait(0.1)
                            tool:Deactivate()
                        end
                    end)
                end
                
                -- Tenta matar diretamente
                pcall(function()
                    target.Humanoid.Health = 0
                end)
                
                task.wait(0.5)
            else
                task.wait(2)
            end
        end
    end)
end

local function stopAutoFarm()
    autoFarmEnabled = false
    notify("Auto Farm", "Parado", "stop")
end

-- ==================== AUTO SWING ====================
local function startAutoSwing()
    if autoSwingEnabled then return end
    autoSwingEnabled = true
    notify("Auto Swing", "Ativado!", "gesture")
    
    task.spawn(function()
        while autoSwingEnabled do
            pcall(function()
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end)
            task.wait(swingSpeed)
        end
    end)
end

local function stopAutoSwing()
    autoSwingEnabled = false
    notify("Auto Swing", "Desativado", "gesture")
end

-- ==================== AUTO TRAIN ====================
local function startAutoTrain()
    if autoTrainEnabled then return end
    autoTrainEnabled = true
    notify("Auto Train", "Ativado!", "fitness_center")
    
    task.spawn(function()
        while autoTrainEnabled do
            pcall(function()
                local trainEvent = ReplicatedStorage:FindFirstChild("TrainStrength")
                if trainEvent then
                    trainEvent:FireServer()
                end
                
                local chakraEvent = ReplicatedStorage:FindFirstChild("TrainChakra")
                if chakraEvent then
                    chakraEvent:FireServer()
                end
            end)
            task.wait(1)
        end
    end)
end

local function stopAutoTrain()
    autoTrainEnabled = false
    notify("Auto Train", "Desativado", "fitness_center")
end

-- ==================== AUTO SELL ====================
local function startAutoSell()
    if autoSellEnabled then return end
    autoSellEnabled = true
    notify("Auto Sell", "Ativado!", "sell")
    
    task.spawn(function()
        while autoSellEnabled do
            pcall(function()
                local sellEvent = ReplicatedStorage:FindFirstChild("Sell")
                if sellEvent then
                    sellEvent:FireServer()
                end
            end)
            task.wait(5)
        end
    end)
end

local function stopAutoSell()
    autoSellEnabled = false
    notify("Auto Sell", "Desativado", "sell")
end

-- ==================== AUTO BUY ====================
local function startAutoBuy()
    if autoBuyEnabled then return end
    autoBuyEnabled = true
    notify("Auto Buy", "Ativado!", "shopping_cart")
    
    task.spawn(function()
        while autoBuyEnabled do
            pcall(function()
                local buyEvent = ReplicatedStorage:FindFirstChild("BuySword")
                if buyEvent then
                    buyEvent:FireServer("Best")
                end
            end)
            task.wait(10)
        end
    end)
end

local function stopAutoBuy()
    autoBuyEnabled = false
    notify("Auto Buy", "Desativado", "shopping_cart")
end

-- ==================== AUTO REBIRTH ====================
local function startAutoRebirth()
    if autoRebirthEnabled then return end
    autoRebirthEnabled = true
    notify("Auto Rebirth", "Ativado!", "refresh")
    
    task.spawn(function()
        while autoRebirthEnabled do
            pcall(function()
                local rebirthEvent = ReplicatedStorage:FindFirstChild("Rebirth")
                if rebirthEvent then
                    rebirthEvent:FireServer()
                end
            end)
            task.wait(30)
        end
    end)
end

local function stopAutoRebirth()
    autoRebirthEnabled = false
    notify("Auto Rebirth", "Desativado", "refresh")
end

-- ==================== AUTO EQUIP BEST ====================
local function startAutoEquipBest()
    if autoEquipBestEnabled then return end
    autoEquipBestEnabled = true
    notify("Auto Equip", "Ativado!", "backpack")
    
    task.spawn(function()
        while autoEquipBestEnabled do
            local swords = getSwords()
            if #swords > 0 then
                equipSword(swords[1])
            end
            task.wait(5)
        end
    end)
end

local function stopAutoEquipBest()
    autoEquipBestEnabled = false
    notify("Auto Equip", "Desativado", "backpack")
end

-- ==================== KILL AURA ====================
local function startKillAura()
    if killAuraEnabled then return end
    killAuraEnabled = true
    notify("Kill Aura", "Ativado!", "gavel")
    
    task.spawn(function()
        while killAuraEnabled do
            local enemies = getEnemies()
            for _, enemy in ipairs(enemies) do
                if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    local dist = (enemy.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    if dist < farmDistance then
                        pcall(function()
                            enemy.Humanoid.Health = 0
                        end)
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

local function stopKillAura()
    killAuraEnabled = false
    notify("Kill Aura", "Desativado", "gavel")
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

-- ==================== ESP ====================
local espHighlights = {}
local function startESP()
    if espEnabled then return end
    espEnabled = true
    espConnection = RunService.Heartbeat:Connect(function()
        local enemies = getEnemies()
        for _, enemy in ipairs(enemies) do
            if not espHighlights[enemy] then
                local hl = Instance.new("Highlight")
                hl.Name = "ESP_" .. enemy.Name
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 100, 0)
                hl.FillTransparency = 0.5
                hl.Parent = enemy
                espHighlights[enemy] = hl
            end
        end
        
        for enemy, hl in pairs(espHighlights) do
            if not enemy.Parent or not enemy:FindFirstChild("Humanoid") or enemy.Humanoid.Health <= 0 then
                hl:Destroy()
                espHighlights[enemy] = nil
            end
        end
    end)
    notify("ESP", "Ativado", "visibility")
end

local function stopESP()
    espEnabled = false
    if espConnection then espConnection:Disconnect() end
    espConnection = nil
    for enemy, hl in pairs(espHighlights) do
        hl:Destroy()
    end
    espHighlights = {}
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
local FarmTab = Window:CreateTab({ Name = "Farm", Icon = "agriculture", ImageSource = "Material", ShowTitle = true })
local AutoTab = Window:CreateTab({ Name = "Auto", Icon = "autorenew", ImageSource = "Material", ShowTitle = true })
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

-- Farm
FarmTab:CreateSection("Auto Farm")
FarmTab:CreateToggle({
    Name = "Auto Farm",
    Description = "Mata inimigos automaticamente",
    CurrentValue = false,
    Callback = function(v) if v then startAutoFarm() else stopAutoFarm() end end
}, "AutoFarm")

FarmTab:CreateToggle({
    Name = "Auto Swing",
    Description = "Ataca continuamente",
    CurrentValue = false,
    Callback = function(v) if v then startAutoSwing() else stopAutoSwing() end end
}, "AutoSwing")

FarmTab:CreateToggle({
    Name = "Kill Aura",
    Description = "Mata todos os inimigos próximos",
    CurrentValue = false,
    Callback = function(v) if v then startKillAura() else stopKillAura() end end
}, "KillAura")

FarmTab:CreateSlider({
    Name = "Alcance do Farm",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(v) farmDistance = v end
}, "FarmDistance")

FarmTab:CreateSlider({
    Name = "Velocidade do Swing",
    Range = {0.01, 1},
    Increment = 0.01,
    CurrentValue = 0.1,
    Callback = function(v) swingSpeed = v end
}, "SwingSpeed")

-- Auto
AutoTab:CreateSection("Automações")
AutoTab:CreateToggle({
    Name = "Auto Train",
    Description = "Treina automaticamente",
    CurrentValue = false,
    Callback = function(v) if v then startAutoTrain() else stopAutoTrain() end end
}, "AutoTrain")

AutoTab:CreateToggle({
    Name = "Auto Sell",
    Description = "Vende automaticamente",
    CurrentValue = false,
    Callback = function(v) if v then startAutoSell() else stopAutoSell() end end
}, "AutoSell")

AutoTab:CreateToggle({
    Name = "Auto Buy",
    Description = "Compra a melhor espada",
    CurrentValue = false,
    Callback = function(v) if v then startAutoBuy() else stopAutoBuy() end end
}, "AutoBuy")

AutoTab:CreateToggle({
    Name = "Auto Rebirth",
    Description = "Renascimento automático",
    CurrentValue = false,
    Callback = function(v) if v then startAutoRebirth() else stopAutoRebirth() end end
}, "AutoRebirth")

AutoTab:CreateToggle({
    Name = "Auto Equip Best",
    Description = "Equipa a melhor espada",
    CurrentValue = false,
    Callback = function(v) if v then startAutoEquipBest() else stopAutoEquipBest() end end
}, "AutoEquip")

AutoTab:CreateSection("Combate")
AutoTab:CreateToggle({
    Name = "God Mode",
    Description = "Vida infinita",
    CurrentValue = false,
    Callback = function(v) if v then startGodMode() else stopGodMode() end end
}, "GodMode")

-- Visuals
VisualTab:CreateSection("ESP")
VisualTab:CreateToggle({
    Name = "ESP de Inimigos",
    Description = "Destaca todos os NPCs",
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
    stopAutoFarm()
    stopAutoSwing()
    stopKillAura()
    stopAutoTrain()
    stopAutoSell()
    stopAutoBuy()
    stopAutoRebirth()
    stopAutoEquipBest()
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

-- Exibir stats
task.spawn(function()
    while true do
        task.wait(10)
        local stats = getPlayerStats()
        notify("Stats", "Coins: " .. stats.Coins .. " | Gems: " .. stats.Gems .. " | Level: " .. stats.Level, "info")
    end
end)
