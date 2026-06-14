--// HUB2
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")

local CONFIG_FILE = "autosettingsHUB2.json"

local state = {
    HarvestAll = false,
    SellAll = false,
    SpeedHub = false,
    BuyPet = false,
    ToGarden = false
}

--// LOAD CONFIG
if isfile and isfile(CONFIG_FILE) then
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(CONFIG_FILE))
    end)

    if ok and type(data) == "table" then
        for k, v in pairs(data) do
            state[k] = v
        end
    end
end

local function save()
    if writefile then
        writefile(CONFIG_FILE, HttpService:JSONEncode(state))
    end
end

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ToggleGUI"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local headerHeight = 40
local toggleSpacing = 50

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 270, 0, 420)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 1
stroke.Color = Color3.fromRGB(60, 60, 60)

--// HEADER
local header = Instance.new("Frame")
header.Parent = frame
header.Size = UDim2.new(1, 0, 0, headerHeight)
header.BackgroundTransparency = 1

local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "AUTO TRADEWORLD"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Parent = header
minimizeBtn.Size = UDim2.new(0, 80, 0, 26)
minimizeBtn.Position = UDim2.new(1, -90, 0, 7)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 13
minimizeBtn.Text = "Open"
minimizeBtn.BorderSizePixel = 0
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

--// SCROLL FRAME
local scroll = Instance.new("ScrollingFrame")
scroll.Parent = frame
scroll.Position = UDim2.new(0, 0, 0, headerHeight)
scroll.Size = UDim2.new(1, 0, 1, -headerHeight)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 4
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollingDirection = Enum.ScrollingDirection.Y

--// DRAG SYSTEM
local dragging = false
local dragStart
local startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--// STORAGE
local toggleObjects = {}

--// TOGGLE CREATOR
local function createToggle(titleText)
    local index = #toggleObjects / 2
    local y = index * toggleSpacing

    local label = Instance.new("TextLabel")
    label.Parent = scroll
    label.Size = UDim2.new(0.65, 0, 0, 40)
    label.Position = UDim2.new(0, 10, 0, y)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = titleText

    local bg = Instance.new("Frame")
    bg.Parent = scroll
    bg.Size = UDim2.new(0, 50, 0, 24)
    bg.Position = UDim2.new(1, -65, 0, y + 8)
    bg.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame")
    circle.Parent = bg
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = UDim2.new(0, 2, 0, 2)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    circle.BorderSizePixel = 0
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local click = Instance.new("TextButton")
    click.Parent = bg
    click.Size = UDim2.new(1, 0, 1, 0)
    click.BackgroundTransparency = 1
    click.Text = ""

    table.insert(toggleObjects, label)
    table.insert(toggleObjects, bg)

    scroll.CanvasSize = UDim2.new(
        0,
        0,
        0,
        ((#toggleObjects / 2) * toggleSpacing) + 20
    )

    return bg, circle, click
end

--// TOGGLES
local bgHarvestAll, circleHarvest, clickHarvest = createToggle("HarvestAll")
local bgSellAll, circleSell, clickSell = createToggle("SellAll")
local bgSpeedHub, circleSpeed, clickSpeed = createToggle("SpeedHub")
local bgBuyPet, circleBuyPet, clickBuyPet = createToggle("BuyPet")
local bgToGarden, circleToGarden, clickToGarden = createToggle("ToGarden")

--// UI UPDATE
local function setUI(enabled, bg, circle)
    if enabled then
        bg.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

        circle:TweenPosition(
            UDim2.new(1, -22, 0, 2),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.15,
            true
        )
    else
        bg.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

        circle:TweenPosition(
            UDim2.new(0, 2, 0, 2),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.15,
            true
        )
    end
end

local function update()
    setUI(state.HarvestAll, bgHarvestAll, circleHarvest)
    setUI(state.SellAll, bgSellAll, circleSell)
    setUI(state.SpeedHub, bgSpeedHub, circleSpeed)
    setUI(state.BuyPet, bgBuyPet, circleBuyPet)
    setUI(state.ToGarden, bgToGarden, circleToGarden)
end

update()

--// MINIMIZE SYSTEM
local minimized = true
local normalSize = UDim2.new(0, 270, 0, 420)

scroll.Visible = false
frame.Size = UDim2.new(0, 270, 0, headerHeight)

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized

    if minimized then
        scroll.Visible = false
        frame.Size = UDim2.new(0, 270, 0, headerHeight)
        minimizeBtn.Text = "Open"
    else
        scroll.Visible = true
        frame.Size = normalSize
        minimizeBtn.Text = "Minimize"
    end
end)

--// RUN FUNCTION
local function run(url)
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet(url, true))()
        end)
    end)
end

--// CLICK EVENTS

clickHarvest.MouseButton1Click:Connect(function()
    state.HarvestAll = not state.HarvestAll
    save()
    update()

    if state.HarvestAll then
        run("https://raw.githubusercontent.com/juraganzenx/HUB2/refs/heads/main/HARVESTALL")
    end
end)

clickSell.MouseButton1Click:Connect(function()
    state.SellAll = not state.SellAll
    save()
    update()

    if state.SellAll then
        run("https://raw.githubusercontent.com/juraganzenx/HUB2/refs/heads/main/SELLALL")
    end
end)

clickSpeed.MouseButton1Click:Connect(function()
    state.SpeedHub = not state.SpeedHub
    save()
    update()

    if state.SpeedHub then
        run("https://raw.githubusercontent.com/juraganzenx/HUB2/refs/heads/main/SPEED")
    end
end)

clickBuyPet.MouseButton1Click:Connect(function()
    state.BuyPet = not state.BuyPet
    save()
    update()

    if state.BuyPet then
        run("https://raw.githubusercontent.com/juraganzenx/HUB2/refs/heads/main/BUYWILDPET")
    end
end)

clickToGarden.MouseButton1Click:Connect(function()
    state.ToGarden = not state.ToGarden
    save()
    update()

    if state.ToGarden then
        run("https://raw.githubusercontent.com/juraganzenx/HUB2/refs/heads/main/TOGARDEN")
    end
end)


--// AUTO RUN ON START
for k, v in pairs(state) do
    if v then

        if k == "HarvestAll" then
            run("https://raw.githubusercontent.com/juraganzenx/HUB2/refs/heads/main/HARVESTALL")
        end

        if k == "SellAll" then
            run("https://raw.githubusercontent.com/juraganzenx/HUB2/refs/heads/main/SELLALL")
        end

        if k == "SpeedHub" then
            run("https://raw.githubusercontent.com/juraganzenx/HUB2/refs/heads/main/SPEED")
        end

        if k == "BuyPet" then
            run("https://raw.githubusercontent.com/juraganzenx/HUB2/refs/heads/main/BUYWILDPET")
        end

        if k == "ToGarden" then
            run("https://raw.githubusercontent.com/juraganzenx/HUB2/refs/heads/main/TOGARDEN")
        end

    end
end
