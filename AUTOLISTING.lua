-- AutoListing + Per Pet Price + Anti AFK + Smart Hop System

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local DataService = require(ReplicatedStorage.Modules.DataService)
local TradeEvents = ReplicatedStorage.GameEvents.TradeEvents
local PetList = require(ReplicatedStorage.Data.PetRegistry).PetList

-- ======================
-- ANTI AFK
-- ======================
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

task.spawn(function()
    while true do
        task.wait(60)
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

local fileName = "AutoPetConfig.json"

-- ======================
-- CONFIG
-- ======================
local AutoConfig = {
    Enabled = true,
    SelectedPets = {},
    PriceMap = {},
    DefaultPrice = 0,
    Delay = 5
}

-- ======================
-- TARGET PLAYER CHECK
-- ======================
local TargetPlayers = {
    ["setokcolossal"] = true,
    ["setokcolossal1"] = true,
    ["setokcolossal2"] = true,
    ["CihuyyXuhuyyy11"] = true,
    ["CihuyyXuhuyyy13"] = true,
    ["setokmimic1"] = true
}

local function isTargetInServer()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Name ~= player.Name and TargetPlayers[plr.Name] then
            return true
        end
    end
    return false
end

local function saveConfig()
    local data = {
        SelectedPets = AutoConfig.SelectedPets,
        PriceMap = AutoConfig.PriceMap
    }

    if writefile then
        writefile(fileName, HttpService:JSONEncode(data))
    end
end

local function loadConfig()
    if isfile and isfile(fileName) then
        local raw = readfile(fileName)
        local data = HttpService:JSONDecode(raw)

        if data then
            AutoConfig.SelectedPets = data.SelectedPets or {}
            AutoConfig.PriceMap = data.PriceMap or {}
        end
    end
end

loadConfig()


-- ======================
-- SERVER HOP (RAMAI >20)
-- ======================
local function serverHop()
    local placeId = game.PlaceId

    -- detect teleport failure
    TeleportService.TeleportInitFailed:Connect(function(_, result, err)
        warn("Teleport FAILED:", result, err)
    end)

    while true do
        warn("SEARCHING SERVER >20 PLAYERS...")

        local success, result = pcall(function()
            return HttpService:JSONDecode(
                game:HttpGet(
                    "https://games.roblox.com/v1/games/" ..
                    placeId ..
                    "/servers/Public?sortOrder=Desc&limit=100"
                )
            )
        end)

        local candidates = {}

        if success and result and result.data then
            for _, server in ipairs(result.data) do
                if server.playing > 20
                and server.playing < server.maxPlayers
                and server.id ~= game.JobId then
                    table.insert(candidates, server)
                end
            end
        end

        if #candidates > 0 then
            table.sort(candidates, function(a, b)
                return a.playing > b.playing
            end)

            local target = candidates[math.random(1, math.min(#candidates, 5))]

            local ok = pcall(function()
                TeleportService:TeleportToPlaceInstance(
                    placeId,
                    target.id,
                    LocalPlayer
                )
            end)

            if ok then
                warn("Teleport attempted → waiting result...")
                task.wait(5) -- kasih waktu join / gagal
            else
                warn("Teleport call failed → retrying...")
            end
        else
            warn("No valid server found → retry in 3s")
        end

        task.wait(3)
    end
end


-- ======================
-- BUILD PET LIST
-- ======================
local PetNames = {}
for petName in PetList do
    table.insert(PetNames, petName)
end
table.sort(PetNames)

if #AutoConfig.SelectedPets == 0 then
    AutoConfig.SelectedPets = {PetNames[1]}
end

local function isPetSelected(name)
    return table.find(AutoConfig.SelectedPets, name) ~= nil
end

-- ======================
-- GUI
-- ======================
local gui = Instance.new("ScreenGui")
gui.Name = "AutoListingGUI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.17, 0.62)
frame.Position = UDim2.fromScale(0.83, 0.02)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BackgroundTransparency = 0.25
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0.07,0)
title.BackgroundTransparency = 1
title.Text = "Auto Trading System"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- DROPDOWN BUTTON
local dropdownBtn = Instance.new("TextButton", frame)
dropdownBtn.Size = UDim2.new(0.9,0,0.07,0)
dropdownBtn.Position = UDim2.fromScale(0.05,0.08)
dropdownBtn.Text = "Selected: 1"
dropdownBtn.BackgroundColor3 = Color3.fromRGB(55,55,55)
dropdownBtn.TextColor3 = Color3.new(1,1,1)
dropdownBtn.TextScaled = true

-- DROPDOWN FRAME
local dropFrame = Instance.new("Frame", frame)
dropFrame.Size = UDim2.new(0.9,0,0.42,0)
dropFrame.Position = UDim2.fromScale(0.05,0.16)
dropFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
dropFrame.Visible = false

local searchBox = Instance.new("TextBox", dropFrame)
searchBox.Size = UDim2.new(1,-10,0,28)
searchBox.Position = UDim2.fromOffset(5,5)
searchBox.PlaceholderText = "Search..."
searchBox.Text = ""
searchBox.BackgroundColor3 = Color3.fromRGB(55,55,55)
searchBox.TextColor3 = Color3.new(1,1,1)

local listFrame = Instance.new("ScrollingFrame", dropFrame)
listFrame.Position = UDim2.fromOffset(5,38)
listFrame.Size = UDim2.new(1,-10,1,-43)
listFrame.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", listFrame)
layout.Padding = UDim.new(0,5)

-- BUTTONS
local hopCheckBtn = Instance.new("TextButton", frame)
hopCheckBtn.Size = UDim2.new(0.9,0,0.07,0)
hopCheckBtn.Position = UDim2.fromScale(0.05,0.62)
hopCheckBtn.Text = "CHECK PLAYER"
hopCheckBtn.BackgroundColor3 = Color3.fromRGB(50,120,200)
hopCheckBtn.TextColor3 = Color3.new(1,1,1)
hopCheckBtn.TextScaled = true

local hopBtn = Instance.new("TextButton", frame)
hopBtn.Size = UDim2.new(0.9,0,0.07,0)
hopBtn.Position = UDim2.fromScale(0.05,0.70)
hopBtn.Text = "SERVER HOP"
hopBtn.BackgroundColor3 = Color3.fromRGB(120,80,200)
hopBtn.TextColor3 = Color3.new(1,1,1)
hopBtn.TextScaled = true

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0.9,0,0.07,0)
toggleBtn.Position = UDim2.fromScale(0.05,0.78)
toggleBtn.Text = "START"
toggleBtn.BackgroundColor3 = Color3.fromRGB(170,50,50)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.TextScaled = true

-- ======================
-- LIST UI
-- ======================
local petButtons = {}

local function rebuildList(filter)
    for _, b in ipairs(petButtons) do b:Destroy() end
    table.clear(petButtons)

    filter = filter and filter:lower() or ""

    -- SORT: selected dulu, baru alphabet
    table.sort(PetNames, function(a, b)
        local aSel = isPetSelected(a)
        local bSel = isPetSelected(b)

        if aSel ~= bSel then
            return aSel -- selected di atas
        end

        return a < b -- sisanya alphabet
    end)

    for _, petName in ipairs(PetNames) do
        if filter == "" or petName:lower():find(filter, 1, true) then

            local container = Instance.new("Frame")
            container.Size = UDim2.new(1,-5,0,30)
            container.BackgroundTransparency = 1
            container.Parent = listFrame

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.6,0,1,0)
            btn.Text = petName
            btn.TextScaled = true

            btn.BackgroundColor3 = isPetSelected(petName)
                and Color3.fromRGB(80,170,80)
                or Color3.fromRGB(60,60,60)

            btn.Parent = container

            local priceBox = Instance.new("TextBox")
            priceBox.Size = UDim2.new(0.4,-4,1,0)
            priceBox.Position = UDim2.new(0.6,4,0,0)
            priceBox.Text = tostring(AutoConfig.PriceMap[petName] or AutoConfig.DefaultPrice)
            priceBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
            priceBox.TextColor3 = Color3.new(1,1,1)
            priceBox.Parent = container

            priceBox.FocusLost:Connect(function()
                local v = tonumber(priceBox.Text)
                if v then
                    AutoConfig.PriceMap[petName] = math.floor(v)
                    saveConfig() -- 👈 TAMBAH INI
                end
            end)

            btn.Activated:Connect(function()
                local idx = table.find(AutoConfig.SelectedPets, petName)
                if idx then
                    table.remove(AutoConfig.SelectedPets, idx)
                else
                    table.insert(AutoConfig.SelectedPets, petName)
                end

                saveConfig() -- 👈 TAMBAH INI

                dropdownBtn.Text = "Selected: "..#AutoConfig.SelectedPets
                rebuildList(searchBox.Text)
            end)

            table.insert(petButtons, container)
        end
    end
end

rebuildList()
dropFrame.Visible = true
dropdownBtn.Text = "Selected: "..#AutoConfig.SelectedPets

dropdownBtn.Activated:Connect(function()
    dropFrame.Visible = not dropFrame.Visible
end)

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    rebuildList(searchBox.Text)
end)

-- ======================
-- AUTO LIST
-- ======================
local function autoList()
    while AutoConfig.Enabled do
        local data = DataService:GetData()
        if data and data.PetsData then
            for petId, pet in data.PetsData.PetInventory.Data do
                if table.find(AutoConfig.SelectedPets, pet.PetType) then
                    local price = AutoConfig.PriceMap[pet.PetType] or AutoConfig.DefaultPrice

                    TradeEvents.Booths.CreateListing:InvokeServer("Pet", petId, price)
                    task.wait(AutoConfig.Delay)
                end
            end
        end
        task.wait(2)
    end
end

-- ======================
-- BUTTON EVENTS
-- ======================
toggleBtn.Activated:Connect(function()
    AutoConfig.Enabled = not AutoConfig.Enabled
    if AutoConfig.Enabled then
        toggleBtn.Text = "STOP"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60,170,60)
        task.spawn(autoList)
    else
        toggleBtn.Text = "START"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(170,50,50)
    end
end)

hopCheckBtn.Activated:Connect(function()
    if isTargetInServer() then
        hopCheckBtn.Text = "FOUND"
        hopCheckBtn.BackgroundColor3 = Color3.fromRGB(170,50,50)
    else
        hopCheckBtn.Text = "SAFE SERVER"
        hopCheckBtn.BackgroundColor3 = Color3.fromRGB(60,170,60)
        task.wait(2)
        hopCheckBtn.Text = "CHECK PLAYER"
        hopCheckBtn.BackgroundColor3 = Color3.fromRGB(60,170,60)
    end
end)

hopBtn.Activated:Connect(function()
    hopBtn.Text = "HOPPING..."
    serverHop()
end)

-- AUTO START (taruh paling bawah script)
task.spawn(function()
    task.wait(10) -- kasih waktu GUI & function load dulu

    if not AutoConfig.Enabled then
        AutoConfig.Enabled = true
    end

    toggleBtn.Text = "STOP"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60,170,60)

    task.spawn(autoList)
end)
