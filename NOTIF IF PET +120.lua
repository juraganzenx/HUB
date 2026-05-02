--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

local v0=game:GetService("Players");local v1=game:GetService("HttpService");local v2=v0.LocalPlayer;local v3="https://discord.com/api/webhooks/1457402756544598128/wFlBWO1pIlF6u41dJz40bvLKiI0xVwNk1l4QaId8O4W_ytwz6RT4b2SoHMenEE1KNOwK";warn("Script PET monitor started");local function v4() local v6=0;local function v7(v13,v14) if  not v13 then warn("Container tidak ada:",v14);return;end for v15,v16 in ipairs(v13:GetChildren()) do if v16:IsA("Tool") then local v17=v16:GetAttribute("PET_UUID");if v17 then warn("PET ditemukan:",v16.Name,v17);v6+=1 end end end end v7(v2:FindFirstChild("Backpack"),"Backpack");v7(v2.Character,"Character");warn("Total PET:",v6);return v6;end local function v5(v8) warn("Mencoba kirim webhook...");local v9={embeds={{title="🚨 PET ALERT",description="PET melebihi batas!",color=16711680,fields={{name="👤 Player",value=v2.Name,inline=true},{name="🆔 UserId",value=tostring(v2.UserId),inline=true},{name="🐾 Total PET",value=tostring(v8),inline=true}},footer={text="PET Monitor System"}}}};local v10,v11=pcall(function() request({Url=v3,Method="POST",Headers={["Content-Type"]="application/json"},Body=v1:JSONEncode(v9)});end);if v10 then warn("Webhook berhasil dikirim!");else warn("Webhook gagal:",v11);end end while true do warn("Checking PET...");local v12=v4();if (v12>120) then warn("PET > 120, kirim!");v5(v12);else warn("Masih di bawah batas:",v12);end task.wait(600);end
