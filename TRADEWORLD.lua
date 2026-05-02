--// SERVICES
local HttpService = game:GetService("HttpService")

local CONFIG_FILE = "autosettings.json"

local state = {
    AutoClaim = false,
    AutoListing = false,
    AutoReconnect = false,
    AutoTeleport = false,
    AutoSnipe = false,
    AutoHop = false,
    AutoNotifPet = false,
    AutoTradeGive = false,
    AutoTradeReceive = false,
    AutoPetCount = false -- NEW TOGGLE
}

--// LOAD CONFIG
if isfile and isfile(CONFIG_FILE) then
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(CONFIG_FILE))
    end)
    if ok and type(data) == "table" then
        state = data
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
frame.Size = UDim2.new(0, 260, 0, headerHeight) -- akan diupdate setelah toggle dibuat
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BackgroundTransparency = 0.25
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 1
stroke.Color = Color3.fromRGB(60,60,60)

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
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Parent = header
minimizeBtn.Size = UDim2.new(0, 80, 0, 26)
minimizeBtn.Position = UDim2.new(1, -90, 0, 7)
minimizeBtn.Text = "Minimize"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

--// STORAGE
local toggleObjects = {}

--// TOGGLE CREATOR
local function createToggle(titleText)
    local y = #toggleObjects / 2 * toggleSpacing + headerHeight

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.6, 0, 0, 40)
    label.Position = UDim2.new(0, 10, 0, y)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = titleText

    local bg = Instance.new("Frame")
    bg.Parent = frame
    bg.Size = UDim2.new(0, 50, 0, 24)
    bg.Position = UDim2.new(1, -60, 0, y + 8)
    bg.BackgroundColor3 = Color3.fromRGB(70,70,70)
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1,0)

    local circle = Instance.new("Frame")
    circle.Parent = bg
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = UDim2.new(0, 2, 0, 2)
    circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

    local click = Instance.new("TextButton")
    click.Parent = bg
    click.Size = UDim2.new(1,0,1,0)
    click.BackgroundTransparency = 1
    click.Text = ""

    table.insert(toggleObjects, label)
    table.insert(toggleObjects, bg)

    -- Update frame height
    frame.Size = UDim2.new(0, 260, 0, headerHeight + (#toggleObjects / 2) * toggleSpacing)

    return bg, circle, click
end

--// TOGGLES
local bgClaim, circleClaim, clickClaim = createToggle("AUTO CLAIM BOOTH")
local bgList, circleList, clickList = createToggle("AUTO LISTING")
local bgReconnect, circleReconnect, clickReconnect = createToggle("AUTO RECONNECT")
local bgTeleport, circleTeleport, clickTeleport = createToggle("TELEPORT IF <20 PLAYER")
local bgHop, circleHop, clickHop = createToggle("HOP IF NOT SELL >30MNT")
local bgSnipe, circleSnipe, clickSnipe = createToggle("SNIPE MARKET")
local bgNotif, circleNotif, clickNotif = createToggle("NOTIF IF PET >50")
local bgTradeGive, circleTradeGive, clickTradeGive = createToggle("AUTO TRADE PENERIMA")
local bgTradeReceive, circleTradeReceive, clickTradeReceive = createToggle("AUTO TRADE PEMBERI")
local bgPetCount, circlePetCount, clickPetCount = createToggle("PET COUNT") -- NEW

--// UI UPDATE
local function setUI(enabled, bg, circle)
    if enabled then
        bg.BackgroundColor3 = Color3.fromRGB(0,200,0)
        circle:TweenPosition(UDim2.new(1, -22, 0, 2), "Out", "Quad", 0.15, true)
    else
        bg.BackgroundColor3 = Color3.fromRGB(70,70,70)
        circle:TweenPosition(UDim2.new(0, 2, 0, 2), "Out", "Quad", 0.15, true)
    end
end

local function update()
    setUI(state.AutoClaim, bgClaim, circleClaim)
    setUI(state.AutoListing, bgList, circleList)
    setUI(state.AutoReconnect, bgReconnect, circleReconnect)
    setUI(state.AutoTeleport, bgTeleport, circleTeleport)
    setUI(state.AutoSnipe, bgSnipe, circleSnipe)
    setUI(state.AutoHop, bgHop, circleHop)
    setUI(state.AutoNotifPet, bgNotif, circleNotif)
    setUI(state.AutoTradeGive, bgTradeGive, circleTradeGive)
    setUI(state.AutoTradeReceive, bgTradeReceive, circleTradeReceive)
    setUI(state.AutoPetCount, bgPetCount, circlePetCount)
end

update()

--// MINIMIZE SYSTEM
local minimized = true
for _, v in pairs(toggleObjects) do
    v.Visible = false
end
local normalSize = frame.Size
frame.Size = UDim2.new(normalSize.X.Scale, normalSize.X.Offset, 0, headerHeight)
minimizeBtn.Text = "Open"

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        for _, v in pairs(toggleObjects) do v.Visible = false end
        frame.Size = UDim2.new(normalSize.X.Scale, normalSize.X.Offset, 0, headerHeight)
        minimizeBtn.Text = "Open"
    else
        for _, v in pairs(toggleObjects) do v.Visible = true end
        frame.Size = normalSize
        minimizeBtn.Text = "Minimize"
    end
end)

--// RUN FUNCTION
local function run(url)
    task.spawn(function()
        loadstring(game:HttpGet(url, true))()
    end)
end

--// CLICK EVENTS
clickClaim.MouseButton1Click:Connect(function()
    state.AutoClaim = not state.AutoClaim
    save()
    update()
    if state.AutoClaim then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/CLAIM%20BOOTH.lua") end
end)
clickList.MouseButton1Click:Connect(function()
    state.AutoListing = not state.AutoListing
    save()
    update()
    if state.AutoListing then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/AUTOLISTING.lua") end
end)
clickReconnect.MouseButton1Click:Connect(function()
    state.AutoReconnect = not state.AutoReconnect
    save()
    update()
    if state.AutoReconnect then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/AUTO%20RECCONECT%20IF%20DC.lua") end
end)
clickTeleport.MouseButton1Click:Connect(function()
    state.AutoTeleport = not state.AutoTeleport
    save()
    update()
    if state.AutoTeleport then run("https://pastebin.com/raw/nA4xeCk3") end
end)
clickSnipe.MouseButton1Click:Connect(function()
    state.AutoSnipe = not state.AutoSnipe
    save()
    update()
    if state.AutoSnipe then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/MARKET%20SNIPE.lua") end
end)
clickHop.MouseButton1Click:Connect(function()
    state.AutoHop = not state.AutoHop
    save()
    update()
    if state.AutoHop then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/HOP%20IF%20NOT%20SELL.lua") end
end)
clickNotif.MouseButton1Click:Connect(function()
    state.AutoNotifPet = not state.AutoNotifPet
    save()
    update()
    if state.AutoNotifPet then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/NOTIF%20IF%20PET%20%2B120.lua") end
end)
clickTradeGive.MouseButton1Click:Connect(function()
    state.AutoTradeGive = not state.AutoTradeGive
    save()
    update()
    if state.AutoTradeGive then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/AUTOTRADE%20RECIVE.lua") end
end)
clickTradeReceive.MouseButton1Click:Connect(function()
    state.AutoTradeReceive = not state.AutoTradeReceive
    save()
    update()
    if state.AutoTradeReceive then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/AUTOTRADE%20RECIVER.lua") end
end)
clickPetCount.MouseButton1Click:Connect(function()
    state.AutoPetCount = not state.AutoPetCount
    save()
    update()
    if state.AutoPetCount then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/PET%20COUNT.lua") end
end)

--// AUTO RUN ON START
for k, v in pairs(state) do
    if v then
        if k == "AutoClaim" then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/CLAIM%20BOOTH.lua") end
        if k == "AutoListing" then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/AUTOLISTING.lua") end
        if k == "AutoReconnect" then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/AUTO%20RECCONECT%20IF%20DC.lua") end
        if k == "AutoTeleport" then run("https://pastebin.com/raw/nA4xeCk3") end
        if k == "AutoSnipe" then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/MARKET%20SNIPE.lua") end
        if k == "AutoHop" then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/HOP%20IF%20NOT%20SELL.lua") end
        if k == "AutoNotifPet" then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/NOTIF%20IF%20PET%20%2B120.lua") end
        if k == "AutoTradeGive" then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/AUTOTRADE%20RECIVE.lua") end
        if k == "AutoTradeReceive" then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/AUTOTRADE%20RECIVER.lua") end
        if k == "AutoPetCount" then run("https://raw.githubusercontent.com/juraganzenx/HUB/refs/heads/main/PET%20COUNT.lua") end
    end
end
