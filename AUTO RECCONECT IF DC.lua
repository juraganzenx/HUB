--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

local v0=game:GetService("Players");local v1=game:GetService("TeleportService");local v2=game:GetService("GuiService");local v3=v0.LocalPlayer;local v4=game.PlaceId;local function v5() local v6,v7=pcall(function() v1:Teleport(v4,v3);end);if  not v6 then warn("Teleport gagal, retry...",v7);task.wait(2);v5();end end v2.ErrorMessageChanged:Connect(function() local v8=v2:GetErrorMessage();if v8 then v8=string.lower(v8);if (string.find(v8,"kicked") or string.find(v8,"disconnect") or string.find(v8,"shutdown") or string.find(v8,"error") or string.find(v8,"client") or string.find(v8,"server")) then v5();end end end);
