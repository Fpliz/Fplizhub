--[[
  Fpliz Hub - Universal Loader v5.0 FINAL
  Robust, Professional, Modular
]]

-- ==================== SERVICES ====================
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local player = game:GetService("Players").LocalPlayer

-- ==================== CONFIGURATION ====================
local HUB_NAME = "Fpliz Hub"
local HUB_VERSION = "v5.0"
local HUB_LOGO = "rbxassetid://82795327169782"
local HUB_COLOR = Color3.fromRGB(113, 93, 133)

-- Config global
local Config = {
    AntiAFK = {
        Enabled = true,
        Interval = 180
    },
    Loading = {
        FadeIn = 0.4,
        FadeOut = 0.3
    }
}

-- ==================== GAMES LIST ====================
local games = {
    [142823291] = {
        name = "Murder Mystery 2",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua",
        icon = "🔪",
        version = "1.2",
        status = "working",
        updated = "26/08/2026"
    },
    [116924926476457] = {
        name = "Murder Mystery V",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/mm2.lua",
        icon = "🔪",
        version = "1.2",
        status = "working",
        updated = "26/08/2026"
    },
    [3956818381] = {
        name = "Ninja Legends",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/ninja_legends.lua",
        icon = "🥷",
        version = "1.0",
        status = "working",
        updated = "25/08/2026"
    },
    [286090429] = {
        name = "Arsenal",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/arsenal.lua",
        icon = "🎯",
        version = "1.1",
        status = "working",
        updated = "26/08/2026"
    },
    [8737899170] = {
        name = "Pet Simulator 99",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/pet_simulator.lua",
        icon = "🐾",
        version = "1.0",
        status = "working",
        updated = "25/08/2026"
    },
    [6516141723] = {
        name = "Doors",
        script = "https://raw.githubusercontent.com/Fpliz/Fplizhub/main/games/doors.lua",
        icon = "🚪",
        version = "1.0",
        status = "working",
        updated = "26/08/2026"
    },
}

-- ==================== UI HELPERS ====================
local UI = {}

function UI:CreateScreen(name)
    local screen = Instance.new("ScreenGui")
    screen.Name = name
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = CoreGui
    return screen
end

function UI:CreateBackground(screen, transparency)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = transparency or 1
    bg.BorderSizePixel = 0
    bg.Parent = screen
    return bg
end

function UI:CreateCard(parent, size, position)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)
    
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = HUB_COLOR
    stroke.Thickness = 3
    stroke.Transparency = 0.3
    
    return frame
end

function UI:CreateLabel(parent, text, size, color, font, position)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, size)
    label.Position = position or UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.TextSize = size == 30 and 22 or size == 25 and 14 or 12
    label.Font = font or Enum.Font.Gotham
    label.TextTransparency = 1
    label.BorderSizePixel = 0
    label.Parent = parent
    return label
end

function UI:CreateButton(parent, text, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 40)
    btn.Position = position
    btn.BackgroundColor3 = HUB_COLOR
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150, 120, 180)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = HUB_COLOR}):Play()
    end)
    
    if callback then
        btn.MouseButton1Click:Connect(callback)
    end
    
    return btn
end

function UI:FadeIn(object, targetTransparency, targetPosition)
    local tweenData = {BackgroundTransparency = targetTransparency or 0}
    if targetPosition then
        tweenData.Position = targetPosition
    end
    TweenService:Create(object, TweenInfo.new(Config.Loading.FadeIn, Enum.EasingStyle.Quad), tweenData):Play()
end

function UI:FadeOut(object, callback)
    if object:IsA("Frame") then
        TweenService:Create(object, TweenInfo.new(Config.Loading.FadeOut), {BackgroundTransparency = 1}):Play()
    elseif object:IsA("TextLabel") then
        TweenService:Create(object, TweenInfo.new(Config.Loading.FadeOut), {TextTransparency = 1}):Play()
    elseif object:IsA("ImageLabel") then
        TweenService:Create(object, TweenInfo.new(Config.Loading.FadeOut), {ImageTransparency = 1}):Play()
    end
    
    if callback then
        task.delay(Config.Loading.FadeOut, callback)
    end
end

-- ==================== LOADING SCREEN ====================
local function showLoading(gameName, gameIcon)
    local screen = UI:CreateScreen("FplizLoading")
    local bg = UI:CreateBackground(screen, 1)
    local frame = UI:CreateCard(screen, UDim2.new(0, 380, 0, 240), UDim2.new(0.5, -190, 0.4, -120))
    
    local elements = {}
    
    -- Logo
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 60, 0, 60)
    logo.Position = UDim2.new(0.5, -30, 0, 15)
    logo.BackgroundTransparency = 1
    logo.Image = HUB_LOGO
    logo.ImageTransparency = 1
    logo.BorderSizePixel = 0
    logo.Parent = frame
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 15)
    table.insert(elements, logo)
    
    -- Ícone do jogo
    local gameIconLabel = Instance.new("TextLabel")
    gameIconLabel.Size = UDim2.new(0, 30, 0, 30)
    gameIconLabel.Position = UDim2.new(0.5, 40, 0, 30)
    gameIconLabel.BackgroundTransparency = 1
    gameIconLabel.Text = gameIcon or "🎮"
    gameIconLabel.TextSize = 20
    gameIconLabel.Parent = frame
    table.insert(elements, gameIconLabel)
    
    -- Título
    local title = UI:CreateLabel(frame, HUB_NAME .. " " .. HUB_VERSION, 30, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBlack, UDim2.new(0, 0, 0, 85))
    table.insert(elements, title)
    
    -- Status
    local status = UI:CreateLabel(frame, "Initializing...", 25, HUB_COLOR, Enum.Font.Gotham, UDim2.new(0, 0, 0, 120))
    table.insert(elements, status)
    
    -- Barra de progresso
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, -80, 0, 12)
    progressBg.Position = UDim2.new(0, 40, 0, 160)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    progressBg.BorderSizePixel = 0
    progressBg.BackgroundTransparency = 1
    progressBg.Parent = frame
    Instance.new("UICorner", progressBg).CornerRadius = UDim.new(0, 6)
    table.insert(elements, progressBg)
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = HUB_COLOR
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressBg
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 6)
    
    -- Porcentagem
    local percentLabel = UI:CreateLabel(frame, "0%", 20, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, UDim2.new(0, 0, 0, 180))
    table.insert(elements, percentLabel)
    
    -- FADE IN
    UI:FadeIn(bg, 0.5)
    UI:FadeIn(frame, 0, UDim2.new(0.5, -190, 0.5, -120))
    
    for _, element in ipairs(elements) do
        UI:FadeIn(element)
    end
    
    TweenService:Create(title, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(status, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(percentLabel, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    
    -- Retorna funções de controle
    return {
        Screen = screen,
        Frame = frame,
        Background = bg,
        Elements = elements,
        SetStatus = function(text)
            status.Text = text
        end,
        SetProgress = function(percent)
            percent = math.clamp(percent, 0, 100)
            progressFill.Size = UDim2.new(percent / 100, 0, 1, 0)
            percentLabel.Text = percent .. "%"
        end,
        Destroy = function()
            UI:FadeOut(bg)
            UI:FadeOut(frame, function()
                screen:Destroy()
            end)
            for _, element in ipairs(elements) do
                UI:FadeOut(element)
            end
        end
    }
end

-- ==================== ERROR SCREEN ====================
local function showError(errorType, gameId, retryCallback, errorDetails)
    local screen = UI:CreateScreen("FplizError")
    local bg = UI:CreateBackground(screen, 1)
    local frame = UI:CreateCard(screen, UDim2.new(0, 380, 0, 250), UDim2.new(0.5, -190, 0.4, -125))
    
    local elements = {}
    
    -- Logo
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 70, 0, 70)
    logo.Position = UDim2.new(0.5, -35, 0, 20)
    logo.BackgroundTransparency = 1
    logo.Image = HUB_LOGO
    logo.ImageTransparency = 1
    logo.BorderSizePixel = 0
    logo.Parent = frame
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 15)
    table.insert(elements, logo)
    
    -- Título baseado no tipo de erro
    local errorTitle = "Unknown Error"
    local errorMessage = "Something went wrong."
    
    if errorType == "unsupported" then
        errorTitle = "Game Not Supported"
        errorMessage = "This game is not supported yet.\n\nID: " .. gameId
    elseif errorType == "download" then
        errorTitle = "Download Failed"
        errorMessage = "Could not download the script.\nCheck your internet connection."
    elseif errorType == "execute" then
        errorTitle = "Script Error"
        errorMessage = "The script failed to execute."
        if errorDetails then
            errorMessage = errorMessage .. "\n\nError: " .. tostring(errorDetails)
        end
    end
    
    local title = UI:CreateLabel(frame, errorTitle, 30, Color3.fromRGB(255, 100, 100), Enum.Font.GothamBlack, UDim2.new(0, 0, 0, 100))
    table.insert(elements, title)
    
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -40, 0, 50)
    msg.Position = UDim2.new(0, 20, 0, 135)
    msg.BackgroundTransparency = 1
    msg.Text = errorMessage
    msg.TextColor3 = Color3.fromRGB(200, 200, 210)
    msg.TextSize = 14
    msg.Font = Enum.Font.Gotham
    msg.TextWrapped = true
    msg.TextTransparency = 1
    msg.Parent = frame
    table.insert(elements, msg)
    
    -- Botões
    if retryCallback then
        local retryBtn = UI:CreateButton(frame, "RETRY", UDim2.new(0, 30, 0, 195), function()
            screen:Destroy()
            retryCallback()
        end)
        table.insert(elements, retryBtn)
    end
    
    local closeBtn = UI:CreateButton(frame, "CLOSE", UDim2.new(1, -150, 0, 195), function()
        UI:FadeOut(bg)
        UI:FadeOut(frame, function()
            screen:Destroy()
        end)
        for _, element in ipairs(elements) do
            UI:FadeOut(element)
        end
    end)
    table.insert(elements, closeBtn)
    
    -- FADE IN
    UI:FadeIn(bg, 0.6)
    UI:FadeIn(frame, 0, UDim2.new(0.5, -190, 0.5, -125))
    
    for _, element in ipairs(elements) do
        UI:FadeIn(element)
    end
    
    TweenService:Create(title, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(msg, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    
    return screen
end

-- ==================== LOAD SCRIPT ====================
local function loadScript(gameConfig)
    local loading = showLoading(gameConfig.name, gameConfig.icon)
    
    local function attemptLoad()
        -- Fase 1: Inicializando
        loading.SetStatus("Initializing...")
        loading.SetProgress(10)
        task.wait(0.3)
        
        loading.SetStatus("Connecting...")
        loading.SetProgress(20)
        task.wait(0.2)
        
        -- Fase 2: Baixando
        loading.SetStatus("Downloading " .. gameConfig.name .. "...")
        loading.SetProgress(30)
        
        local success, result = pcall(function()
            return game:HttpGet(gameConfig.script)
        end)
        
        if not success then
            loading.SetStatus("Download failed")
            loading.SetProgress(60)
            task.wait(0.5)
            loading.Destroy()
            showError("download", game.PlaceId, function()
                loadScript(gameConfig)
            end)
            return false
        end
        
        loading.SetProgress(50)
        task.wait(0.2)
        
        -- Fase 3: Executando
        loading.SetStatus("Loading module...")
        loading.SetProgress(60)
        
        local loadSuccess, loadResult = pcall(function()
            loadstring(result)()
        end)
        
        if loadSuccess then
            -- SUCESSO
            loading.SetStatus("Initializing UI...")
            loading.SetProgress(80)
            task.wait(0.3)
            
            loading.SetStatus("Ready!")
            loading.SetProgress(95)
            task.wait(0.2)
            
            loading.SetStatus("Done!")
            loading.SetProgress(100)
            task.wait(0.3)
            
            loading.Destroy()
            return true
        else
            -- ERRO (usa loadResult para detalhes)
            loading.SetStatus("Execution failed")
            loading.SetProgress(60)
            task.wait(0.5)
            loading.Destroy()
            showError("execute", game.PlaceId, function()
                loadScript(gameConfig)
            end, loadResult)
            return false
        end
    end
    
    return attemptLoad()
end

-- ==================== MAIN ====================
local gameId = game.PlaceId
local gameConfig = games[gameId]

if gameConfig then
    loadScript(gameConfig)
else
    showError("unsupported", gameId, nil)
    warn("[Fpliz Hub] Game not supported: " .. gameId)
end

-- ==================== ANTI-AFK ====================
if Config.AntiAFK.Enabled then
    task.spawn(function()
        while true do
            task.wait(Config.AntiAFK.Interval)
            pcall(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightShift, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightShift, false, game)
            end)
        end
    end)
end
