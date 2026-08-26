--[[
  Fpliz Hub - Universal Loader v3.2
  Intro corrigida sem crash
]]

-- ==================== SERVIÇOS ====================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer

-- ==================== CONFIGURAÇÕES ====================
local HUB_NAME = "Fpliz Hub"
local HUB_VERSION = "v3.2"
local HUB_COLOR = Color3.fromRGB(113, 93, 133)
local HUB_LOGO = "rbxassetid://82795327169782"

-- ==================== LISTA DE JOGOS ====================
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

-- ==================== INTRO CORRIGIDA ====================
local function showIntro()
    pcall(function()
        local screen = Instance.new("ScreenGui")
        screen.Name = "FplizIntro"
        screen.ResetOnSpawn = false
        screen.IgnoreGuiInset = true
        screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screen.DisplayOrder = 999
        screen.Parent = CoreGui
        
        -- Fundo
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
        bg.Parent = screen
        
        -- Gradiente
        local gradient = Instance.new("UIGradient", bg)
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 30, 50))
        })
        gradient.Rotation = 45
        
        -- Container
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0, 400, 0, 300)
        container.Position = UDim2.new(0.5, -200, 0.5, -150)
        container.BackgroundTransparency = 1
        container.Parent = screen
        
        -- Logo (SEM ScaleType.Fit para evitar crash)
        local logo = Instance.new("ImageLabel")
        logo.Size = UDim2.new(0, 100, 0, 100)
        logo.Position = UDim2.new(0.5, -50, 0, 0)
        logo.BackgroundTransparency = 1
        logo.Image = HUB_LOGO
        logo.Parent = container
        Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 15)
        
        -- Título Fpliz
        local titleFpliz = Instance.new("TextLabel")
        titleFpliz.Size = UDim2.new(1, 0, 0, 40)
        titleFpliz.Position = UDim2.new(0, 0, 0, 110)
        titleFpliz.BackgroundTransparency = 1
        titleFpliz.Text = "FPLIZ"
        titleFpliz.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleFpliz.TextSize = 35
        titleFpliz.Font = Enum.Font.GothamBlack
        titleFpliz.Parent = container
        
        -- Título Hub
        local titleHub = Instance.new("TextLabel")
        titleHub.Size = UDim2.new(1, 0, 0, 40)
        titleHub.Position = UDim2.new(0, 0, 0, 150)
        titleHub.BackgroundTransparency = 1
        titleHub.Text = "HUB"
        titleHub.TextColor3 = HUB_COLOR
        titleHub.TextSize = 35
        titleHub.Font = Enum.Font.GothamBlack
        titleHub.Parent = container
        
        -- Versão
        local version = Instance.new("TextLabel")
        version.Size = UDim2.new(1, 0, 0, 20)
        version.Position = UDim2.new(0, 0, 0, 195)
        version.BackgroundTransparency = 1
        version.Text = HUB_VERSION
        version.TextColor3 = Color3.fromRGB(180, 180, 200)
        version.TextSize = 14
        version.Font = Enum.Font.Gotham
        version.Parent = container
        
        -- Loading bar
        local loadBg = Instance.new("Frame")
        loadBg.Size = UDim2.new(0, 250, 0, 6)
        loadBg.Position = UDim2.new(0.5, -125, 0, 225)
        loadBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        loadBg.Parent = container
        Instance.new("UICorner", loadBg).CornerRadius = UDim.new(0, 3)
        
        local loadFill = Instance.new("Frame")
        loadFill.Size = UDim2.new(0, 0, 1, 0)
        loadFill.BackgroundColor3 = HUB_COLOR
        loadFill.Parent = loadBg
        Instance.new("UICorner", loadFill).CornerRadius = UDim.new(0, 3)
        
        -- Animação da barra (simples, sem crash)
        task.spawn(function()
            for i = 1, 100 do
                loadFill.Size = UDim2.new(i / 100, 0, 1, 0)
                task.wait(0.02)
            end
        end)
        
        -- Espera
        task.wait(3)
        
        -- Fade out
        screen:Destroy()
    end)
end

-- ==================== NOTIFICAÇÃO ====================
local function notify(title, content, duration)
    duration = duration or 3
    
    pcall(function()
        local screen = Instance.new("ScreenGui")
        screen.Name = "FplizNotification"
        screen.ResetOnSpawn = false
        screen.IgnoreGuiInset = true
        screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screen.Parent = CoreGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 300, 0, 80)
        frame.Position = UDim2.new(1, -320, 0, 20)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        frame.BorderSizePixel = 0
        frame.Parent = screen
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
        
        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = HUB_COLOR
        stroke.Thickness = 2
        
        local iconImage = Instance.new("ImageLabel")
        iconImage.Size = UDim2.new(0, 30, 0, 30)
        iconImage.Position = UDim2.new(0, 10, 0, 10)
        iconImage.BackgroundTransparency = 1
        iconImage.Image = HUB_LOGO
        iconImage.Parent = frame
        Instance.new("UICorner", iconImage).CornerRadius = UDim.new(0, 8)
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -50, 0, 20)
        titleLabel.Position = UDim2.new(0, 50, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextSize = 14
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = frame
        
        local contentLabel = Instance.new("TextLabel")
        contentLabel.Size = UDim2.new(1, -50, 0, 40)
        contentLabel.Position = UDim2.new(0, 50, 0, 30)
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

-- ==================== LOADING SIMPLES ====================
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
    frame.Size = UDim2.new(0, 350, 0, 150)
    frame.Position = UDim2.new(0.5, -175, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.Parent = screen
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = HUB_COLOR
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
    title.Text = HUB_NAME
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 25)
    status.Position = UDim2.new(0, 0, 0, 100)
    status.BackgroundTransparency = 1
    status.Text = "Carregando " .. gameName .. "..."
    status.TextColor3 = HUB_COLOR
    status.TextSize = 13
    status.Font = Enum.Font.Gotham
    status.Parent = frame
    
    return screen
end

-- ==================== JOGO NÃO SUPORTADO ====================
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
    bg.Parent = screen
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 250)
    frame.Position = UDim2.new(0.5, -200, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    frame.Parent = screen
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = HUB_COLOR
    stroke.Thickness = 3
    
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 80, 0, 80)
    logo.Position = UDim2.new(0.5, -40, 0, 20)
    logo.BackgroundTransparency = 1
    logo.Image = HUB_LOGO
    logo.Parent = frame
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 15)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 105)
    title.BackgroundTransparency = 1
    title.Text = HUB_NAME
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBlack
    title.Parent = frame
    
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -40, 0, 50)
    msg.Position = UDim2.new(0, 20, 0, 145)
    msg.BackgroundTransparency = 1
    msg.Text = "⚠️ Jogo não suportado!\n\nID: " .. gameId
    msg.TextColor3 = Color3.fromRGB(200, 200, 210)
    msg.TextSize = 14
    msg.Font = Enum.Font.Gotham
    msg.TextWrapped = true
    msg.Parent = frame
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 120, 0, 35)
    closeBtn.Position = UDim2.new(0.5, -60, 0, 200)
    closeBtn.BackgroundColor3 = HUB_COLOR
    closeBtn.Text = "FECHAR"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 13
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = frame
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    
    closeBtn.MouseButton1Click:Connect(function()
        screen:Destroy()
    end)
end

-- ==================== CARREGAR SCRIPT ====================
local function loadScript(url, gameName)
    local loadingScreen = showLoading(gameName)
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        loadingScreen:Destroy()
        notify("Erro", "Falha ao baixar script!", 3)
        return false
    end
    
    task.wait(0.5)
    loadingScreen:Destroy()
    
    local loadSuccess, loadResult = pcall(function()
        loadstring(result)()
    end)
    
    if not loadSuccess then
        notify("Erro", "Falha ao executar!", 3)
        return false
    end
    
    return true
end

-- ==================== EXECUÇÃO ====================
showIntro()

local gameId = game.PlaceId
local gameConfig = games[gameId]

if gameConfig then
    notify(HUB_NAME, "Carregando " .. gameConfig.name .. "...", 2)
    loadScript(gameConfig.script, gameConfig.name)
else
    showUnsupported(gameId)
    warn("[Fpliz Hub] Jogo não suportado: " .. gameId)
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
