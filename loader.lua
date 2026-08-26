--[[
  Fpliz Hub - Universal Loader v4.1
  Library: Flux (UI) + Own Loading/Notifications
]]

-- ==================== SERVICES ====================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer

-- ==================== CONFIGURATION ====================
local HUB_NAME = "Fpliz Hub"
local HUB_VERSION = "v4.1"
local HUB_LOGO = "rbxassetid://82795327169782"

-- Auto-Update
local CURRENT_VERSION = "4.1"
local LOADER_URL = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/loader.lua"
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
    [3956818381] = {
        name = "Ninja Legends",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/ninja_legends.lua"
    },
    [286090429] = {
        name = "Arsenal",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/arsenal.lua"
    },
    [189707] = {
        name = "Natural Disaster Survival",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/nds.lua"
    },
    [8737899170] = {
        name = "Pet Simulator 99",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/pet_simulator.lua"
    },
}

-- ==================== AUTO-UPDATE ====================
local function checkForUpdates()
    pcall(function()
        local latestVersion = game:HttpGet(VERSION_URL)
        latestVersion = latestVersion:gsub("%s+", "")
        
        if latestVersion ~= CURRENT_VERSION then
            -- Update found
            local screen = Instance.new("ScreenGui")
            screen.Name = "FplizUpdate"
            screen.ResetOnSpawn = false
            screen.Parent = CoreGui
            
            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(1, 0, 1, 0)
            bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            bg.BackgroundTransparency = 0.7
            bg.Parent = screen
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 300, 0, 120)
            frame.Position = UDim2.new(0.5, -150, 0.5, -60)
            frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            frame.BorderSizePixel = 0
            frame.Parent = screen
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
            
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, 0, 0, 30)
            title.Position = UDim2.new(0, 0, 0, 15)
            title.BackgroundTransparency = 1
            title.Text = "UPDATE FOUND!"
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.TextSize = 18
            title.Font = Enum.Font.GothamBold
            title.Parent = frame
            
            local msg = Instance.new("TextLabel")
            msg.Size = UDim2.new(1, 0, 0, 30)
            msg.Position = UDim2.new(0, 0, 0, 50)
            msg.BackgroundTransparency = 1
            msg.Text = "Reloading script..."
            msg.TextColor3 = Color3.fromRGB(180, 180, 190)
            msg.TextSize = 13
            msg.Font = Enum.Font.Gotham
            msg.Parent = frame
            
            task.wait(2)
            local newLoader = game:HttpGet(LOADER_URL)
            loadstring(newLoader)()
            return true
        end
    end)
    return false
end

-- ==================== LOADING SCREEN ====================
local function showLoading(gameName)
    local screen = Instance.new("ScreenGui")
    screen.Name = "FplizLoading"
    screen.ResetOnSpawn = false
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
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(113, 93, 133)
    stroke.Thickness = 2
    
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 50, 0, 50)
    logo.Position = UDim2.new(0.5, -25, 0, 15)
    logo.BackgroundTransparency = 1
    logo.Image = HUB_LOGO
    logo.Parent = frame
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 10)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 25)
    title.Position = UDim2.new(0, 0, 0, 70)
    title.BackgroundTransparency = 1
    title.Text = HUB_NAME .. " " .. HUB_VERSION
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 25)
    status.Position = UDim2.new(0, 0, 0, 100)
    status.BackgroundTransparency = 1
    status.Text = "Loading " .. gameName .. "..."
    status.TextColor3 = Color3.fromRGB(113, 93, 133)
    status.TextSize = 13
    status.Font = Enum.Font.Gotham
    status.Parent = frame
    
    -- Progress bar
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, -60, 0, 10)
    progressBg.Position = UDim2.new(0, 30, 0, 135)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    progressBg.Parent = frame
    Instance.new("UICorner", progressBg).CornerRadius = UDim.new(0, 5)
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(113, 93, 133)
    progressFill.Parent = progressBg
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 5)
    
    -- Percentage
    local percentLabel = Instance.new("TextLabel")
    percentLabel.Size = UDim2.new(1, 0, 0, 20)
    percentLabel.Position = UDim2.new(0, 0, 0, 150)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Text = "0%"
    percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    percentLabel.TextSize = 11
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.Parent = frame
    
    -- Animation
    task.spawn(function()
        for i = 0, 100 do
            progressFill.Size = UDim2.new(i / 100, 0, 1, 0)
            percentLabel.Text = i .. "%"
            task.wait(0.01)
        end
    end)
    
    return screen
end

-- ==================== UNSUPPORTED GAME ====================
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
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(113, 93, 133)
    stroke.Thickness = 2
    
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
    closeBtn.BackgroundColor3 = Color3.fromRGB(113, 93, 133)
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

-- ==================== LOAD SCRIPT ====================
local function loadScript(url, gameName)
    local loadingScreen = showLoading(gameName)
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        loadingScreen:Destroy()
        showUnsupported(game.PlaceId)
        return false
    end
    
    task.wait(0.5)
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

-- ==================== FLUX UI ====================
local success, Flux = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/depthso/Flux/main/Flux.lua"))()
end)

if success and Flux then
    local Window = Flux:CreateWindow({
        Title = HUB_NAME,
        Subtitle = HUB_VERSION,
        TabWidth = 120,
        Size = UDim2.fromOffset(550, 400),
        Acrylic = true,
        Theme = "Dark",
        ImMutable = true
    })
    
    local MainTab = Window:CreateTab({
        Title = "Home",
        Icon = "home"
    })
    
    local GamesTab = Window:CreateTab({
        Title = "Games",
        Icon = "gamepad-2"
    })
    
    local SettingsTab = Window:CreateTab({
        Title = "Settings",
        Icon = "settings"
    })
    
    -- Home Tab
    MainTab:CreateSection("Welcome")
    MainTab:CreateLabel({
        Title = "Welcome to " .. HUB_NAME,
        Subtitle = "Universal hub for Roblox"
    })
    
    MainTab:CreateLabel({
        Title = "Current Game",
        Subtitle = (games[game.PlaceId] and games[game.PlaceId].name or "Not supported") .. " | ID: " .. game.PlaceId
    })
    
    MainTab:CreateSection("Actions")
    local loadButton = MainTab:CreateButton({
        Title = "Load Script",
        Description = "Loads the game script",
        Callback = function()
            local gameConfig = games[game.PlaceId]
            if gameConfig then
                loadScript(gameConfig.script, gameConfig.name)
            else
                Flux:Notification("Game not supported!", "Error", 3)
            end
        end
    })
    
    -- Games Tab
    GamesTab:CreateSection("Supported Games")
    for id, config in pairs(games) do
        GamesTab:CreateLabel({
            Title = config.name,
            Subtitle = "ID: " .. id
        })
    end
    
    -- Settings Tab
    SettingsTab:CreateSection("Auto Load")
    local autoLoadToggle = SettingsTab:CreateToggle({
        Title = "Auto Load",
        Description = "Automatically loads script",
        Default = true,
        Callback = function(v)
            autoLoadEnabled = v
        end
    })
    
    SettingsTab:CreateSection("Info")
    SettingsTab:CreateLabel({
        Title = HUB_NAME,
        Subtitle = HUB_VERSION
    })
else
    warn("[Fpliz Hub] Flux failed to load, using fallback UI")
end

-- ==================== MAIN ====================
-- Check updates
local hasUpdate = checkForUpdates()
if hasUpdate then return end

-- Auto-load if enabled
local autoLoadEnabled = true

if autoLoadEnabled then
    local gameId = game.PlaceId
    local gameConfig = games[gameId]
    
    if gameConfig then
        loadScript(gameConfig.script, gameConfig.name)
    else
        showUnsupported(gameId)
        warn("[Fpliz Hub] Game not supported: " .. gameId)
    end
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
