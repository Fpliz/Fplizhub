--[[
  Fpliz Hub - Universal Loader v2
  Compatível com todos os executores
]]

-- ==================== FUNÇÃO HTTP COMPATÍVEL ====================
local HttpGet

-- Tenta usar game:HttpGet (Synapse X, Script-Ware)
if not HttpGet and syn and syn.request then
    HttpGet = function(url)
        local response = syn.request({
            Url = url,
            Method = "GET"
        })
        return response.Body
    end
end

-- Tenta usar request (Fluxus, Krnl)
if not HttpGet and request then
    HttpGet = function(url)
        local response = request({
            Url = url,
            Method = "GET"
        })
        return response.Body
    end
end

-- Tenta usar http_request (alguns executores)
if not HttpGet and http_request then
    HttpGet = function(url)
        local response = http_request({
            Url = url,
            Method = "GET"
        })
        return response.Body
    end
end

-- Tenta usar game:HttpGet (padrão)
if not HttpGet and game and game.HttpGet then
    HttpGet = function(url)
        return game:HttpGet(url)
    end
end

-- Se não tiver nenhum, mostra erro
if not HttpGet then
    warn("[Fpliz Hub] Seu executor não suporta HTTP requests!")
    warn("[Fpliz Hub] Use: Synapse X, Krnl, Fluxus ou Script-Ware")
end

-- ==================== SERVIÇOS ====================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer

-- ==================== CONFIGURAÇÕES ====================
local HUB_NAME = "Fpliz Hub"
local HUB_VERSION = "v2.0"
local HUB_COLOR = Color3.fromRGB(113, 93, 133)

-- ==================== LISTA DE JOGOS ====================
local games = {
    [142823291] = {
        name = "Murder Mystery 2",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua",
        icon = "🔪"
    },
    
    [116924926476457] = {
        name = "Murder Mystery V",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua",
        icon = "🔪"
    },
    
    [107778070777162] = {
        name = "Steal An Egg",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/steal_an_egg.lua",
        icon = "🥚"
    },
    
    [155615604] = {
        name = "Prison Life",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/prison_life.lua",
        icon = "⛓️"
    },
    
    [3956818381] = {
        name = "Ninja Legends",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/ninja_legends.lua",
        icon = "🥷"
    },
}

-- ==================== NOTIFICAÇÃO SIMPLES ====================
local function notify(title, content, duration)
    duration = duration or 3
    
    pcall(function()
        local screen = Instance.new("ScreenGui")
        screen.Name = "FplizNotification"
        screen.ResetOnSpawn = false
        screen.IgnoreGuiInset = true
        screen.Parent = CoreGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 300, 0, 80)
        frame.Position = UDim2.new(1, -320, 0, 20)
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        frame.BorderSizePixel = 0
        frame.Parent = screen
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = HUB_COLOR
        stroke.Thickness = 2
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -20, 0, 20)
        titleLabel.Position = UDim2.new(0, 10, 0, 5)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextSize = 14
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = frame
        
        local contentLabel = Instance.new("TextLabel")
        contentLabel.Size = UDim2.new(1, -20, 0, 40)
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

-- ==================== LOADING SIMPLES ====================
local function showLoading(gameName)
    local screen = Instance.new("ScreenGui")
    screen.Name = "FplizLoading"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.Parent = CoreGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 150)
    frame.Position = UDim2.new(0.5, -200, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.Parent = screen
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = HUB_COLOR
    stroke.Thickness = 3
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = HUB_NAME .. " " .. HUB_VERSION
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 30)
    status.Position = UDim2.new(0, 0, 0, 70)
    status.BackgroundTransparency = 1
    status.Text = "Carregando " .. gameName .. "..."
    status.TextColor3 = HUB_COLOR
    status.TextSize = 14
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
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = HUB_NAME
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -40, 0, 80)
    msg.Position = UDim2.new(0, 20, 0, 60)
    msg.BackgroundTransparency = 1
    msg.Text = "Jogo não suportado!\n\nID: " .. gameId .. "\n\nAguarde updates futuros."
    msg.TextColor3 = Color3.fromRGB(180, 180, 190)
    msg.TextSize = 14
    msg.Font = Enum.Font.Gotham
    msg.TextWrapped = true
    msg.Parent = frame
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 120, 0, 35)
    closeBtn.Position = UDim2.new(0.5, -60, 0, 150)
    closeBtn.BackgroundColor3 = HUB_COLOR
    closeBtn.Text = "FECHAR"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = frame
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    
    closeBtn.MouseButton1Click:Connect(function()
        screen:Destroy()
    end)
end

-- ==================== CARREGAR SCRIPT ====================
local function loadScript(url, gameName, gameIcon)
    if not HttpGet then
        notify("Erro", "Executor não suporta HTTP!", 3)
        return false
    end
    
    local loadingScreen = showLoading(gameName)
    
    local success, result = pcall(function()
        return HttpGet(url)
    end)
    
    if not success or not result then
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
        notify("Erro", "Falha ao executar: " .. tostring(loadResult), 3)
        return false
    end
    
    return true
end

-- ==================== EXECUÇÃO PRINCIPAL ====================
local gameId = game.PlaceId
local gameConfig = games[gameId]

if gameConfig then
    notify(HUB_NAME, "Bem-vindo! Carregando " .. gameConfig.name .. "...", 2)
    
    local success = loadScript(gameConfig.script, gameConfig.name, gameConfig.icon)
    
    if success then
        notify("Sucesso", gameConfig.icon .. " " .. gameConfig.name .. " carregado!", 3)
    end
else
    showUnsupported(gameId)
    
    warn("[" .. HUB_NAME .. "] Jogo não suportado: " .. gameId)
end
