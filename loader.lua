--[[
  Fpliz Hub - Universal Loader v9.1
  Clean & Professional
]]

-- ==================== SERVICES ====================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- ==================== CONFIG ====================
local HUB_NAME = "Fpliz Hub"
local HUB_VERSION = "v9.1"

-- ==================== GAMES ====================
local games = {
    -- Murder Mystery 2
    [142823291] = { 
        name = "Murder Mystery 2", 
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua" 
    },
    
    -- Murder Mystery V (mesmo script, nome diferente)
    [116924926476457] = { 
        name = "Murder Mystery V", 
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua" 
    },
    
    -- Blox Fruits (todos os seas)
    [2753915549] = { 
        name = "Blox Fruits", 
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/blox_fruits.lua" 
    },
    [4442272183] = { 
        name = "Blox Fruits", 
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/blox_fruits.lua" 
    },
    [7449423635] = { 
        name = "Blox Fruits", 
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/blox_fruits.lua" 
    },
    
    -- Ninja Legends
    [3956818381] = { 
        name = "Ninja Legends", 
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/ninja_legends.lua" 
    },
    
    -- Arsenal
    [286090429] = { 
        name = "Arsenal", 
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/arsenal.lua" 
    },
    
    -- Pet Simulator 99
    [8737899170] = { 
        name = "Pet Simulator 99", 
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/pet_simulator.lua" 
    },
    
    -- Doors
    [6516141723] = { 
        name = "Doors", 
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/doors.lua" 
    },
    
    -- Brookhaven
    [4924922222] = { 
        name = "Brookhaven", 
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/brookhaven.lua" 
    },
}

-- ==================== LOADING CLEAN ====================
local function showLoading(gameName)
    local screen = Instance.new("ScreenGui")
    screen.Name = "FplizLoading"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.DisplayOrder = 999
    screen.Parent = CoreGui

    -- FUNDO
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    bg.BorderSizePixel = 0
    bg.BackgroundTransparency = 1
    bg.Parent = screen

    TweenService:Create(bg, TweenInfo.new(0.4), { BackgroundTransparency = 0 }):Play()

    -- GRADIENTE SUTIL
    local gradient = Instance.new("UIGradient", bg)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
    })
    gradient.Rotation = 45

    -- CONTAINER CENTRAL
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 350, 0, 220)
    container.Position = UDim2.new(0.5, -175, 0.5, -110)
    container.BackgroundTransparency = 1
    container.ClipsDescendants = false
    container.Parent = bg

    -- LOGO (F+H minimalista)
    local logoFrame = Instance.new("Frame")
    logoFrame.Size = UDim2.new(0, 80, 0, 80)
    logoFrame.Position = UDim2.new(0.5, -40, 0, 0)
    logoFrame.BackgroundTransparency = 1
    logoFrame.Parent = container

    local f = Instance.new("TextLabel")
    f.Size = UDim2.new(0, 40, 0, 70)
    f.Position = UDim2.new(0, 0, 0, 5)
    f.BackgroundTransparency = 1
    f.Text = "F"
    f.Font = Enum.Font.GothamBlack
    f.TextSize = 60
    f.TextColor3 = Color3.fromRGB(255, 50, 150)
    f.Parent = logoFrame

    local h = Instance.new("TextLabel")
    h.Size = UDim2.new(0, 40, 0, 70)
    h.Position = UDim2.new(0, 40, 0, 5)
    h.BackgroundTransparency = 1
    h.Text = "H"
    h.Font = Enum.Font.GothamBlack
    h.TextSize = 60
    h.TextColor3 = Color3.fromRGB(50, 180, 255)
    h.Parent = logoFrame

    -- NOME
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 85)
    title.BackgroundTransparency = 1
    title.Text = string.upper(HUB_NAME)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.TextColor3 = Color3.fromRGB(230, 230, 240)
    title.Parent = container

    -- SUBTÍTULO (nome do jogo)
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 18)
    sub.Position = UDim2.new(0, 0, 0, 115)
    sub.BackgroundTransparency = 1
    sub.Text = gameName
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 13
    sub.TextColor3 = Color3.fromRGB(150, 150, 170)
    sub.Parent = container

    -- STATUS
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 18)
    status.Position = UDim2.new(0, 0, 0, 140)
    status.BackgroundTransparency = 1
    status.Text = "Initializing..."
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    status.TextColor3 = Color3.fromRGB(100, 100, 130)
    status.Parent = container

    -- BARRA DE PROGRESSO
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, 0, 0, 3)
    barBg.Position = UDim2.new(0, 0, 0, 168)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    barBg.BorderSizePixel = 0
    barBg.ClipsDescendants = true
    barBg.Parent = container
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 2)

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
    barFill.BorderSizePixel = 0
    barFill.Parent = barBg
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 2)

    local barGrad = Instance.new("UIGradient", barFill)
    barGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 180, 255))
    })

    -- PORCENTAGEM
    local percent = Instance.new("TextLabel")
    percent.Size = UDim2.new(1, 0, 0, 14)
    percent.Position = UDim2.new(0, 0, 0, 178)
    percent.BackgroundTransparency = 1
    percent.Text = "0%"
    percent.Font = Enum.Font.GothamBold
    percent.TextSize = 10
    percent.TextColor3 = Color3.fromRGB(80, 80, 110)
    percent.Parent = container

    -- VERSÃO
    local ver = Instance.new("TextLabel")
    ver.Size = UDim2.new(0, 50, 0, 14)
    ver.Position = UDim2.new(1, -55, 1, -18)
    ver.BackgroundTransparency = 1
    ver.Text = HUB_VERSION
    ver.Font = Enum.Font.Gotham
    ver.TextSize = 10
    ver.TextColor3 = Color3.fromRGB(60, 60, 80)
    ver.Parent = bg

    -- ========== FUNÇÕES ==========
    local loading = {
        Screen = screen,
        SetStatus = function(text)
            status.Text = text
        end,
        SetProgress = function(p)
            p = math.clamp(p, 0, 100)
            TweenService:Create(barFill, TweenInfo.new(0.15), { Size = UDim2.new(p / 100, 0, 1, 0) }):Play()
            percent.Text = p .. "%"
        end,
        Destroy = function()
            TweenService:Create(bg, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
            task.wait(0.3)
            screen:Destroy()
        end
    }

    return loading
end

-- ==================== DOWNLOAD COM RETRY ====================
local function downloadWithRetry(url, loading)
    for attempt = 1, 3 do
        loading.SetStatus("Downloading... (" .. attempt .. "/3)")
        loading.SetProgress(30 + attempt * 10)

        local success, result = pcall(function()
            return game:HttpGet(url)
        end)

        if success and result then
            return true, result
        end

        if attempt < 3 then
            loading.SetStatus("Retrying...")
            task.wait(0.6)
        end
    end

    return false, nil
end

-- ==================== LOAD SCRIPT ====================
local function loadScript(url, gameName)
    local loading = showLoading(gameName)

    loading.SetStatus("Initializing...")
    loading.SetProgress(5)
    task.wait(0.2)

    local success, result = downloadWithRetry(url, loading)

    if not success then
        loading.SetStatus("Download failed")
        loading.SetProgress(0)
        task.wait(1)
        loading.Destroy()
        return false
    end

    loading.SetStatus("Preparing...")
    loading.SetProgress(75)
    task.wait(0.15)

    loading.SetStatus("Executing...")
    loading.SetProgress(90)

    local loadOk, loadErr = pcall(function()
        loadstring(result)()
    end)

    if loadOk then
        loading.SetStatus("Loaded!")
        loading.SetProgress(100)
        task.wait(0.3)
    else
        loading.SetStatus("Error: " .. tostring(loadErr):sub(1, 40))
        loading.SetProgress(0)
        task.wait(1)
    end

    loading.Destroy()

    if not loadOk then
        warn("[Fpliz Hub] Error: " .. tostring(loadErr))
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
player.Idled:Connect(function()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightShift, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightShift, false, game)
end)
