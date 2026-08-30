--[[
  Fpliz Hub - Universal Loader v10.0
  Minimalist Loading (Toast Style)
]]

-- ==================== SERVICES ====================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- ==================== CONFIG ====================
local HUB_NAME = "Fpliz Hub"
local HUB_VERSION = "v10.0"

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

-- ==================== LOADING TOAST STYLE ====================
local function showLoading(gameName)
    local screen = Instance.new("ScreenGui")
    screen.Name = "FplizLoading"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.DisplayOrder = 999
    screen.Parent = CoreGui

    -- ===== BACKGROUND TRANSPARENTE (clica-through) =====
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel = 0
    bg.Parent = screen

    -- ===== CONTAINER PRINCIPAL (tamanho de notificação) =====
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 320, 0, 90)
    container.Position = UDim2.new(0.5, -160, 0.5, -45)
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ClipsDescendants = true
    container.Parent = bg

    -- ===== BORDA SUTIL COM GLOW =====
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 2, 1, 2)
    border.Position = UDim2.new(0, -1, 0, -1)
    border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    border.BackgroundTransparency = 0.8
    border.BorderSizePixel = 0
    border.Parent = container
    local borderCorner = Instance.new("UICorner", border)
    borderCorner.CornerRadius = UDim.new(0, 8)

    local bgMain = Instance.new("Frame")
    bgMain.Size = UDim2.new(1, 0, 1, 0)
    bgMain.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    bgMain.BackgroundTransparency = 1
    bgMain.BorderSizePixel = 0
    bgMain.Parent = container
    local mainCorner = Instance.new("UICorner", bgMain)
    mainCorner.CornerRadius = UDim.new(0, 8)

    -- ===== TEXTO PRINCIPAL (gradiente dourado/cinza) =====
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = string.upper(HUB_NAME)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Parent = container

    -- Gradiente no texto (dourado + prata)
    local textGrad = Instance.new("UIGradient", title)
    textGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),    -- Dourado
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)), -- Branco
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 190)),   -- Prata
    })
    textGrad.Rotation = 45

    -- ===== SUBTÍTULO (jogo + versão) =====
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 16)
    sub.Position = UDim2.new(0, 0, 0, 44)
    sub.BackgroundTransparency = 1
    sub.Text = gameName .. " • " .. HUB_VERSION
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 11
    sub.TextColor3 = Color3.fromRGB(140, 140, 155)
    sub.Parent = container

    -- ===== STATUS (com animação de dots) =====
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 14)
    status.Position = UDim2.new(0, 0, 0, 62)
    status.BackgroundTransparency = 1
    status.Text = "Loading"
    status.Font = Enum.Font.Gotham
    status.TextSize = 10
    status.TextColor3 = Color3.fromRGB(100, 100, 120)
    status.Parent = container

    -- ===== ANIMAÇÃO DOS DOTS =====
    task.spawn(function()
        local dots = 0
        while status.Parent do
            dots = (dots % 3) + 1
            status.Text = "Loading" .. string.rep(".", dots) .. string.rep(" ", 3 - dots)
            task.wait(0.4)
        end
    end)

    -- ===== ENTRADA (fade + scale) =====
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(0, 0, 0, 0)
    
    TweenService:Create(container, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
        BackgroundTransparency = 0.85,
        Size = UDim2.new(0, 320, 0, 90)
    }):Play()
    
    TweenService:Create(bgMain, TweenInfo.new(0.2), {
        BackgroundTransparency = 0
    }):Play()
    
    TweenService:Create(border, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.7
    }):Play()

    -- ===== FUNÇÕES =====
    local loading = {
        Screen = screen,
        SetStatus = function(text)
            status.Text = text
        end,
        SetProgress = function(p)
            -- Não precisa de barra, só texto
        end,
        Destroy = function()
            TweenService:Create(container, TweenInfo.new(0.2), {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            task.wait(0.25)
            screen:Destroy()
        end
    }

    return loading
end

-- ==================== DOWNLOAD COM RETRY ====================
local function downloadWithRetry(url, loading)
    for attempt = 1, 3 do
        loading.SetStatus("Downloading (" .. attempt .. "/3)")

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

    loading.SetStatus("Initializing")
    task.wait(0.2)

    local success, result = downloadWithRetry(url, loading)

    if not success then
        loading.SetStatus("Download failed")
        task.wait(0.8)
        loading.Destroy()
        return false
    end

    loading.SetStatus("Executing")
    task.wait(0.15)

    local loadOk, loadErr = pcall(function()
        loadstring(result)()
    end)

    if loadOk then
        loading.SetStatus("Loaded!")
        task.wait(0.3)
    else
        loading.SetStatus("Error")
        task.wait(0.8)
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
