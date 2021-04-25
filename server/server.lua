-- OLD PERMISSIONS SYSTEM
--[[RegisterServerEvent("vehiclemenu:getIsAllowed")
AddEventHandler("vehiclemenu:getIsAllowed", function()
    if IsPlayerAceAllowed(source, "vehiclemenu.menu") then
        TriggerClientEvent("vehiclemenu:returnIsAllowed", source, true)
    else
        TriggerClientEvent("vehiclemenu:returnIsAllowed", source, false)
    end
end)]]

-- NEW PERMISSIONS SYSTEM
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("vehiclemenu:fetchUserRank", function(source, cb)
      local player = ESX.GetPlayerFromId(source)
  
      if player ~= nil then
          local playerGroup = player.getGroup()
          if playerGroup ~= nil then 
              cb(playerGroup)
          else
              cb("user")
          end
      else
          cb("user")
      end
  end)
