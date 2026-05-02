--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

local v0=game:GetService("Players");local v1=game:GetService("TeleportService");local v2=game:GetService("HttpService");local v3=v0.LocalPlayer;local function v4() local v6=0;for v8,v9 in ipairs(v3.Backpack:GetChildren()) do if v9:IsA("Tool") then v6+=1 end end if v3.Character then for v18,v19 in ipairs(v3.Character:GetChildren()) do if v19:IsA("Tool") then v6+=1 end end end return v6;end local function v5() local v7=game.PlaceId;v1.TeleportInitFailed:Connect(function(v10,v11,v12) warn("Teleport FAILED:",v11,v12);end);while true do warn("SEARCHING SERVER >20 PLAYERS...");local v13,v14=pcall(function() return v2:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"   .. v7   .. "/servers/Public?sortOrder=Desc&limit=100" ));end);local v15={};if (v13 and v14 and v14.data) then for v22,v23 in ipairs(v14.data) do if ((v23.playing>20) and (v23.playing<v23.maxPlayers) and (v23.id~=game.JobId)) then table.insert(v15,v23);end end end if ( #v15>0) then table.sort(v15,function(v24,v25) return v24.playing>v25.playing ;end);local v20=v15[math.random(1,math.min( #v15,5))];local v21=pcall(function() v1:TeleportToPlaceInstance(v7,v20.id,v3);end);if v21 then warn("Teleport attempted...");task.wait(5);else warn("Teleport failed, retrying...");end else warn("No valid server found, retry...");end task.wait(3);end end task.spawn(function() while true do local v16=v4();warn("Start item count:",v16);task.wait(1800);local v17=v4();warn("End item count:",v17);if (v17==v16) then warn("ITEM Tidak BERKURANG! SERVER HOP...");v5();else warn("masih laku.");end end end);
