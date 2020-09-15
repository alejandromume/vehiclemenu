RegisterServerEvent("vehiclemenu:getIsAllowed")
AddEventHandler("vehiclemenu:getIsAllowed", function()
    if IsPlayerAceAllowed(source, "vehiclemenu.menu") then
        TriggerClientEvent("vehiclemenu:returnIsAllowed", source, true)
    else
        TriggerClientEvent("vehiclemenu:returnIsAllowed", source, false)
    end
end)