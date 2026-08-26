--[[
  Fpliz Hub - Universal Loader v3.0
  Com Intro Corrigida, Fade In/Out e Arsenal
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
local HUB_VERSION = "v3.0"
local HUB_COLOR = Color3.fromRGB(113, 93, 133)
local HUB_LOGO = "rbxassetid://82795327169782"

-- ==================== LISTA DE JOGOS ====================
local games = {
    -- Murder Mystery 2 (MM2)
    [142823291] = {
        name = "Murder Mystery 2",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua",
        icon = HUB_LOGO
    },
    
    -- Murder Mystery V (MMV)
    [116924926476457] = {
        name = "Murder Mystery V",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua",
        icon = HUB_LOGO
    },
    
    -- Prison Life
    [155615604] = {
        name = "Prison Life",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/prison_life.lua",
        icon = HUB_LOGO
    },
    
    -- Ninja Legends
    [3956818381] = {
        name = "Ninja Legends",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/ninja_legends.lua",
        icon = HUB_LOGO
    },
    
    -- Arsenal
    [286090429] = {
        name = "Arsenal",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/arsenal.lua",
        icon = HUB_LOGO
    },
}

-- ==================== INTRO PERSONALIZADA ====================
local function showIntro()
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
    bg.BackgroundTransparency = 1
    bg.Parent = screen
    
    -- Gradiente
    local gradient = Instance.new("UIGradient", bg)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 30, 50))
    })
    gradient.Rotation = 45
    
    -- Container central
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 400, 0, 300)
    container.Position = UDim2.new(0.5, -200, 0.5, -150)
    container.BackgroundTransparency = 1
    container.Parent = screen
    
    -- Logo
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 120, 0, 120)
    logo.Position = UDim2.new(0.5, -60, 0, -30)
    logo.BackgroundTransparency = 1
    logo.Image = HUB_LOGO
    logo.ImageTransparency = 1
    logo.ScaleType = Enum.ScaleType.Fit
    logo.Parent = container
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 20)
    
    -- Título Fpliz
    local titleFpliz = Instance.new("TextLabel")
    titleFpliz.Size = UDim2.new(1, 0, 0, 40)
    titleFpliz.Position = UDim2.new(0, 0, 0, 130)
    titleFpliz.BackgroundTransparency = 1
    titleFpliz.Text = "FPLIZ"
    titleFpliz.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleFpliz.TextSize = 35
    titleFpliz.Font = Enum.Font.GothamBlack
    titleFpliz.TextTransparency = 1
    titleFpliz.Parent = container
    
    -- Título Hub
    local titleHub = Instance.new("TextLabel")
    titleHub.Size = UDim2.new(1, 0, 0, 40)
    titleHub.Position = UDim2.new(0, 0, 0, 170)
    titleHub.BackgroundTransparency = 1
    titleHub.Text = "HUB"
    titleHub.TextColor3 = HUB_COLOR
    titleHub.TextSize = 35
    titleHub.Font = Enum.Font.GothamBlack
    titleHub.TextTransparency = 1
    titleHub.Parent = container
    
    -- Versão
    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(1, 0, 0, 20)
    version.Position = UDim2.new(0, 0, 0, 215)
    version.BackgroundTransparency = 1
    version.Text = HUB_VERSION
    version.TextColor3 = Color3.fromRGB(180, 180, 200)
    version.TextSize = 14
    version.Font = Enum.Font.Gotham
    version.TextTransparency = 1
    version.Parent = container
    
    -- Loading bar
    local loadBg = Instance.new("Frame")
    loadBg.Size = UDim2.new(0, 250, 0, 6)
    loadBg.Position = UDim2.new(0.5, -125, 0, 245)
    loadBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    loadBg.BackgroundTransparency = 1
    loadBg.Parent = container
    Instance.new("UICorner", loadBg).CornerRadius = UDim.new(0, 3)
    
    local loadFill = Instance.new("Frame")
    loadFill.Size = UDim2.new(0, 0, 1, 0)
    loadFill.BackgroundColor3 = HUB_COLOR
    loadFill.Parent = loadBg
    Instance.new("UICorner", loadFill).CornerRadius = UDim.new(0, 3)
    
    -- FADE IN do fundo
    TweenService:Create(bg, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
    
    -- FADE IN do logo (com bounce)
    TweenService:Create(logo, TweenInfo.new(0.8, Enum.EasingStyle.Back), {
        ImageTransparency = 0,
        Position = UDim2.new(0.5, -60, 0, 0)
    }):Play()
    
    -- FADE IN dos textos em sequência
    task.wait(0.3)
    TweenService:Create(titleFpliz, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
    task.wait(0.1)
    TweenService:Create(titleHub, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
    task.wait(0.1)
    TweenService:Create(version, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
    TweenService:Create(loadBg, TweenInfo.new(0.6), {BackgroundTransparency = 0}):Play()
    
    -- Animação da barra
    TweenService:Create(loadFill, TweenInfo.new(2, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    
    -- Espera
    task.wait(3)
    
    -- FADE OUT
    TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(logo, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
    TweenService:Create(titleFpliz, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(titleHub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(version, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(loadBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    
    task.wait(0.5)
    screen:Destroy()
end

-- ==================== FUNÇÃO DE NOTIFICAÇÃO MELHORADA ====================
local function notify(title, content, duration)
    duration = duration or 3
    
    local screen = Instance.new("ScreenGui")
    screen.Name = "FplizNotification"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = CoreGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 85)
    frame.Position = UDim2.new(1, -340, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.BackgroundTransparency = 1
    frame.Parent = screen
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = HUB_COLOR
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    
    local iconImage = Instance.new("ImageLabel")
    iconImage.Size = UDim2.new(0, 35, 0, 35)
    iconImage.Position = UDim2.new(0, 12, 0, 12)
    iconImage.BackgroundTransparency = 1
    iconImage.Image = HUB_LOGO
    iconImage.Parent = frame
    Instance.new("UICorner", iconImage).CornerRadius = UDim.new(0, 10)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 0, 20)
    titleLabel.Position = UDim2.new(0, 55, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, -60, 0, 40)
    contentLabel.Position = UDim2.new(0, 55, 0, 32)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content
    contentLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    contentLabel.TextSize = 12
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextWrapped = true
    contentLabel.Parent = frame
    
    -- Barra de tempo
    local timeBar = Instance.new("Frame")
    timeBar.Size = UDim2.new(1, 0, 0, 3)
    timeBar.Position = UDim2.new(0, 0, 1, -3)
    timeBar.BackgroundColor3 = HUB_COLOR
    timeBar.Parent = frame
    
    -- FADE IN
    frame.Position = UDim2.new(1, 20, 0, 20)
    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
        Position = UDim2.new(1, -340, 0, 20),
        BackgroundTransparency = 0
    }):Play()
    
    -- Barra de tempo
    TweenService:Create(timeBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 3)
    }):Play()
    
    -- FADE OUT
    task.delay(duration, function()
        TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, 20, 0, 20),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.4)
        screen:Destroy()
    end)
end

-- ==================== FUNÇÃO DE LOADING ====================
local function showLoading(gameName, gameIcon)
    local screen = Instance.new("ScreenGui")
    screen.Name = "FplizLoading"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = CoreGui
    
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 1
    background.Parent = screen
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 230)
    frame.Position = UDim2.new(0.5, -200, 0.4, -115)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    frame.Parent = screen
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = HUB_COLOR
    stroke.Thickness = 3
    stroke.Transparency = 0.3
    
    local logoImage = Instance.new("ImageLabel")
    logoImage.Size = UDim2.new(0, 70, 0, 70)
    logoImage.Position = UDim2.new(0.5, -35, 0, 25)
    logoImage.BackgroundTransparency = 1
    logoImage.Image = HUB_LOGO
    logoImage.ScaleType = Enum.ScaleType.Fit
    logoImage.Parent = frame
    Instance.new("UICorner", logoImage).CornerRadius = UDim.new(0, 20)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 105)
    title.BackgroundTransparency = 1
    title.Text = HUB_NAME .. " " .. HUB_VERSION
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 30)
    status.Position = UDim2.new(0, 0, 0, 145)
    status.BackgroundTransparency = 1
    status.Text = "Carregando " .. gameName .. "..."
    status.TextColor3 = HUB_COLOR
    status.TextSize = 14
    status.Font = Enum.Font.Gotham
    status.Parent = frame
    
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, -80, 0, 12)
    progressBg.Position = UDim2.new(0, 40, 0, 185)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    progressBg.Parent = frame
    Instance.new("UICorner", progressBg).CornerRadius = UDim.new(0, 6)
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = HUB_COLOR
    progressFill.Parent = progressBg
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 6)
    
    -- FADE IN
    TweenService:Create(background, TweenInfo.new(0.5), {BackgroundTransparency = 0.6}):Play()
    TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.5, -200, 0.5, -115),
        BackgroundTransparency = 0
    }):Play()
    
    task.spawn(function()
        local progress = 0
        while progress < 0.9 do
            progress = progress + 0.02
            progressFill.Size = UDim2.new(progress, 0, 1, 0)
            task.wait(0.03)
        end
    end)
    
    return screen, progressFill
end

-- ==================== FADE OUT DO LOADING ====================
local function fadeOutLoading(screen, progressFill)
    progressFill.Size = UDim2.new(1, 0, 1, 0)
    task.wait(0.2)
    
    local frame = screen:FindFirstChildOfClass("Frame")
    if frame then
        TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    end
    
    task.wait(0.4)
    screen:Destroy()
end

-- ==================== JOGO NÃO SUPORTADO ====================
local function showUnsupported(gameId)
    local screen = Instance.new("ScreenGui")
    screen.Name = "FplizUnsupported"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = CoreGui
    
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 1
    background.Parent = screen
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 280)
    frame.Position = UDim2.new(0.5, -210, 0.4, -140)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
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
    logo.ScaleType = Enum.ScaleType.Fit
    logo.Parent = frame
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 15)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Position = UDim2.new(0, 0, 0, 110)
    title.BackgroundTransparency = 1
    title.Text = HUB_NAME
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 28
    title.Font = Enum.Font.GothamBlack
    title.Parent = frame
    
    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(1, 0, 0, 20)
    version.Position = UDim2.new(0, 0, 0, 145)
    version.BackgroundTransparency = 1
    version.Text = HUB_VERSION
    version.TextColor3 = HUB_COLOR
    version.TextSize = 14
    version.Font = Enum.Font.GothamBold
    version.Parent = frame
    
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -60, 0, 50)
    msg.Position = UDim2.new(0, 30, 0, 175)
    msg.BackgroundTransparency = 1
    msg.Text = "⚠️ Jogo não suportado!\n\nID: " .. gameId
    msg.TextColor3 = Color3.fromRGB(200, 200, 210)
    msg.TextSize = 15
    msg.Font = Enum.Font.Gotham
    msg.TextWrapped = true
    msg.Parent = frame
    
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 140, 0, 40)
    copyBtn.Position = UDim2.new(0, 30, 0, 230)
    copyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    copyBtn.Text = "📋 COPIAR ID"
    copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyBtn.TextSize = 13
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.AutoButtonColor = false
    copyBtn.Parent = frame
    Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 10)
    
    copyBtn.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard(tostring(gameId))
            notify("✅ ID Copiado!", "ID: " .. gameId, 2)
        end)
    end)
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 140, 0, 40)
    closeBtn.Position = UDim2.new(1, -170, 0, 230)
    closeBtn.BackgroundColor3 = HUB_COLOR
    closeBtn.Text = "FECHAR"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 13
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = frame
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 10)
    
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(background, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1, Position = UDim2.new(0.5, -210, 0.6, -140)}):Play()
        task.wait(0.3)
        screen:Destroy()
    end)
    
    -- FADE IN
    TweenService:Create(background, TweenInfo.new(0.5), {BackgroundTransparency = 0.6}):Play()
    TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.5, -210, 0.5, -140),
        BackgroundTransparency = 0
    }):Play()
end

-- ==================== FUNÇÃO DE CARREGAMENTO ====================
local function loadScript(url, gameName, gameIcon)
    local loadingScreen, progressFill = showLoading(gameName, gameIcon)
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        fadeOutLoading(loadingScreen, progressFill)
        notify("Erro", "Falha ao baixar script!", 3)
        return false
    end
    
    progressFill.Size = UDim2.new(1, 0, 1, 0)
    task.wait(0.2)
    
    local loadSuccess, loadResult = pcall(function()
        loadstring(result)()
    end)
    
    fadeOutLoading(loadingScreen, progressFill)
    
    if not loadSuccess then
        notify("Erro", "Falha ao executar: " .. tostring(loadResult), 3)
        return false
    end
    
    return true
end

-- ==================== EXECUÇÃO PRINCIPAL ====================
-- Mostra intro primeiro
showIntro()

local gameId = game.PlaceId
local gameConfig = games[gameId]

if gameConfig then
    notify(HUB_NAME, "Bem-vindo! Carregando " .. gameConfig.name .. "...", 2)
    
    local success = loadScript(gameConfig.script, gameConfig.name, gameConfig.icon)
    
    if success then
        notify("Sucesso", gameConfig.name .. " carregado!", 3)
    end
else
    showUnsupported(gameId)
    
    warn("[" .. HUB_NAME .. "] Jogo não suportado: " .. gameId)
    print("[" .. HUB_NAME .. "] Adicione no loader:")
    print("[" .. gameId .. "] = {")
    print("    name = \"NOME_DO_JOGO\",")
    print("    script = \"https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/nome_do_jogo.lua\",")
    print("    icon = HUB_LOGO")
    print("},")
end

-- ==================== ANTI-AFK AUTOMÁTICO ====================
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
