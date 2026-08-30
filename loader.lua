--[[
  Fpliz Hub - Universal Loader v6.0
  Loading: 3D Logo Style
]]

-- ==================== SERVICES ====================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = game:GetService("Players").LocalPlayer

-- ==================== CONFIG ====================
local HUB_NAME = "Fpliz Hub"
local HUB_VERSION = "v6.0"
local HUB_LOGO = "rbxassetid://82795327169782"

-- ==================== GAMES ====================
local games = {
    [142823291] = { name = "Murder Mystery 2", script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua" },
    [116924926476457] = { name = "Murder Mystery V", script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua" },
    [2753915549] = { name = "Blox Fruits [Sea 1]", script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/blox_fruits.lua" },
    [4442272183] = { name = "Blox Fruits [Sea 2]", script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/blox_fruits.lua" },
    [7449423635] = { name = "Blox Fruits [Sea 3]", script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/blox_fruits.lua" },
    [3956818381] = { name = "Ninja Legends", script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/ninja_legends.lua" },
    [286090429] = { name = "Arsenal", script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/arsenal.lua" },
    [8737899170] = { name = "Pet Simulator 99", script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/pet_simulator.lua" },
    [6516141723] = { name = "Doors", script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/doors.lua" },
    [4924922222] = { name = "Brookhaven", script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/brookhaven.lua" },
}

-- ==================== LOADING SCREEN (ESTILO 3D) ====================
local function showLoading(gameName)
    local screen = Instance.new("ScreenGui")
    screen.Name = "FplizLoading"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.DisplayOrder = 999
    screen.Parent = CoreGui
    
    -- ===== FUNDO (cinza com blur/depth of field) =====
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(120, 120, 130)
    bg.BackgroundTransparency = 0
    bg.BorderSizePixel = 0
    bg.Parent = screen
    
    -- Baseplate simulation (formas azuis/brancas desfocadas)
    local baseplate = Instance.new("Frame")
    baseplate.Size = UDim2.new(1.5, 0, 0.3, 0)
    baseplate.Position = UDim2.new(0.5, -300, 0.7, 0)
    baseplate.BackgroundColor3 = Color3.fromRGB(160, 160, 170)
    baseplate.BorderSizePixel = 0
    baseplate.Rotation = -5
    baseplate.Parent = bg
    Instance.new("UICorner", baseplate).CornerRadius = UDim.new(0, 10)
    
    local baseplateTop = Instance.new("Frame")
    baseplateTop.Size = UDim2.new(1, 0, 0.1, 0)
    baseplateTop.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
    baseplateTop.BorderSizePixel = 0
    baseplateTop.Parent = baseplate
    
    -- ===== LOGO "FH" 3D STYLE =====
    -- Container para o logo
    local logoContainer = Instance.new("Frame")
    logoContainer.Size = UDim2.new(0, 150, 0, 150)
    logoContainer.Position = UDim2.new(0.5, -75, 0.4, -75)
    logoContainer.BackgroundTransparency = 1
    logoContainer.Parent = bg
    
    -- Letra F (gradiente magenta → cyan)
    local letterF = Instance.new("TextLabel")
    letterF.Size = UDim2.new(0, 70, 0, 70)
    letterF.Position = UDim2.new(0, 5, 0, 40)
    letterF.BackgroundTransparency = 1
    letterF.Text = "F"
    letterF.Font = Enum.Font.GothamBlack
    letterF.TextSize = 60
    letterF.TextColor3 = Color3.fromRGB(255, 0, 150)
    letterF.Parent = logoContainer
    
    -- Letra H (cyan)
    local letterH = Instance.new("TextLabel")
    letterH.Size = UDim2.new(0, 70, 0, 70)
    letterH.Position = UDim2.new(0, 75, 0, 40)
    letterH.BackgroundTransparency = 1
    letterH.Text = "H"
    letterH.Font = Enum.Font.GothamBlack
    letterH.TextSize = 60
    letterH.TextColor3 = Color3.fromRGB(0, 200, 255)
    letterH.Parent = logoContainer
    
    -- ===== TEXTO PRINCIPAL =====
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0.55, 0)
    title.BackgroundTransparency = 1
    title.Text = "FPLIZ HUB"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 32
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Parent = bg
    
    -- ===== STATUS =====
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0.62, 0)
    status.BackgroundTransparency = 1
    status.Text = "Loading " .. gameName .. "..."
    status.Font = Enum.Font.Gotham
    status.TextSize = 14
    status.TextColor3 = Color3.fromRGB(200, 200, 210)
    status.Parent = bg
    
    -- ===== BARRA DE PROGRESSO =====
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(0, 300, 0, 8)
    progressBg.Position = UDim2.new(0.5, -150, 0.68, 0)
    progressBg.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = bg
    Instance.new("UICorner", progressBg).CornerRadius = UDim.new(0, 4)
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressBg
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 4)
    
    -- Gradiente na barra (magenta → cyan)
    local barGradient = Instance.new("UIGradient", progressFill)
    barGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
    })
    
    -- ===== PORCENTAGEM =====
    local percentLabel = Instance.new("TextLabel")
    percentLabel.Size = UDim2.new(1, 0, 0, 20)
    percentLabel.Position = UDim2.new(0, 0, 0.70, 0)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Text = "0%"
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.TextSize = 12
    percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    percentLabel.Parent = bg
    
    -- ===== ANIMAÇÃO =====
    task.spawn(function()
        for i = 0, 100 do
            progressFill.Size = UDim2.new(i / 100, 0, 1, 0)
            percentLabel.Text = i .. "%"
            task.wait(0.015)
        end
    end)
    
    return screen
end

-- ==================== LOAD SCRIPT ====================
local function loadScript(url, gameName)
    local loadingScreen = showLoading(gameName)
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        loadingScreen:Destroy()
        return false
    end
    
    task.wait(1)
    loadingScreen:Destroy()
    
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
    loadScript(gameConfig.script, gameConfig.name)
else
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
