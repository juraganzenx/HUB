--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

local v0=game:GetService("Players");local v1=game:GetService("HttpService");local v2="https://discord.com/api/webhooks/1457402756544598128/wFlBWO1pIlF6u41dJz40bvLKiI0xVwNk1l4QaId8O4W_ytwz6RT4b2SoHMenEE1KNOwK";local v3=(syn and syn.request) or (http and http.request) or http_request or request ;local v4=v0.LocalPlayer;local function v5(v6,v7) if  not v3 then local v10=0 + 0 ;while true do if (0==v10) then warn("Executor doesn't support HTTP requests");return;end end end local v8={embeds={{title="🚪 Local Player Left Game",description="**Player:** "   .. v6   .. "\n**UserId:** "   .. v7   .. "\n**Time:** "   .. os.date("%X") ,color=16754847 -(214 + 713) }}};pcall(function() v3({Url=v2,Method="POST",Headers={["Content-Type"]="application/json"},Body=v1:JSONEncode(v8)});end);end v0.PlayerRemoving:Connect(function(v9) if (v9==v4) then v5(v9.Name,v9.UserId);end end);print("Local Player Leave Discord Notifier Loaded");
