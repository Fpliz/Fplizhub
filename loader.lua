--[[
  Fpliz Hub - Universal Loader v2.1
  Atualizado: Removeu Steal An Egg, Adicionou Blox Fruits
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
local HUB_VERSION = "v2.1"
local HUB_COLOR = Color3.fromRGB(113, 93, 133)

-- ==================== LISTA DE JOGOS ====================
local games = {
    -- Murder Mystery 2 (MM2)
    [142823291] = {
        name = "Murder Mystery 2",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua",
        icon = "🔪"
    },
    
    -- Murder Mystery V (MMV)
    [116924926476457] = {
        name = "Murder Mystery V",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua",
        icon = "🔪"
    },
    
    -- Prison Life
    [155615604] = {
        name = "Prison Life",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/prison_life.lua",
        icon = "⛓️"
    },
    
    -- Ninja Legends
    [3956818381] = {
        name = "Ninja Legends",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/ninja_legends.lua",
        icon = "🥷"
    },
    
    -- Blox Fruits (Sea 1)
    [2753915549] = {
        name = "Blox Fruits",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/blox_fruits.lua",
        icon = "🍎"
    },
    
    -- Blox Fruits (Sea 2)
    [4442272183] = {
        name = "Blox Fruits [Sea 2]",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/blox_fruits.lua",
        icon = "🍎"
    },
    
    -- Blox Fruits (Sea 3)
    [7449423635] = {
        name = "Blox Fruits [Sea 3]",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/blox_fruits.lua",
        icon = "🍎"
    },
}

-- ==================== FUNÇÃO DE NOTIFICAÇÃO ====================
local function notify(title, content, duration)
    duration = duration or 3
    
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
    frame.ClipsDescendants = true
    frame.Parent = screen
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = HUB_COLOR
    stroke.Thickness = 2
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 10, 0, 10)
    icon.BackgroundTransparency = 1
    icon.Text = "📢"
    icon.TextSize = 20
    icon.Parent = frame
    
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
    
    -- Animação de entrada
    frame.Position = UDim2.new(1, 20, 0, 20)
    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -320, 0, 20)})
    tweenIn:Play()
    
    -- Animação de saída
    task.delay(duration, function()
        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(1, 20, 0, 20)})
        tweenOut:Play()
        tweenOut.Completed:Wait()
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
    
    -- Fundo escuro
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.5
    background.Parent = screen
    
    -- Frame central
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 200)
    frame.Position = UDim2.new(0.5, -200, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.Parent = screen
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = HUB_COLOR
    stroke.Thickness = 3
    
    -- Ícone do jogo
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 60, 0, 60)
    iconLabel.Position = UDim2.new(0.5, -30, 0, 20)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = gameIcon or "🎮"
    iconLabel.TextSize = 40
    iconLabel.Parent = frame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 90)
    title.BackgroundTransparency = 1
    title.Text = HUB_NAME .. " " .. HUB_VERSION
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    -- Status
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 30)
    status.Position = UDim2.new(0, 0, 0, 130)
    status.BackgroundTransparency = 1
    status.Text = "Carregando " .. gameName .. "..."
    status.TextColor3 = HUB_COLOR
    status.TextSize = 14
    status.Font = Enum.Font.Gotham
    status.Parent = frame
    
    -- Barra de progresso
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, -80, 0, 10)
    progressBg.Position = UDim2.new(0, 40, 0, 170)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    progressBg.Parent = frame
    Instance.new("UICorner", progressBg).CornerRadius = UDim.new(0, 5)
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = HUB_COLOR
    progressFill.Parent = progressBg
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 5)
    
    -- Animação de loading
    task.spawn(function()
        local progress = 0
        while progress < 1 do
            progress = math.min(progress + 0.02, 0.9)
            progressFill.Size = UDim2.new(progress, 0, 1, 0)
            task.wait(0.05)
        end
    end)
    
    return screen, progressFill
end

-- ==================== FUNÇÃO DE JOGO NÃO SUPORTADO ====================
local function showUnsupported(gameId)
    local screen = Instance.new("ScreenGui")
    screen.Name = "FplizUnsupported"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = CoreGui
    
    -- Fundo escuro
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.5
    background.Parent = screen
    
    -- Frame central
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 250)
    frame.Position = UDim2.new(0.5, -200, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.Parent = screen
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = HUB_COLOR
    stroke.Thickness = 3
    
    -- Ícone
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 60, 0, 60)
    iconLabel.Position = UDim2.new(0.5, -30, 0, 20)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = "❌"
    iconLabel.TextSize = 40
    iconLabel.Parent = frame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 90)
    title.BackgroundTransparency = 1
    title.Text = HUB_NAME
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    -- Mensagem
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -40, 0, 60)
    msg.Position = UDim2.new(0, 20, 0, 130)
    msg.BackgroundTransparency = 1
    msg.Text = "Jogo não suportado!\n\nID: " .. gameId .. "\n\nAguarde updates futuros."
    msg.TextColor3 = Color3.fromRGB(180, 180, 190)
    msg.TextSize = 14
    msg.Font = Enum.Font.Gotham
    msg.TextWrapped = true
    msg.Parent = frame
    
    -- Botão fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 120, 0, 35)
    closeBtn.Position = UDim2.new(0.5, -60, 0, 200)
    closeBtn.BackgroundColor3 = HUB_COLOR
    closeBtn.Text = "FECHAR"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = frame
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150, 120, 180)}):Play()
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = HUB_COLOR}):Play()
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        screen:Destroy()
    end)
    
    -- Botão copiar ID
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 120, 0, 35)
    copyBtn.Position = UDim2.new(0, 40, 0, 200)
    copyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    copyBtn.Text = "COPIAR ID"
    copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyBtn.TextSize = 14
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.AutoButtonColor = false
    copyBtn.Parent = frame
    Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)
    
    copyBtn.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard(tostring(gameId))
            notify("ID Copiado", "ID: " .. gameId, 2)
        end)
    end)
end

-- ==================== FUNÇÃO DE CARREGAMENTO ====================
local function loadScript(url, gameName, gameIcon)
    local loadingScreen, progressFill = showLoading(gameName, gameIcon)
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success then
        loadingScreen:Destroy()
        notify("Erro", "Falha ao baixar script!", 3)
        return false
    end
    
    progressFill.Size = UDim2.new(1, 0, 1, 0)
    task.wait(0.3)
    
    local loadSuccess, loadResult = pcall(function()
        loadstring(result)()
    end)
    
    loadingScreen:Destroy()
    
    if not loadSuccess then
        notify("Erro", "Falha ao executar: " .. tostring(loadResult), 3)
        return false
    end
    
    return true
end

-- ==================== EXECUÇÃO PRINCIPAL ====================
local gameId = game.PlaceId
local gameConfig = games[gameId]

if gameConfig then
    -- Notificação de boas-vindas
    notify(HUB_NAME, "Bem-vindo! Carregando " .. gameConfig.name .. "...", 2)
    
    -- Carrega o script
    local success = loadScript(gameConfig.script, gameConfig.name, gameConfig.icon)
    
    if success then
        notify("Sucesso", gameConfig.icon .. " " .. gameConfig.name .. " carregado!", 3)
    end
else
    -- Jogo não suportado
    showUnsupported(gameId)
    
    -- Log no console
    warn("[" .. HUB_NAME .. "] Jogo não suportado: " .. gameId)
    print("[" .. HUB_NAME .. "] Adicione no loader:")
    print("[" .. gameId .. "] = {")
    print("    name = \"NOME_DO_JOGO\",")
    print("    script = \"https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/nome_do_jogo.lua\",")
    print("    icon = \"🎮\"")
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
