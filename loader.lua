--[[
  Fpliz Hub - Universal Loader v4.3
  Visual Melhorado
]]

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- ==================== CONFIGURATION ====================
local HUB_NAME = "Fpliz Hub"
local HUB_VERSION = "v4.3"
local HUB_LOGO = "rbxassetid://82795327169782"
local HUB_COLOR = Color3.fromRGB(113, 93, 133)

-- ==================== GAMES LIST ====================
local games = {
    [142823291] = {
        name = "Murder Mystery 2",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua",
        icon = "🔪"
    },
    [116924926476457] = {
        name = "Murder Mystery V",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua",
        icon = "🔪"
    },
    [3956818381] = {
        name = "Ninja Legends",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/ninja_legends.lua",
        icon = "🥷"
    },
    [286090429] = {
        name = "Arsenal",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/arsenal.lua",
        icon = "🎯"
    },
    [8737899170] = {
        name = "Pet Simulator 99",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/pet_simulator.lua",
        icon = "🐾"
    },
    [6516141723] = {
        name = "Doors",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/doors.lua",
        icon = "🚪"
    },
}

-- ==================== LOADING SCREEN (MELHORADO) ====================
local function showLoading(gameName, gameIcon)
    local screen = Instance.new("ScreenGui")
    screen.Name = "FplizLoading"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = CoreGui
    
    -- Fundo com fade
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel = 0
    bg.Parent = screen
    
    -- Frame principal
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 380, 0, 220)
    frame.Position = UDim2.new(0.5, -190, 0.4, -110)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    frame.Parent = screen
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)
    
    -- Gradiente
    local gradient = Instance.new("UIGradient", frame)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 35, 55))
    })
    gradient.Rotation = 45
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = HUB_COLOR
    stroke.Thickness = 3
    stroke.Transparency = 0.3
    
    -- Logo com fade
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 60, 0, 60)
    logo.Position = UDim2.new(0.5, -30, 0, 20)
    logo.BackgroundTransparency = 1
    logo.Image = HUB_LOGO
    logo.ImageTransparency = 1
    logo.BorderSizePixel = 0
    logo.Parent = frame
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 15)
    
    -- Ícone do jogo
    local gameIconLabel = Instance.new("TextLabel")
    gameIconLabel.Size = UDim2.new(0, 30, 0, 30)
    gameIconLabel.Position = UDim2.new(0.5, 40, 0, 35)
    gameIconLabel.BackgroundTransparency = 1
    gameIconLabel.Text = gameIcon or "🎮"
    gameIconLabel.TextSize = 20
    gameIconLabel.Parent = frame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 90)
    title.BackgroundTransparency = 1
    title.Text = HUB_NAME .. " " .. HUB_VERSION
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBlack
    title.TextTransparency = 1
    title.Parent = frame
    
    -- Status
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 25)
    status.Position = UDim2.new(0, 0, 0, 125)
    status.BackgroundTransparency = 1
    status.Text = "Loading " .. gameName .. "..."
    status.TextColor3 = HUB_COLOR
    status.TextSize = 14
    status.Font = Enum.Font.Gotham
    status.TextTransparency = 1
    status.Parent = frame
    
    -- Barra de progresso
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, -80, 0, 12)
    progressBg.Position = UDim2.new(0, 40, 0, 165)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = frame
    Instance.new("UICorner", progressBg).CornerRadius = UDim.new(0, 6)
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = HUB_COLOR
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressBg
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 6)
    
    -- Gradiente na barra
    local barGradient = Instance.new("UIGradient", progressFill)
    barGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, HUB_COLOR),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 140, 220))
    })
    
    -- Porcentagem
    local percentLabel = Instance.new("TextLabel")
    percentLabel.Size = UDim2.new(1, 0, 0, 20)
    percentLabel.Position = UDim2.new(0, 0, 0, 185)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Text = "0%"
    percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    percentLabel.TextSize = 12
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.TextTransparency = 1
    percentLabel.Parent = frame
    
    -- FADE IN
    TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
    TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.5, -190, 0.5, -110),
        BackgroundTransparency = 0
    }):Play()
    TweenService:Create(logo, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
    TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(status, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(percentLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    
    -- Animação da barra
    task.spawn(function()
        for i = 0, 100 do
            progressFill.Size = UDim2.new(i / 100, 0, 1, 0)
            percentLabel.Text = i .. "%"
            task.wait(0.015)
        end
    end)
    
    return screen
end

-- ==================== FADE OUT LOADING ====================
local function fadeOutLoading(screen)
    local frame = screen:FindFirstChildOfClass("Frame")
    if frame then
        TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    end
    task.wait(0.3)
    screen:Destroy()
end

-- ==================== UNSUPPORTED GAME (MELHORADO) ====================
local function showUnsupported(gameId)
    local screen = Instance.new("ScreenGui")
    screen.Name = "FplizUnsupported"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = CoreGui
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel = 0
    bg.Parent = screen
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 380, 0, 230)
    frame.Position = UDim2.new(0.5, -190, 0.4, -115)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    frame.Parent = screen
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)
    
    local gradient = Instance.new("UIGradient", frame)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 40, 60))
    })
    gradient.Rotation = 45
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = HUB_COLOR
    stroke.Thickness = 3
    
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 70, 0, 70)
    logo.Position = UDim2.new(0.5, -35, 0, 20)
    logo.BackgroundTransparency = 1
    logo.Image = HUB_LOGO
    logo.BorderSizePixel = 0
    logo.Parent = frame
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 15)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 100)
    title.BackgroundTransparency = 1
    title.Text = HUB_NAME
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBlack
    title.Parent = frame
    
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -40, 0, 50)
    msg.Position = UDim2.new(0, 20, 0, 140)
    msg.BackgroundTransparency = 1
    msg.Text = "⚠️ Game not supported!\n\nID: " .. gameId
    msg.TextColor3 = Color3.fromRGB(200, 200, 210)
    msg.TextSize = 14
    msg.Font = Enum.Font.Gotham
    msg.TextWrapped = true
    msg.Parent = frame
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 120, 0, 40)
    closeBtn.Position = UDim2.new(0.5, -60, 0, 180)
    closeBtn.BackgroundColor3 = HUB_COLOR
    closeBtn.Text = "CLOSE"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 13
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = frame
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 10)
    
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150, 120, 180)}):Play()
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = HUB_COLOR}):Play()
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(bg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1, Position = UDim2.new(0.5, -190, 0.6, -115)}):Play()
        task.wait(0.3)
        screen:Destroy()
    end)
    
    -- FADE IN
    TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 0.6}):Play()
    TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.5, -190, 0.5, -115),
        BackgroundTransparency = 0
    }):Play()
end

-- ==================== LOAD SCRIPT ====================
local function loadScript(url, gameName, gameIcon)
    local loadingScreen = showLoading(gameName, gameIcon)
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        fadeOutLoading(loadingScreen)
        showUnsupported(game.PlaceId)
        return false
    end
    
    task.wait(0.5)
    fadeOutLoading(loadingScreen)
    
    local loadSuccess, loadResult = pcall(function()
        loadstring(result)()
    end)
    
    if not loadSuccess then
        warn("[Fpliz Hub] Error: " .. tostring(loadResult))
        return false
    end
    
    return true
end

-- ==================== MAIN ====================
local gameId = game.PlaceId
local gameConfig = games[gameId]

if gameConfig then
    loadScript(gameConfig.script, gameConfig.name, gameConfig.icon)
else
    showUnsupported(gameId)
    warn("[Fpliz Hub] Game not supported: " .. gameId)
end

-- ==================== ANTI-AFK ====================
task.spawn(function()
    while true do
        task.wait(180)
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightShift, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightShift, false, game)
        end)
    end
end)
