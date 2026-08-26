--[[
  Fpliz Hub - Steal An Egg (Otimizado)
  UI: Luna
  Chave: FPLIZ
]]

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua"))()

local Window = Luna:CreateWindow({
    Name = "Fpliz Hub",
    Subtitle = "Steal An Egg",
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
    Content = "Bem-vindo ao Steal An Egg!"
})

-- ==================== SERVIÇOS ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- Estados
local autoFarmEnabled = false
local espEnabled = false
local fullbrightEnabled = false
local speedEnabled = false
local flyEnabled = false
local noclipEnabled = false
local antiAfkEnabled = false
local autoClickEnabled = false
local autoCollectEnabled = false

local basePosition = nil
local collectedCount = 0
local startTime = 0

local speedConnection = nil
local flyConnection = nil
local noclipConnection = nil
local antiAfkConnection = nil
local autoClickConnection = nil

local function notify(title, content, icon)
    icon = icon or "info"
    Luna:Notification({ Title = title, Icon = icon, ImageSource = "Material", Content = content })
end

-- ==================== FLY ====================
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

-- ==================== NOCLIP ====================
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

-- ==================== SPEED ====================
local function startSpeed()
    if speedEnabled then return end
    speedEnabled = true
    humanoid.WalkSpeed = 200
    
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

-- ==================== FUNÇÕES DE OVOS ====================
local function getEggs()
    local eggs = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Name == "CarryAreaEgg" and obj.Enabled then
            local parent = obj.Parent
            local pos = nil
            if parent and parent:IsA("BasePart") then pos = parent.Position end
            if parent and parent:IsA("Model") and parent.PrimaryPart then pos = parent.PrimaryPart.Position end
            
            if pos then
                table.insert(eggs, {prompt = obj, position = pos})
            end
        end
    end
    return eggs
end

local function getBase()
    if basePosition then
        return basePosition
    end
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("SpawnLocation") then
            return obj.Position
        end
    end
    
    return rootPart.Position
end

-- ==================== AUTO FARM OTIMIZADO ====================
local function startAutoFarm()
    if autoFarmEnabled then return end
    autoFarmEnabled = true
    collectedCount = 0
    startTime = os.time()
    notify("Auto Farm", "Iniciado!", "play_arrow")
    
    task.spawn(function()
        while autoFarmEnabled do
            local eggs = getEggs()
            
            if #eggs > 0 then
                -- Encontra o ovo mais próximo
                local target = eggs[1]
                local minDist = (target.position - rootPart.Position).Magnitude
                
                for _, egg in ipairs(eggs) do
                    local dist = (egg.position - rootPart.Position).Magnitude
                    if dist < minDist then
                        target = egg
                        minDist = dist
                    end
                end
                
                -- Teleporta para o ovo com Tween
                local targetPos = target.position + Vector3.new(0, 2, 0)
                local tween = TweenService:Create(rootPart, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
                tween:Play()
                tween.Completed:Wait()
                task.wait(0.1)
                
                -- Coleta
                if target.prompt and target.prompt.Enabled then
                    fireproximityprompt(target.prompt)
                    collectedCount = collectedCount + 1
                    local elapsed = os.time() - startTime
                    local rate = elapsed > 0 and math.floor(collectedCount / (elapsed / 60)) or 0
                    notify("Coleta", "Ovo coletado! Total: " .. collectedCount .. " (" .. rate .. "/min)", "check_circle")
                end
                
                task.wait(0.2)
                
                -- Volta para a base
                local base = getBase()
                local baseTween = TweenService:Create(rootPart, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = CFrame.new(base + Vector3.new(0, 2, 0))})
                baseTween:Play()
                baseTween.Completed:Wait()
                task.wait(0.2)
            else
                task.wait(2)
            end
        end
    end)
end

local function stopAutoFarm()
    autoFarmEnabled = false
    local elapsed = os.time() - startTime
    notify("Auto Farm", "Parado! Total: " .. collectedCount .. " ovos em " .. elapsed .. "s", "stop")
end

-- ==================== AUTO COLLECT ====================
local function startAutoCollect()
    if autoCollectEnabled then return end
    autoCollectEnabled = true
    notify("Auto Collect", "Ativado!", "check_circle")
    
    task.spawn(function()
        while autoCollectEnabled do
            local eggs = getEggs()
            for _, egg in ipairs(eggs) do
                if egg.prompt and egg.prompt.Enabled then
                    local dist = (egg.position - rootPart.Position).Magnitude
                    if dist < 5 then
                        fireproximityprompt(egg.prompt)
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

local function stopAutoCollect()
    autoCollectEnabled = false
    notify("Auto Collect", "Desativado", "check_circle")
end

-- ==================== ESP ====================
local espHighlights = {}
local function startESP()
    if espEnabled then return end
    espEnabled = true
    task.spawn(function()
        while espEnabled do
            local eggs = getEggs()
            for _, egg in ipairs(eggs) do
                if not espHighlights[egg.prompt] then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ESPHighlight"
                    hl.FillColor = Color3.fromRGB(255, 255, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 200, 0)
                    hl.FillTransparency = 0.5
                    hl.Parent = egg.prompt.Parent
                    espHighlights[egg.prompt] = hl
                end
            end
            
            for prompt, hl in pairs(espHighlights) do
                if not prompt.Parent or not prompt.Enabled then
                    hl:Destroy()
                    espHighlights[prompt] = nil
                end
            end
            task.wait(0.5)
        end
    end)
    notify("ESP", "Ativado", "visibility")
end

local function stopESP()
    espEnabled = false
    for prompt, hl in pairs(espHighlights) do
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

-- ==================== UI ====================
local MovementTab = Window:CreateTab({ Name = "Movimento", Icon = "directions_run", ImageSource = "Material", ShowTitle = true })
local FarmTab = Window:CreateTab({ Name = "Farm", Icon = "agriculture", ImageSource = "Material", ShowTitle = true })
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
    Name = "Speed Bypass",
    Description = "Velocidade aumentada",
    CurrentValue = false,
    Callback = function(v) if v then startSpeed() else stopSpeed() end end
}, "Speed")

-- Farm
FarmTab:CreateSection("Auto Farm")
FarmTab:CreateToggle({
    Name = "Auto Farm",
    Description = "Coleta ovos e volta para base definida",
    CurrentValue = false,
    Callback = function(v) if v then startAutoFarm() else stopAutoFarm() end end
}, "AutoFarm")

FarmTab:CreateToggle({
    Name = "Auto Collect",
    Description = "Coleta ovos próximos automaticamente",
    CurrentValue = false,
    Callback = function(v) if v then startAutoCollect() else stopAutoCollect() end end
}, "AutoCollect")

FarmTab:CreateButton({
    Name = "Definir Base Aqui",
    Description = "Define a posição atual como base",
    Callback = function()
        basePosition = rootPart.Position
        notify("Base", "Base definida aqui!", "home")
    end
})

FarmTab:CreateButton({
    Name = "Limpar Base",
    Description = "Volta para base padrão (Spawn)",
    Callback = function()
        basePosition = nil
        notify("Base", "Base resetada para Spawn", "home")
    end
})

FarmTab:CreateButton({
    Name = "Verificar Ovos",
    Callback = function()
        notify("Ovos", "Encontrados: " .. #getEggs(), "info")
    end
})

FarmTab:CreateSection("Stats")
FarmTab:CreateLabel({
    Name = "Ovos Coletados: " .. collectedCount,
    Description = "Atualiza durante o farm"
})

-- Visuals
VisualTab:CreateSection("ESP")
VisualTab:CreateToggle({
    Name = "ESP de Ovos",
    Description = "Destaca todos os ovos",
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
    stopAntiAfk()
    stopAutoClick()
    stopAutoFarm()
    stopAutoCollect()
    stopESP()
    task.wait(3)
    character = player.Character
    if character then
        humanoid = character:WaitForChild("Humanoid")
        rootPart = character:WaitForChild("HumanoidRootPart")
    end
end)
