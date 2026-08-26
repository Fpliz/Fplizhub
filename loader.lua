--[[
  Fpliz Hub - Universal Loader v3.4
  Com Auto-Update System
]]

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer

-- ==================== CONFIGURATION ====================
local HUB_NAME = "Fpliz Hub"
local HUB_VERSION = "v3.4"
local HUB_COLOR = Color3.fromRGB(113, 93, 133)
local HUB_LOGO = "rbxassetid://82795327169782"

-- Versão atual do loader
local CURRENT_VERSION = "3.4"

-- URL do loader no GitHub
local LOADER_URL = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/loader.lua"

-- URL da versão (arquivo version.txt no GitHub)
local VERSION_URL = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/version.txt"

-- ==================== GAMES LIST ====================
local games = {
    [142823291] = {
        name = "Murder Mystery 2",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua"
    },
    [116924926476457] = {
        name = "Murder Mystery V",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua"
    },
    [155615604] = {
        name = "Prison Life",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/prison_life.lua"
    },
    [3956818381] = {
        name = "Ninja Legends",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/ninja_legends.lua"
    },
    [286090429] = {
        name = "Arsenal",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/arsenal.lua"
    },
}

-- ==================== AUTO-UPDATE SYSTEM ====================
local function checkForUpdates()
    pcall(function()
        -- Baixa a versão mais recente
        local latestVersion = game:HttpGet(VERSION_URL)
        latestVersion = latestVersion:gsub("%s+", "") -- Remove espaços
        
        if latestVersion ~= CURRENT_VERSION then
            -- Nova versão disponível!
            notify(HUB_NAME, "Update found! Reloading...", 3)
            
            task.wait(3)
            
            -- Baixa o novo loader
            local newLoader = game:HttpGet(LOADER_URL)
            
            -- Executa o novo loader
            loadstring(newLoader)()
            
            -- Para o loader antigo
            return true
        end
    end)
    
    return false
end

-- ==================== AUTO-UPDATE DO SCRIPT DO JOGO ====================
local function loadScriptWithAutoUpdate(url, gameName)
    local loadingScreen = showLoading(gameName)
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        loadingScreen:Destroy()
        notify("Error", "Failed to download script!", 3)
        return false
    end
    
    task.wait(0.5)
    loadingScreen:Destroy()
    
    local loadSuccess, loadResult = pcall(function()
        loadstring(result)()
    end)
    
    if not loadSuccess then
        notify("Error", "Failed to execute script!", 3)
        return false
    end
    
    return true
end

-- ==================== NOTIFICATION ====================
local function notify(title, content, duration)
    duration = duration or 3
    
    pcall(function()
        local screen = Instance.new("ScreenGui")
        screen.Name = "FplizNotification"
        screen.ResetOnSpawn = false
        screen.IgnoreGuiInset = true
        screen.Parent = CoreGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 280, 0, 70)
        frame.Position = UDim2.new(1, -300, 0, 20)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        frame.BorderSizePixel = 0
        frame.Parent = screen
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -20, 0, 20)
        titleLabel.Position = UDim2.new(0, 10, 0, 8)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextSize = 14
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = frame
        
        local contentLabel = Instance.new("TextLabel")
        contentLabel.Size = UDim2.new(1, -20, 0, 35)
        contentLabel.Position = UDim2.new(0, 10, 0, 30)
        contentLabel.BackgroundTransparency = 1
        contentLabel.Text = content
        contentLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
        contentLabel.TextSize = 12
        contentLabel.Font = Enum.Font.Gotham
        contentLabel.TextXAlignment = Enum.TextXAlignment.Left
        contentLabel.TextWrapped = true
        contentLabel.Parent = frame
        
        task.delay(duration, function()
            screen:Destroy()
        end)
    end)
end

-- ==================== INTRO ====================
local function showIntro()
    pcall(function()
        local screen = Instance.new("ScreenGui")
        screen.Name = "FplizIntro"
        screen.ResetOnSpawn = false
        screen.Parent = CoreGui
        
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
        bg.BorderSizePixel = 0
        bg.Parent = screen
        
        local logo = Instance.new("ImageLabel")
        logo.Size = UDim2.new(0, 80, 0, 80)
        logo.Position = UDim2.new(0.5, -40, 0.45, -40)
        logo.BackgroundTransparency = 1
        logo.Image = HUB_LOGO
        logo.BorderSizePixel = 0
        logo.Parent = screen
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 0, 0.5, 20)
        title.BackgroundTransparency = 1
        title.Text = "FPLIZ HUB"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 30
        title.Font = Enum.Font.GothamBold
        title.Parent = screen
        
        local version = Instance.new("TextLabel")
        version.Size = UDim2.new(1, 0, 0, 20)
        version.Position = UDim2.new(0, 0, 0.5, 65)
        version.BackgroundTransparency = 1
        version.Text = HUB_VERSION
        version.TextColor3 = HUB_COLOR
        version.TextSize = 14
        version.Font = Enum.Font.Gotham
        version.Parent = screen
        
        task.wait(2)
        screen:Destroy()
    end)
end

-- ==================== LOADING ====================
local function showLoading(gameName)
    local screen = Instance.new("ScreenGui")
    screen.Name = "FplizLoading"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.Parent = CoreGui
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.5
    bg.Parent = screen
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 180)
    frame.Position = UDim2.new(0.5, -175, 0.5, -90)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.Parent = screen
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = HUB_NAME
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 25)
    status.Position = UDim2.new(0, 0, 0, 60)
    status.BackgroundTransparency = 1
    status.Text = "Loading " .. gameName .. "..."
    status.TextColor3 = HUB_COLOR
    status.TextSize = 13
    status.Font = Enum.Font.Gotham
    status.Parent = frame
    
    -- Progress bar
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, -60, 0, 10)
    progressBg.Position = UDim2.new(0, 30, 0, 100)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    progressBg.Parent = frame
    Instance.new("UICorner", progressBg).CornerRadius = UDim.new(0, 5)
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = HUB_COLOR
    progressFill.Parent = progressBg
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 5)
    
    -- Percentage
    local percentLabel = Instance.new("TextLabel")
    percentLabel.Size = UDim2.new(1, 0, 0, 20)
    percentLabel.Position = UDim2.new(0, 0, 0, 120)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Text = "0%"
    percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    percentLabel.TextSize = 12
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.Parent = frame
    
    -- Animation with percentage
    task.spawn(function()
        for i = 0, 100 do
            progressFill.Size = UDim2.new(i / 100, 0, 1, 0)
            percentLabel.Text = i .. "%"
            task.wait(0.015)
        end
    end)
    
    return screen
end

-- ==================== UNSUPPORTED ====================
local function showUnsupported(gameId)
    local screen = Instance.new("ScreenGui")
    screen.Name = "FplizUnsupported"
    screen.ResetOnSpawn = false
    screen.Parent = CoreGui
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.6
    bg.Parent = screen
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 200)
    frame.Position = UDim2.new(0.5, -175, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    frame.Parent = screen
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = HUB_NAME
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -40, 0, 60)
    msg.Position = UDim2.new(0, 20, 0, 60)
    msg.BackgroundTransparency = 1
    msg.Text = "Game not supported!\n\nID: " .. gameId
    msg.TextColor3 = Color3.fromRGB(180, 180, 190)
    msg.TextSize = 14
    msg.Font = Enum.Font.Gotham
    msg.TextWrapped = true
    msg.Parent = frame
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 100, 0, 35)
    closeBtn.Position = UDim2.new(0.5, -50, 0, 150)
    closeBtn.BackgroundColor3 = HUB_COLOR
    closeBtn.Text = "CLOSE"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 13
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = frame
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    
    closeBtn.MouseButton1Click:Connect(function()
        screen:Destroy()
    end)
end

-- ==================== MAIN ====================
-- Check for updates first
local hasUpdate = checkForUpdates()
if hasUpdate then
    return -- Para o loader antigo
end

-- Show intro
showIntro()

-- Load game script
local gameId = game.PlaceId
local gameConfig = games[gameId]

if gameConfig then
    notify(HUB_NAME, "Loading " .. gameConfig.name .. "...", 2)
    loadScriptWithAutoUpdate(gameConfig.script, gameConfig.name)
else
    showUnsupported(gameId)
    warn("[Fpliz Hub] Game not supported: " .. gameId)
end

-- Anti-AFK
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
