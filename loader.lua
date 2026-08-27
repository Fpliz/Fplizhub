--[[

███████╗██████╗ ██╗     ██╗███████╗    ██╗  ██╗██╗   ██╗██████╗ 
██╔════╝██╔══██╗██║     ██║╚══███╔╝    ██║  ██║██║   ██║██╔══██╗
█████╗  ██████╔╝██║     ██║  ███╔╝     ███████║██║   ██║██████╔╝
██╔══╝  ██╔═══╝ ██║     ██║ ███╔╝      ██╔══██║██║   ██║██╔══██╗
██║     ██║     ███████╗██║███████╗    ██║  ██║╚██████╔╝██████╔╝
╚═╝     ╚═╝     ╚══════╝╚═╝╚══════╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 

            ⚠️  THIS SCRIPT IS THE EXCLUSIVE PROPERTY OF FPLIZ HUB  ⚠️
            ⚠️  DO NOT STEAL, COPY, MODIFY OR RESELL               ⚠️
            ⚠️  ALL RIGHTS RESERVED © 2026 FPLIZ HUB              ⚠️

--]]

-- ==================== SERVICES ====================
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = game:GetService("Players").LocalPlayer

-- ==================== CONFIG ====================
local HUB_NAME = "Fpliz Hub"
local HUB_VERSION = "v5.0"
local HUB_COLOR = Color3.fromRGB(113, 93, 133)

-- ==================== GAMES ====================
local games = {
    [142823291] = {
        name = "Murder Mystery 2",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua"
    },
    [116924926476457] = {
        name = "Murder Mystery V",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua"
    },
    [107778070777162] = {
        name = "Steal An Egg",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/steal_an_egg.lua"
    },
    [3956818381] = {
        name = "Ninja Legends",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/ninja_legends.lua"
    },
    [286090429] = {
        name = "Arsenal",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/arsenal.lua"
    },
    [8737899170] = {
        name = "Pet Simulator 99",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/pet_simulator.lua"
    },
    [6516141723] = {
        name = "Doors",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/doors.lua"
    },
}

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
    bg.BorderSizePixel = 0
    bg.Parent = screen
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 120)
    frame.Position = UDim2.new(0.5, -150, 0.5, -60)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.Parent = screen
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = HUB_COLOR
    stroke.Thickness = 2
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = HUB_NAME .. " " .. HUB_VERSION
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 25)
    status.Position = UDim2.new(0, 0, 0, 45)
    status.BackgroundTransparency = 1
    status.Text = "Loading " .. gameName .. "..."
    status.TextColor3 = HUB_COLOR
    status.TextSize = 13
    status.Font = Enum.Font.Gotham
    status.Parent = frame
    
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, -40, 0, 8)
    progressBg.Position = UDim2.new(0, 20, 0, 80)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = frame
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = HUB_COLOR
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressBg
    
    local percentLabel = Instance.new("TextLabel")
    percentLabel.Size = UDim2.new(1, 0, 0, 20)
    percentLabel.Position = UDim2.new(0, 0, 0, 92)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Text = "0%"
    percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    percentLabel.TextSize = 11
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.Parent = frame
    
    task.spawn(function()
        for i = 0, 100 do
            progressFill.Size = UDim2.new(i / 100, 0, 1, 0)
            percentLabel.Text = i .. "%"
            task.wait(0.008)
        end
    end)
    
    return screen
end

-- ==================== UNSUPPORTED ====================
local function showUnsupported(gameId)
    local screen = Instance.new("ScreenGui")
    screen.Name = "FplizUnsupported"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.Parent = CoreGui
    
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.6
    bg.BorderSizePixel = 0
    bg.Parent = screen
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 160)
    frame.Position = UDim2.new(0.5, -160, 0.5, -80)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    frame.Parent = screen
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = HUB_COLOR
    stroke.Thickness = 2
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 15)
    title.BackgroundTransparency = 1
    title.Text = HUB_NAME
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -30, 0, 50)
    msg.Position = UDim2.new(0, 15, 0, 50)
    msg.BackgroundTransparency = 1
    msg.Text = "Game not supported!\n\nID: " .. gameId
    msg.TextColor3 = Color3.fromRGB(180, 180, 190)
    msg.TextSize = 13
    msg.Font = Enum.Font.Gotham
    msg.TextWrapped = true
    msg.Parent = frame
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 100, 0, 30)
    closeBtn.Position = UDim2.new(0.5, -50, 0, 115)
    closeBtn.BackgroundColor3 = HUB_COLOR
    closeBtn.Text = "CLOSE"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = frame
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    
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
    
    task.wait(0.3)
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
