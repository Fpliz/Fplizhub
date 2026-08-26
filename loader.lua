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
    logo.Position = UDim2.new(0.5, -60, 0, 0)
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
    version.Text = "v" .. HUB_VERSION
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
    logo.Position = UDim2.new(0.5, -60, 0, -30)
    TweenService:Create(logo, TweenInfo.new(0.8, Enum.EasingStyle.Back), {
        ImageTransparency = 0,
        Position = UDim2.new(0.5, -60, 0, 0)
    }):Play()
    
    -- FADE IN dos textos
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
