--[[
  Fpliz Hub - Universal Loader v9.0
  Robust & Professional
]]

-- ==================== SERVICES ====================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")

local player = game:GetService("Players").LocalPlayer

-- ==================== CONFIG ====================
local HUB_NAME = "Fpliz Hub"
local HUB_VERSION = "v9.0"
local CURRENT_VERSION = "9.0"

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

local SUPPORTED_GAMES = 0
for _ in pairs(games) do
    SUPPORTED_GAMES += 1
end

-- ==================== LOADING SCREEN ====================
local function showLoading(gameName)
    local screen = Instance.new("ScreenGui")
    screen.Name = "FplizLoading"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.DisplayOrder = 999
    screen.Parent = CoreGui
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    container.BorderSizePixel = 0
    container.BackgroundTransparency = 1
    container.Parent = screen
    
    local bgGradient = Instance.new("UIGradient", container)
    bgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 20, 40))
    })
    bgGradient.Rotation = 45
    
    -- Blobs
    local blob1 = Instance.new("Frame")
    blob1.Size = UDim2.new(0, 300, 0, 300)
    blob1.Position = UDim2.new(0.2, -150, 0.3, -150)
    blob1.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
    blob1.BackgroundTransparency = 0.85
    blob1.BorderSizePixel = 0
    blob1.Parent = container
    Instance.new("UICorner", blob1).CornerRadius = UDim.new(1, 0)
    
    local blob2 = Instance.new("Frame")
    blob2.Size = UDim2.new(0, 250, 0, 250)
    blob2.Position = UDim2.new(0.8, -125, 0.7, -125)
    blob2.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    blob2.BackgroundTransparency = 0.85
    blob2.BorderSizePixel = 0
    blob2.Parent = container
    Instance.new("UICorner", blob2).CornerRadius = UDim.new(1, 0)
    
    -- Logo FH (4 camadas)
    local logoContainer = Instance.new("Frame")
    logoContainer.Size = UDim2.new(0, 150, 0, 150)
    logoContainer.Position = UDim2.new(0.5, -75, 0.35, -75)
    logoContainer.BackgroundTransparency = 1
    logoContainer.Parent = container
    
    for offset = 1, 4 do
        local shadowF = Instance.new("TextLabel")
        shadowF.Size = UDim2.new(0, 70, 0, 70)
        shadowF.Position = UDim2.new(0, 5 + offset * 2, 0, 40 + offset * 2)
        shadowF.BackgroundTransparency = 1
        shadowF.Text = "F"
        shadowF.Font = Enum.Font.GothamBlack
        shadowF.TextSize = 60
        shadowF.TextColor3 = Color3.fromRGB(0, 0, 0)
        shadowF.TextTransparency = 0.3 + offset * 0.15
        shadowF.Parent = logoContainer
        
        local shadowH = Instance.new("TextLabel")
        shadowH.Size = UDim2.new(0, 70, 0, 70)
        shadowH.Position = UDim2.new(0, 73 + offset * 2, 0, 40 + offset * 2)
        shadowH.BackgroundTransparency = 1
        shadowH.Text = "H"
        shadowH.Font = Enum.Font.GothamBlack
        shadowH.TextSize = 60
        shadowH.TextColor3 = Color3.fromRGB(0, 0, 0)
        shadowH.TextTransparency = 0.3 + offset * 0.15
        shadowH.Parent = logoContainer
    end
    
    local magentaF = Instance.new("TextLabel")
    magentaF.Size = UDim2.new(0, 70, 0, 70)
    magentaF.Position = UDim2.new(0, 7, 0, 42)
    magentaF.BackgroundTransparency = 1
    magentaF.Text = "F"
    magentaF.Font = Enum.Font.GothamBlack
    magentaF.TextSize = 60
    magentaF.TextColor3 = Color3.fromRGB(255, 0, 150)
    magentaF.Parent = logoContainer
    
    local magentaH = Instance.new("TextLabel")
    magentaH.Size = UDim2.new(0, 70, 0, 70)
    magentaH.Position = UDim2.new(0, 75, 0, 42)
    magentaH.BackgroundTransparency = 1
    magentaH.Text = "H"
    magentaH.Font = Enum.Font.GothamBlack
    magentaH.TextSize = 60
    magentaH.TextColor3 = Color3.fromRGB(255, 0, 150)
    magentaH.Parent = logoContainer
    
    local cyanF = Instance.new("TextLabel")
    cyanF.Size = UDim2.new(0, 70, 0, 70)
    cyanF.Position = UDim2.new(0, 5, 0, 40)
    cyanF.BackgroundTransparency = 1
    cyanF.Text = "F"
    cyanF.Font = Enum.Font.GothamBlack
    cyanF.TextSize = 60
    cyanF.TextColor3 = Color3.fromRGB(0, 200, 255)
    cyanF.Parent = logoContainer
    
    local cyanH = Instance.new("TextLabel")
    cyanH.Size = UDim2.new(0, 70, 0, 70)
    cyanH.Position = UDim2.new(0, 73, 0, 40)
    cyanH.BackgroundTransparency = 1
    cyanH.Text = "H"
    cyanH.Font = Enum.Font.GothamBlack
    cyanH.TextSize = 60
    cyanH.TextColor3 = Color3.fromRGB(0, 200, 255)
    cyanH.Parent = logoContainer
    
    -- Entrada
    TweenService:Create(logoContainer, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -75, 0.35, -75)}):Play()
    
    -- Rotação
    task.spawn(function()
        while logoContainer.Parent do
            TweenService:Create(logoContainer, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = 3}):Play()
            task.wait(1.5)
            TweenService:Create(logoContainer, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = -3}):Play()
            task.wait(1.5)
        end
    end)
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0.55, 0)
    title.BackgroundTransparency = 1
    title.Text = string.upper(HUB_NAME)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 32
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Parent = container
    
    local titleStroke = Instance.new("UIStroke", title)
    titleStroke.Color = Color3.fromRGB(255, 0, 150)
    titleStroke.Thickness = 2
    titleStroke.Transparency = 0.5
    
    task.spawn(function()
        while title.Parent do
            TweenService:Create(titleStroke, TweenInfo.new(1), {Transparency = 0.2, Color = Color3.fromRGB(0, 200, 255)}):Play()
            task.wait(1)
            TweenService:Create(titleStroke, TweenInfo.new(1), {Transparency = 0.5, Color = Color3.fromRGB(255, 0, 150)}):Play()
            task.wait(1)
        end
    end)
    
    -- Status
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0.62, 0)
    status.BackgroundTransparency = 1
    status.Text = "Initializing..."
    status.Font = Enum.Font.Gotham
    status.TextSize = 14
    status.TextColor3 = Color3.fromRGB(180, 180, 190)
    status.Parent = container
    
    -- Barra
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(0, 300, 0, 10)
    progressBg.Position = UDim2.new(0.5, -150, 0.68, 0)
    progressBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    progressBg.BorderSizePixel = 0
    progressBg.ClipsDescendants = true
    progressBg.Parent = container
    Instance.new("UICorner", progressBg).CornerRadius = UDim.new(0, 5)
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressBg
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 5)
    
    local barGradient = Instance.new("UIGradient", progressFill)
    barGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 255))
    })
    
    -- Shine no progressBg (não no fill)
    local shine = Instance.new("Frame")
    shine.Size = UDim2.new(0, 30, 1, 0)
    shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shine.BackgroundTransparency = 0.5
    shine.BorderSizePixel = 0
    shine.Parent = progressBg
    Instance.new("UICorner", shine).CornerRadius = UDim.new(0, 5)
    
    task.spawn(function()
        while shine.Parent do
            shine.Position = UDim2.new(0, -30, 0, 0)
            TweenService:Create(shine, TweenInfo.new(0.8, Enum.EasingStyle.Linear), {Position = UDim2.new(1, 0, 0, 0)}):Play()
            task.wait(0.8)
        end
    end)
    
    -- Porcentagem
    local percentLabel = Instance.new("TextLabel")
    percentLabel.Size = UDim2.new(1, 0, 0, 20)
    percentLabel.Position = UDim2.new(0, 0, 0.70, 0)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Text = "0%"
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.TextSize = 12
    percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    percentLabel.Parent = container
    
    -- Versão
    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(0, 50, 0, 15)
    version.Position = UDim2.new(1, -55, 1, -20)
    version.BackgroundTransparency = 1
    version.Text = HUB_VERSION
    version.Font = Enum.Font.Gotham
    version.TextSize = 10
    version.TextColor3 = Color3.fromRGB(100, 100, 110)
    version.Parent = container
    
    -- Fade In
    TweenService:Create(container, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    
    local loading = {
        Screen = screen,
        Container = container,
        SetStatus = function(text)
            status.Text = text
        end,
        SetProgress = function(percent)
            percent = math.clamp(percent, 0, 100)
            TweenService:Create(progressFill, TweenInfo.new(0.08), {Size = UDim2.new(percent / 100, 0, 1, 0)}):Play()
            percentLabel.Text = percent .. "%"
        end,
        ShowError = function()
            status.Text = "✕ Execution Failed"
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
            percentLabel.Text = "Failed"
            percentLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end,
        Destroy = function()
            TweenService:Create(container, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
            task.wait(0.4)
            screen:Destroy()
        end,
    }
    
    return loading
end

-- ==================== DOWNLOAD COM RETRY ====================
local function downloadWithRetry(url, loading)
    for attempt = 1, 3 do
        loading.SetStatus("Downloading... Attempt " .. attempt .. "/3")
        loading.SetProgress(30 + attempt * 10)
        
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success and result then
            return true, result
        end
        
        if attempt < 3 then
            loading.SetStatus("Retrying...")
            task.wait(0.5)
        end
    end
    
    return false, nil
end

-- ==================== LOAD SCRIPT (PROGRESSO REAL) ====================
local function loadScript(url, gameName)
    local loading = showLoading(gameName)
    
    -- Initializing
    loading.SetStatus("Initializing...")
    loading.SetProgress(10)
    task.wait(0.2)
    
    -- Download com retry
    local success, result = downloadWithRetry(url, loading)
    
    if not success then
        loading.SetStatus("✕ Download Failed")
        loading.SetProgress(0)
        task.wait(1.5)
        loading.Destroy()
        return false
    end
    
    loading.SetStatus("Downloaded")
    loading.SetProgress(65)
    task.wait(0.1)
    
    -- Preparing
    loading.SetStatus("Preparing...")
    loading.SetProgress(80)
    task.wait(0.2)
    
    -- Executing
    loading.SetStatus("Executing...")
    loading.SetProgress(95)
    
    local loadSuccess, loadResult = pcall(function()
        loadstring(result)()
    end)
    
    if loadSuccess then
        loading.SetStatus("✓ Script Loaded")
        loading.SetProgress(100)
        task.wait(0.4)
    else
        loading.ShowError()
        task.wait(1.5)
    end
    
    loading.Destroy()
    
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
player.Idled:Connect(function()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightShift, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightShift, false, game)
end)
