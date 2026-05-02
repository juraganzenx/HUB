-- IDs
local TRADE_WORLD_ID = 129954712878723

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

math.randomseed(tick())

-- Events
local travelEventToTrade = ReplicatedStorage
    :WaitForChild("GameEvents")
    :WaitForChild("TradeWorld")
    :WaitForChild("TravelToTradeWorld")

local claimBoothEvent = ReplicatedStorage
    :WaitForChild("GameEvents")
    :WaitForChild("TradeEvents")
    :WaitForChild("Booths")
    :WaitForChild("ClaimBooth")

------------------------------------------------
-- BLACKLIST (IGNORE SELF)
------------------------------------------------
local blacklist = {
    ["Ochil_28"] = true,
    ["setokmimic"] = true,
    ["CihuyyXuhuyyy11"] = true
}

local function isBlacklistedPlayerPresent()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name ~= LocalPlayer.Name then
            if blacklist[p.Name] then
                return p.Name
            end
        end
    end
    return nil
end

------------------------------------------------
-- RANDOM SERVER HOP
------------------------------------------------
local function hopServer()
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

------------------------------------------------
-- BOOTH OWNER CHECK
------------------------------------------------
local function getBoothOwnerFromSurfaceGui(booth)
    for _, d in ipairs(booth:GetDescendants()) do
        if d:IsA("SurfaceGui") then
            for _, g in ipairs(d:GetDescendants()) do
                if g:IsA("TextLabel") then
                    local txt = g.Text

                    if txt and txt ~= "" then
                        local l = txt:lower()

                        if l:find("claim")
                        or l:find("rent")
                        or l:find("empty")
                        or l:find("buy")
                        or l:find("open") then
                            continue
                        end

                        if #txt >= 3 and #txt <= 20 then
                            return txt
                        end
                    end
                end
            end
        end
    end

    return "Unclaimed"
end

------------------------------------------------
-- WAIT CLAIM RESULT
------------------------------------------------
local function waitForClaim(booth, timeout)
    local t = 0

    while t < timeout do
        local owner = getBoothOwnerFromSurfaceGui(booth)

        if owner ~= "Unclaimed" then
            return true
        end

        task.wait(0.5)
        t += 0.5
    end

    return false
end

------------------------------------------------
-- FIND BOOTH
------------------------------------------------
local function getValidBooth()
    local booths = workspace:WaitForChild("TradeWorld"):WaitForChild("Booths")

    for _, booth in ipairs(booths:GetChildren()) do
        local y = booth:GetPivot().Position.Y
        local owner = getBoothOwnerFromSurfaceGui(booth)

        if y < 1 and owner == "Unclaimed" then
            return booth
        end
    end

    return nil
end

------------------------------------------------
-- MAIN LOGIC
------------------------------------------------
if game.PlaceId ~= TRADE_WORLD_ID then
    travelEventToTrade:FireServer()
    print("Teleporting to Trade World...")

else
    task.wait(3)

    ------------------------------------------------
    -- STEP 1: CHECK BLACKLIST
    ------------------------------------------------
    local badPlayer = isBlacklistedPlayerPresent()

    if badPlayer then
        warn("Blacklisted player detected:", badPlayer)
        hopServer()
        return
    end

    ------------------------------------------------
    -- STEP 2: FIND BOOTH
    ------------------------------------------------
    local booth = getValidBooth()

    if not booth then
        warn("No empty booth → hopping server")
        hopServer()
        return
    end

    ------------------------------------------------
    -- STEP 3: CLAIM BOOTH
    ------------------------------------------------
    print("Trying to claim:", booth.Name)
    claimBoothEvent:FireServer(booth)

    ------------------------------------------------
    -- STEP 4: VERIFY CLAIM
    ------------------------------------------------
    local success = waitForClaim(booth, 5)

    if success then
        print("SUCCESS: Booth claimed")
    else
        warn("FAILED: claim gagal → hopping server")
        hopServer()
    end
end
